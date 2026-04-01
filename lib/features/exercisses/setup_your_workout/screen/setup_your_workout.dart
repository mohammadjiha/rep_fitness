import 'package:flutter/material.dart';

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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    ExerciseCard(data: exercises[index]),
              ),
            ),
            const StartWorkoutButton(),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────

class WorkoutTopBar extends StatelessWidget {
  const WorkoutTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2209),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFFC8FF00),
                size: 16,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'CHEST DAY',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC8FF00),
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2209),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF6B8C3A),
              size: 20,
            ),
          ),
        ],
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

// ─── Exercise Card ───────────────────────────────────────────────────────────

class ExerciseCard extends StatelessWidget {
  final ExerciseData data;

  const ExerciseCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(16),
        border: data.isActive
            ? Border.all(color: const Color(0xFFC8FF00).withOpacity(0.4), width: 1)
            : Border.all(color: const Color(0xFF1E2810), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExerciseCardHeader(data: data),
          const SizedBox(height: 16),
          ExerciseMetricsRow(data: data),
        ],
      ),
    );
  }
}

// ─── Exercise Card Header ────────────────────────────────────────────────────

class ExerciseCardHeader extends StatelessWidget {
  final ExerciseData data;

  const ExerciseCardHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: TextStyle(
                    color: data.isActive ? Colors.white : const Color(0xFFAAAAAA),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ExerciseBadge(label: data.category, isAccent: data.isActive),
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                      style: TextStyle(color: Color(0xFF555555), fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    ExerciseBadge(label: data.target, isAccent: false),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2810),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              color: data.isActive
                  ? const Color(0xFFC8FF00)
                  : const Color(0xFF555555),
              size: 18,
            ),
          ),
        ],
    );
  }
}

// ─── Exercise Badge ──────────────────────────────────────────────────────────

class ExerciseBadge extends StatelessWidget {
  final String label;
  final bool isAccent;

  const ExerciseBadge({super.key, required this.label, required this.isAccent});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isAccent ? const Color(0xFFC8FF00) : const Color(0xFF666666),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ─── Exercise Metrics Row ────────────────────────────────────────────────────

class ExerciseMetricsRow extends StatelessWidget {
  final ExerciseData data;

  const ExerciseMetricsRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MetricField(
          label: 'Weight (kg)',
          value: data.weight % 1 == 0
              ? data.weight.toInt().toString()
              : data.weight.toString(),
          isHighlighted: data.isActive,
          flex: 2,
        ),
        const SizedBox(width: 10),
        MetricField(
          label: 'Reps',
          value: data.reps.toString(),
          isHighlighted: false,
          flex: 1,
        ),
        const SizedBox(width: 10),
        MetricField(
          label: 'Sets',
          value: data.sets.toString(),
          isHighlighted: false,
          flex: 1,
        ),
      ],
    );
  }
}

// ─── Metric Field ─────────────────────────────────────────────────────────────

class MetricField extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;
  final int flex;

  const MetricField({
    super.key,
    required this.label,
    required this.value,
    required this.isHighlighted,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? const Color(0xFF1A2209)
                  : const Color(0xFF0E1207),
              borderRadius: BorderRadius.circular(10),
              border: isHighlighted
                  ? Border.all(
                color: const Color(0xFFC8FF00).withOpacity(0.5),
                width: 1.5,
              )
                  : Border.all(color: const Color(0xFF1A2209), width: 1),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: isHighlighted ? Colors.white : const Color(0xFF777777),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Start Workout Button ────────────────────────────────────────────────────

class StartWorkoutButton extends StatelessWidget {
  const StartWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFC8FF00),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'START WORKOUT',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF1A1A1A),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}