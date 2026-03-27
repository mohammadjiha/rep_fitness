import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class WidgetFitnessJourney extends StatelessWidget {
  const WidgetFitnessJourney({
    super.key,
    required this.imageName,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String imageName;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF94F608).withOpacity(0.25),
          width: 2,
        ),
        color: const Color.fromRGBO(131, 196, 39, 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            height: 9.h,
            width: 20.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF94F608).withOpacity(0.25),
                width: 2,
              ),
              color: const Color.fromRGBO(131, 196, 39, 0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Image.asset(
                'assets/image/$imageName',
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Texts
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  value, // مثال: 90 bpm
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  subtitle, // مثال: +16% from yesterday
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
