import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitova/features/workout/screen/workout_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/exercise.dart';
import '../widget/program_card.dart';

class WorkoutChest extends StatelessWidget {
  static const String routName = 'WorkoutChest';
  WorkoutChest({super.key, });

  final ExerciseRepo repo = ExerciseRepo();

  @override
  Widget build(BuildContext context) {
    final muscleId = ModalRoute.of(context)?.settings.arguments as String? ?? 'chest';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text(
                    muscleId.toUpperCase(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 19.sp, color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 6.h,
                    width: 13.w,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(59, 92, 13, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset('assets/image/dots.png'),
                  ),
                ],
              ),

              Expanded(
                child: StreamBuilder<List<Exercise>>(
                  stream: repo.watchExercises(muscleId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                      );
                    }

                    final list = snapshot.data ?? [];
                    if (list.isEmpty) {
                      return const Center(
                        child: Text('No exercises found', style: TextStyle(color: Colors.white)),
                      );
                    }

                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        final ex = list[index];
                        debugPrint('=== ex.id: "${ex.id}" | ex.name: "${ex.name}"');

                        return GestureDetector(
                          onTap: () {
                            print("Received muscleId: $muscleId");

                            Navigator.of(context).pushNamed(
                              WorkoutSessionScreen.routName,
                              arguments: {
                                'muscleId': muscleId,
                                'exerciseId': ex.id,
                              },
                            );
                          },
                          child: ProgramCard(
                            title: ex.name,
                            imagePath: "assets/image/workout_chest.png",
                            level: ex.level.isNotEmpty ? ex.level : 'Beginner',
                            targetMuscles: ex.targetMuscles.isNotEmpty
                                ? ex.targetMuscles
                                : muscleId,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ExerciseRepo {
  final _db = FirebaseFirestore.instance;

  Stream<List<Exercise>> watchExercises(String muscleId) {
    return _db
        .collection('muscle group')
        .doc(muscleId)
        .collection('exercises')
        .orderBy('order')
        .snapshots()
        .map((snap) {
      final all = snap.docs.map((d) => Exercise.fromDoc(d.data(), d.id)).toList();
      return all.where((e) => e.isActive).toList();
    });
  }
}