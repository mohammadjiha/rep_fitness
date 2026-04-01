import 'package:fitova/core/controller/choose_muscle_controller/choose_muscle_bloc.dart';
import 'package:fitova/features/exercisses/setup_your_workout/screen/setup_your_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChooseMuscleScreen extends StatelessWidget {
  static const String routName = "ChooseMuscleScreen";
  const ChooseMuscleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MuscleSelectionScreen();
  }
}

class MuscleOption {
  final String name;
  final String category;
  final IconData icon;

  const MuscleOption({
    required this.name,
    required this.category,
    required this.icon,
  });
}

class MuscleSelectionScreen extends StatelessWidget {
  const MuscleSelectionScreen({super.key});

  static const List<MuscleOption> muscles = [
    MuscleOption(name: 'CHEST', category: 'PUSH', icon: Icons.fitness_center),
    MuscleOption(name: 'BACK', category: 'PULL', icon: Icons.accessibility_new),
    MuscleOption(name: 'SHOULDERS', category: 'PUSH', icon: Icons.sports_gymnastics),
    MuscleOption(name: 'LEGS', category: 'LOWER', icon: Icons.directions_run),
    MuscleOption(name: 'ARMS', category: 'ISOLATE', icon: Icons.sports_handball),
    MuscleOption(name: 'FULL BODY', category: 'HYBRID', icon: Icons.bolt),
  ];

  static const Color _bg = Color(0xFF0F1112);
  static const Color _card = Color(0xFF1A1D1F);
  static const Color _green = Color(0xFFB0F000);
  static const Color _textDim = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: BlocBuilder<ChooseMuscleBloc, int>(
          builder: (context, selectedIndex) {
            return Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(),
                        const SizedBox(height: 24),
                        Expanded(child: _buildGrid(context, selectedIndex)),
                        const SizedBox(height: 16),
                        _buildContinueButton(context),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF2A2D30),
              child: Icon(Icons.arrow_back, color: Colors.white70, size: 22),
            ),
          ),
          const Text(
            'KINETIC',
            style: TextStyle(
              color: _green,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.settings, color: Colors.white54, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'FOCUS SESSION',
          style: TextStyle(
            color: _green,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: "CHOOSE TODAY'S\n",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: 'MUSCLE',
                style: TextStyle(
                  color: _green,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Select your primary target for optimized\nenergy distribution.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _textDim, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, int selectedIndex) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: muscles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: (){
            return context.read<ChooseMuscleBloc>().onChooseMuscleTapped(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? _green : Colors.transparent,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                if (isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: _green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        muscles[index].icon,
                        color: isSelected ? _green : Colors.white70,
                        size: 32,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        muscles[index].name,
                        style: TextStyle(
                          color: isSelected ? _green : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        muscles[index].category,
                        style: const TextStyle(
                          color: _textDim,
                          fontSize: 11,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SetupYourWorkout.routName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CONTINUE',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}