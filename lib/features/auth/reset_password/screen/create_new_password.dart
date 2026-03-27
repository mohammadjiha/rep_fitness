import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CreateNewPassword extends StatefulWidget {
  static const String routName = 'CreateNewPassword';
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _formKey = GlobalKey<FormState>();

  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _passwordValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _confirmValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Confirm password is required';
    if (value != _passCtrl.text.trim()) return 'Passwords must be the same';
    return null;
  }

  Future<void> _onContinue() async {
    FocusScope.of(context).unfocus();

    // 1) Validate all fields
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 2) هنا مكان API / حفظ كلمة المرور
    // مثال:
    // final ok = await authController.resetPassword(_passCtrl.text.trim());
    // if (!ok) { show error; return; }

    // 3) Success popup مثل الصورة
    await _showSuccessDialog(context);

    // بعد ما يسكر الديالوج:
    // روح للهوم (بدّل route حسب مشروعك)
    // Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routName, (r) => false);
  }

  Future<void> _showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Stack(
            children: [
              // Blur خلف الكارد (قريب من شكل الصورة)
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1B).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 1.h),
                        // Icon Success
                         Center(
                            child: Container(
                              decoration: const BoxDecoration(
                              ),
                              child: Image.asset('assets/image/Illustrations.png'),
                            ),
                          ),

                        SizedBox(height: 2.h),

                        Text(
                          "Password Changed",
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        Text(
                          "You have successfully\nReset password for your account",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),

                        SizedBox(height: 2.2.h),

                        SizedBox(
                          width: double.infinity,
                          height: 6.2.h,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(148, 246, 8, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Back to Home",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _fieldDecoration({required String hint, required Widget prefix, Widget? suffix}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.10),
      contentPadding: EdgeInsets.symmetric(vertical: 2.2.h),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white30, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white30, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromRGBO(148, 246, 8, 1), width: 1.8),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 8.h),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 17.w),
                    Text(
                      'Reset Password',
                      style: GoogleFonts.poppins(
                        fontSize: 19.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),
                Stack(
                  children: [
                    Center(
                      child: Image.asset('assets/image/rectangle_reset_password.png'),
                    ),
                    Positioned(
                      top: 4.h,
                      left: 37.w,
                      child: Image.asset('assets/image/lock_create_new_password.png'),
                    ),
                  ],
                ),
                SizedBox(height:2.h),
                Text(
                  'Create your New Password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.white),
                ),

                SizedBox(height: 3.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password',
                      style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.white)),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure1,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white.withOpacity(0.4),
                  validator: _passwordValidator,
                  decoration: _fieldDecoration(
                    hint: '*********',
                    prefix: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Image.asset('assets/image/sms.png'),
                    ),
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                      icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Confirm Password',
                      style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.white)),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscure2,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white.withOpacity(0.4),
                  validator: _confirmValidator,
                  decoration: _fieldDecoration(
                    hint: '*********',
                    prefix: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Image.asset('assets/image/sms.png'),
                    ),
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                      icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70),
                    ),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(148, 246, 8, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 6.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
