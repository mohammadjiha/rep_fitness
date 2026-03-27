import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ContainerSetYourGoalMuscle extends StatelessWidget{
  final String title;
  final String subTitle;
  final IconData iconContainer;
  final bool isSelected;
  const ContainerSetYourGoalMuscle({super.key, required this.title, required this.subTitle, required this.iconContainer, required this.isSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF1A2E1A) : Color(0xFF1E1E1E),
          border: isSelected ? Border.all(color: Color(0xFF7FFF00), width: 1.5)
              : null,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Color(0xFFCCFF00) : Colors.white,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  subTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 5.h,
              width: 11.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                  color:isSelected ? Color(0xFFCCFF00) : Color(0xFF2A2A2A),
              ),
              child: Icon(iconContainer,
                color:isSelected ? Colors.black : Colors.white54,
              ),
            )
          ],
        ),
      ),
    );
  }

}