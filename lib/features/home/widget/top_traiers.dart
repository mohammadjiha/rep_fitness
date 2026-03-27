import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:sizer/sizer.dart';

class TopTraiers extends StatelessWidget{
  const TopTraiers({super.key, required this.imageName, required this.title, required this.subtitle});
  final String imageName;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/image/$imageName'),
        Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

}