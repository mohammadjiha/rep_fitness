import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitova/features/workout/chest_screen/screen/workout_exercises.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../model/muscle_group.dart';
import '../widget/workout_card.dart';

class WorkOut extends StatefulWidget {
  static const String routName = 'WorkOut';
  const WorkOut({super.key});

  @override
  State<WorkOut> createState() => _WorkOutState();
}

class _WorkOutState extends State<WorkOut> {
  final MuscleGroupRepo repo = MuscleGroupRepo();

  final List<String> workoutImages = [
    'workout_chest.png',
    'workout_back.png',
    'workout_shoulders.png',
    'workout_arms.png',
    'workoutabs.png',
    'workout_leg.png',
  ];
  // final List<String> workoutTitles = [
  //   'Workout • Chest',
  //   'Workout • Back',
  //   'Workout • Shoulders',
  //   'Workout • Arms',
  //   'Workout • Abs',
  //   'Workout • Legs',
  // ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)],
          ),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Workout',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 6.h,
                    width: 13.w,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(59, 92, 13, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset('assets/image/notification.png'),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFF94F608).withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white.withOpacity(0.75)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // open filters bottom sheet
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.tune, color: const Color(0xFF94F608)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<MuscleGroup>>(
                  stream: repo.watchMuscleGroups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final groups = snapshot.data ?? [];

                    if (groups.isEmpty) {
                      return const Center(
                        child: Text(
                          'No muscle groups found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final g = groups[index];

                        return GestureDetector(
                          onTap: () {
                            print("Clicked muscle: ${g.id}");
                            Navigator.of(context).pushNamed(
                              WorkoutChest.routName,
                              arguments: g.id,
                            );
                          },
                          child: WorkoutCardG(
                            imagePath: workoutImages[index],
                            title: 'Workout • ${g.name}',
                            locked: false,
                            minutes: '60-90',
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
class MuscleGroupRepo {
  final _db = FirebaseFirestore.instance;

  Stream<List<MuscleGroup>> watchMuscleGroups() {
    return _db
        .collection('muscle group')
        .orderBy('order')
        .snapshots()
        .map((snap) {
      final all = snap.docs
          .map((d) => MuscleGroup.fromDoc(d.data(), d.id))
          .toList();
      return all.where((g) => g.isActive).toList();
    });
  }
}