import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import 'package:sizer/sizer.dart';

import 'check_email.dart';

class OtpScreen extends StatefulWidget {
  static const String routName = 'OtpScreen';

  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpTime = 60;
  int _secondsRemaining = _otpTime;
  Timer? _timer;
  bool _isExpired = false;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _isExpired = false;
    _secondsRemaining = _otpTime;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _isExpired = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _verifyOtp(String otp) {
    if (_isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرمز منتهي الصلاحية")),
      );
      return;
    }

    // هنا تحقق من الرمز من السيرفر
    print("OTP Entered: $otp");
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  final TextEditingController gymIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String email =
    ModalRoute.of(context)!.settings.arguments as String;
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
    );
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(43, 71, 3, 1),
              Color.fromRGBO(43, 71, 3, 1),
              Color.fromRGBO(43, 71, 3, 1),
              Color.fromRGBO(36, 58, 3, 1),
              Color.fromRGBO(34, 55, 3, 1),
              Colors.black.withOpacity(0.9),
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),

              Column(
                children: [
                  Row(

                    children: [
                      GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: Icon(Icons.arrow_back,
                        color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 17.w,),
                      Text.rich(
                        TextSpan(
                          text: 'Reset Password',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Stack(children: [
                    Center(child: Image.asset('assets/image/rectangle_reset_password.png')),
                    Positioned(
                        top: 4.h,
                        left: 37.w,
                        child: Center(child:Image.asset('assets/image/frame_rest_pass.png'),))
                  ],),
                  SizedBox(height: 4.h),
                ],
              ),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text:
                  'Please Enter The 4 Digit Code Sent To \n',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  children: [
                    TextSpan(
                      text: email,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color.fromRGBO(148, 246, 8, 1),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),
                    Pinput(
                      length: 4,
                      enabled: !_isExpired,
                      defaultPinTheme: defaultPinTheme,
                      onCompleted: _verifyOtp,
                    ),

                    const SizedBox(height: 20),

                    _isExpired
                        ? TextButton(
                      onPressed: _startTimer,
                      child: const Text(
                        "Resend Code",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                        : Text(
                      "Resend code in $_secondsRemaining s",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      // onPressed: _isExpired ? null : () {},
                        onPressed:   (){
                          Navigator.of(context).pushNamed(CheckEmail.routName);
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(148, 246, 8, 1),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Verify",
                      style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold

                      ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
