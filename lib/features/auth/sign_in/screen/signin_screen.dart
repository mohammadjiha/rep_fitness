import 'package:fitova/core/constants/color.dart';
import 'package:fitova/features/home/screen/home/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../core/controller/sign_in_controller.dart';
import '../../enter_gym_id/screen/enter_gym_id.dart';
import '../../reset_password/screen/forget_password.dart';

class SignInScreen extends StatefulWidget {
  static const String routName = 'SignInScreen';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final SignInController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignInController();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.loadSavedData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showGreenSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          alignment: Alignment.center,
          height: 6.h,
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.kPrimaryGreen,
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final error = await _controller.doLogin(
      onNavigateToGymId: () {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(EnterGymId.routName);
      },
      onNavigateToHome: () {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(HomePageScreen.routName);
      },
    );

    if (error != null && mounted) {
      _showGreenSnack(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1C2B06),
                Color(0xFF0B0F0A),
                Color(0xFF070A06),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                _buildHeader(),
                _buildForm(),
                const Spacer(flex: 2),
                _buildLoginButton(),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        if (_controller.selectedGymName != null &&
            _controller.selectedGymName!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
            child: Text(
              'Gym: ${_controller.selectedGymName}',
              style: TextStyle(
                color: AppColors.kPrimaryGreen,
                fontSize: 16.sp,
              ),
            ),
          ),
        Image.asset('assets/image/logo_lignin.png'),
        SizedBox(height: 1.h),
        Text.rich(
          TextSpan(
            text: 'Welcome to  ',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            children: [
              TextSpan(
                text: 'FITNESS',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColors.kPrimaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Text(
            'Your Email',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          AppTextField(
            controller: _controller.emailController,
            hintText: 'Enter email',
            iconAsset: 'assets/image/sms.png',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 2.h),
          Text(
            'Enter Password',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          AppTextField(
            controller: _controller.passwordController,
            hintText: 'Password',
            iconAsset: 'assets/image/lock.png',
            isPassword: true,
          ),
          SizedBox(height: 2.h),
          _buildRememberMeRow(),
        ],
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me checkbox
        GestureDetector(
          onTap: _controller.toggleRememberMe,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.kPrimaryGreen,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: _controller.rememberMe
                      ? AppColors.kPrimaryGreen
                      : Colors.transparent,
                ),
                height: 1.8.h,
                width: 4.w,
                child: _controller.rememberMe
                    ? const Icon(Icons.check, size: 14, color: Colors.black)
                    : null,
              ),
              SizedBox(width: 2.w),
              Text(
                'Keep me logged in',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Forgot password
        GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(ForgetPassword.routName),
          child: Text(
            'Forgot password?',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 16.sp,
                color: AppColors.kPrimaryGreen,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.kPrimaryGreen,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _controller.loading ? null : _handleLogin,
      child: Container(
        alignment: Alignment.center,
        height: 7.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.kPrimaryGreen,
        ),
        child: _controller.loading
            ? const CircularProgressIndicator()
            : Text(
          'Login',
          style: GoogleFonts.poppins(
            fontSize: 17.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}