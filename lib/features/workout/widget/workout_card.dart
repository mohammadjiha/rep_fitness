import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WorkoutCardG extends StatelessWidget {
  final String title;
  final String minutes;
  final bool locked;
  final String imagePath;

  const WorkoutCardG({
    super.key,
    required this.title,
    required this.minutes,
    required this.locked, required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/image/$imagePath',
              width: 38.4.w,
              fit: BoxFit.contain,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.3.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14.sp, color: Colors.white54),
                        SizedBox(width: 1.5.w),
                        Text(
                          "$minutes mins",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white60,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
