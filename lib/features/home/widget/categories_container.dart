import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CategoriesContainer extends StatelessWidget{
  final String title;
  final String imageName;
  const CategoriesContainer({super.key, required this.title, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          height: 9.h,
          width: 20.w,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF94F608).withOpacity(0.25),
                width: 2
            ),
            color: Color.fromRGBO(131, 196, 39, 0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset('assets/image/$imageName',

          ),
        ),
        SizedBox(height: 0.5.h),
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
      ],
    );
  }

}