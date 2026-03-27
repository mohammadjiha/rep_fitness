import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'create_new_password.dart' show CreateNewPassword;

class CheckEmail extends StatelessWidget {
  static const String routName = "CheckEmail";
  const CheckEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(52, 84, 5, 1),
              Color.fromRGBO(47, 78, 4, 1),
              Color.fromRGBO(43, 71, 3, 1),
              Color.fromRGBO(36, 58, 3, 1),
              Color.fromRGBO(34, 55, 3, 1),
              Color.fromRGBO(30, 48, 3, 1),
              Color.fromRGBO(27, 45, 3, 1),
              Color.fromRGBO(16, 26, 3, 1),
              Color.fromRGBO(33, 51, 5, 1),
              Color.fromRGBO(30, 38, 19, 1),
              Color.fromRGBO(30, 38, 19, 1),
              Color.fromRGBO(16, 25, 3, 1),
              Color.fromRGBO(22, 37, 3, 1),
              Color.fromRGBO(34, 55, 3, 1),
              Color.fromRGBO(39, 66, 3, 1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              /// App Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 17.w),
                  Text(
                    'Check Email',
                    style: GoogleFonts.poppins(
                      fontSize: 19.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              /// Image
              Image.asset('assets/image/check_Email.png'),

              SizedBox(height: 4.h),

              /// Text
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Check your email \n',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  children: [
                    TextSpan(
                      text:
                          'We have sent a password recovery instructions to your email.',
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(flex: 4,),

              /// Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CreateNewPassword.routName);                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(148, 246, 8, 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:  Text(
                  "Open Email",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(flex: 1,),

              Text(
                'Skip, I’ll confirm later',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(height: 2.h,),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Didn’t get the email? Check your spam folder or ',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  children: [
                    TextSpan(
                      text: 'use a different email address. ',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
