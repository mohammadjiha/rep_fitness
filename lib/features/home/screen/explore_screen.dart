import 'package:fitova/features/home/widget/calories_chart.dart';
import 'package:fitova/features/home/widget/calories_days_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../widget/widget_fitness_journey.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)
            ])
          ),
           child: SafeArea(child: Padding(padding:EdgeInsets.symmetric(horizontal: 5.w),
           child: Column(
           children: [
             Text(
               'Explore',
               style: GoogleFonts.poppins(
                 fontSize: 20.sp,
                 color: Colors.white,
                 fontWeight: FontWeight.w600,
               ),
             ),
             SizedBox(height: 2.h),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   'Weekly Summary',
                   style: GoogleFonts.poppins(
                     fontSize: 15.sp,
                     color: Colors.white,
                     fontWeight: FontWeight.w600,
                   ),
                 ),

                 Text(
                   'View Details',
                   style: GoogleFonts.poppins(
                     fontSize: 15.sp,
                     color: Color.fromRGBO(148, 246, 8, 1),
                     fontWeight: FontWeight.normal,
                   ),
                 ),
               ],
             ),
             SizedBox(height: 2.h),
             CaloriesDaysSelector(),
             SizedBox(height: 2.h),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   'Goal Progress',
                   style: GoogleFonts.poppins(
                     fontSize: 15.sp,
                     color: Colors.white,
                     fontWeight: FontWeight.w600,
                   ),
                 ),

                 Text(
                   'View Details',
                   style: GoogleFonts.poppins(
                     fontSize: 15.sp,
                     color: Color.fromRGBO(148, 246, 8, 1),
                     fontWeight: FontWeight.normal,
                   ),
                 ),
               ],
             ),
             SizedBox(height: 2.h),
             CaloriesChart(),
             SizedBox(height: 2.h),
             WidgetFitnessJourney(
               imageName: 'hart_rate.png',
               title: 'Heart Rate',
               value: '90 bpm',
               subtitle: '+16% from yesterday',
             ),
             SizedBox(height: 2.h),

             WidgetFitnessJourney(
               imageName: 'blood_preasure.png',
               title: 'Heart Rate',
               value: '90 bpm',
               subtitle: '+16% from yesterday',
             ),
             SizedBox(height: 2.h),
           ],
           ),
           )),
        ),
      ],
    );
  }
}