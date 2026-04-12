import 'package:flutter/material.dart';

import '../widget/start_workout_button.dart';
import '../widget/workout_top_bar.dart';

class SetupYourWorkout extends StatelessWidget {
  static const String routName = "SetupYourWorkout";
  const SetupYourWorkout({super.key});

  static const List<ExerciseData> exercises = [
    ExerciseData(
      name: 'Bench Press',
      category: 'COMPOUND',
      target: 'CHEST',
      weight: 80,
      reps: 10,
      sets: 4,
      isActive: true,
    ),
    ExerciseData(
      name: 'Incline Press',
      category: 'UPPER CHEST',
      target: 'STRENGTH',
      weight: 60,
      reps: 12,
      sets: 3,
      isActive: false,
    ),
    ExerciseData(
      name: 'Chest Flyes',
      category: 'ISOLATION',
      target: 'HYPERTROPHY',
      weight: 18,
      reps: 15,
      sets: 4,
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)],
          // ),
        ),
        child: Column(
          children: [
            const WorkoutTopBar(),
            const StepIndicator(currentStep: 3, totalSteps: 3),

            const StartWorkoutButton(),
          ],
        ),
      ),
    );
  }
}




// ─── Step Indicator ─────────────────────────────────────────────────────────

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'STEP $currentStep OF $totalSteps',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Setup Your Workout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (i) {
              final isActive = i < currentStep;
              return Container(
                width: isActive && i == currentStep - 1 ? 28 : 8,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFC8FF00)
                      : const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Exercise Data Model ─────────────────────────────────────────────────────

class ExerciseData {
  final String name;
  final String category;
  final String target;
  final double weight;
  final int reps;
  final int sets;
  final bool isActive;

  const ExerciseData({
    required this.name,
    required this.category,
    required this.target,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isActive,
  });
}

