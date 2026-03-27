import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SnakBarInterGymCode extends StatelessWidget {
  final String errorTitle;
  const SnakBarInterGymCode({super.key, required this.errorTitle});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Container(
        alignment: Alignment.center,
        height: 6.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(148, 246, 8, 1),
        ),
        child: Text(
          errorTitle,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}