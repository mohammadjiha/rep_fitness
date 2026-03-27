import 'package:fitova/features/auth/reset_password/screen/reset_password.dart' show OtpScreen;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class ForgetPassword extends StatefulWidget {
  static const String routName = 'ForgetPassword';
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }
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
                          text: 'Forget Password',
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
                  SizedBox(height: 5.h),
                  Image.asset('assets/image/Logo.png'),
                  SizedBox(height: 5.h),

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
                      TextSpan(text:'example@email.com',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Color.fromRGBO(148, 246, 8, 1),
                            ),
                          )
                      ),
                      TextSpan(text:'  your email ',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          )
                      )
                    ]
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    Text(
                      'Your email',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(

                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white.withOpacity(0.1),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        contentPadding: EdgeInsets.symmetric(vertical: 2.5.h),
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white30,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Image.asset('assets/image/sms.png'),
                        hintText: 'Enter your email',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () {
                        final email = emailController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email cannot be empty'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (!isValidEmail(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid email address'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // ✅ الإيميل صحيح → انتقل
                        Navigator.of(context).pushNamed(
                          OtpScreen.routName,
                          arguments: email,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 7.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color.fromRGBO(148, 246, 8, 1),
                        ),

                           child:   Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
