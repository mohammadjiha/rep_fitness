import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.title,
    required this.minutes,
    required this.progress, // 0.0 -> 1.0
    required this.imagePath,
  });

  final String title;
  final int minutes;
  final double progress;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF94F608);

    return Container(
      width: 62.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(131, 196, 39, 0.05),
        border: Border.all(color: accent.withOpacity(0.25), width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child:
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.10),
                    child: Image.asset(
                      'assets/image/$imagePath',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white.withOpacity(0.5),
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 1.2.h),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 0.6.h),

                Row(

                  children: [
                    Icon(Icons.access_time,
                        size: 18.sp, color: Colors.white.withOpacity(0.65)),
                    SizedBox(width: 1.5.w),
                    Text(
                      '$minutes mins',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.65),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 25.w),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 3,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation(accent),
                        ),
                        Text(
                          '${(progress ).round()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),

          // Right progress ring

    );
  }
}
