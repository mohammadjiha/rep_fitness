import 'package:fitova/core/constants/color.dart';
import 'package:fitova/features/exercisses/chooes_muscle/screen/choose_muscle.dart';
import 'package:fitova/features/exercisses/set_goal_muscle/widget/container_set_your_goal_muscle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/controller/set_goal_muscle_controller/bloc/container_set_goal_muscle_bloc.dart';

class SetGoalMuscleScreen extends StatelessWidget {
  static const String routName = 'SetGoalMuscleScreen';

  const SetGoalMuscleScreen({super.key});

  final goals = const [
    {
      'title': 'Build Muscle',
      'subTitle': 'Hypertrophy & Size',
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Strength',
      'subTitle': 'Power & Performance',
      'icon': Icons.bolt,
    },
    {
      'title': 'Fat Loss',
      'subTitle': 'Tone & Definition',
      'icon': Icons.local_fire_department,
    },
    {
      'title': 'Endurance',
      'subTitle': 'Stamina & Recovery',
      'icon': Icons.timer,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Goal Muscle',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.kPrimaryGreen,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: AppColors.kPrimaryGreen),
        ),
      ),
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
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: BlocBuilder<ContainerSetGoalMuscleBloc, int>(
            builder: (context, selectedIndex) {
              return Column(
                children: [
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Set Your Goal\n',
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'for This Muscle\n',
                          style: GoogleFonts.poppins(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kPrimaryGreen,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Choose your focus to optimize your training path.',
                          style: GoogleFonts.poppins(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5F5E5E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...List.generate(
                    goals.length,
                    (index) => GestureDetector(
                      onTap: () {
                        context.read<ContainerSetGoalMuscleBloc>().onGoalTapped(index);
                      },
                      child: Column(
                        children: [
                          ContainerSetYourGoalMuscle(
                            title: goals[index]['title'] as String,
                            subTitle: goals[index]['subTitle'] as String,
                            iconContainer:
                                goals[index]['icon'] as IconData,
                            isSelected: selectedIndex == index,
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'System State',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kPrimaryGreen,
                            ),
                          ),
                          Text(
                            'READY FOR INPUT',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5F5E5E),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Muscle Volume',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kPrimaryGreen,
                            ),
                          ),
                          Text(
                            'HIGH CAPACITY',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5F5E5E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(ChooseMuscleScreen.routName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 8.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryGreen,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
