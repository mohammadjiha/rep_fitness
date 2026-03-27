import 'package:fitova/core/constants/color.dart';
import 'package:fitova/features/home/screen/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../cache/chchehelper.dart';
import '../../../../core/constants/cachekey.dart' show CacheKeys;
import '../../enter_gym_id/screen/enter_gym_id.dart';
import '../../reset_password/screen/forget_password.dart';

class SignInScreen extends StatefulWidget {
  static const String routName = 'SignInScreen';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool rememberMe = false;
  String? _selectedGymName;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final gymName = CacheHelper.getString(CacheKeys.selectedGymName);
    final savedRemember = CacheHelper.getBool(CacheKeys.rememberMe) ?? false;

    if (savedRemember) {
      emailController.text = CacheHelper.getString(CacheKeys.savedEmail) ?? '';
      passwordController.text =
          await _secureStorage.read(key: CacheKeys.savedPassword) ?? '';
    }

    if (!mounted) return;
    setState(() {
      _selectedGymName = gymName;
      rememberMe = savedRemember;
    });
  }

  void showGreenSnack(String message) {
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

  Future<void> doLogin() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      showGreenSnack('Enter your email and password');
      return;
    }

    setState(() => loading = true);

    try {
      final selectedGymId = CacheHelper.getString(CacheKeys.selectedGymId);

      if (selectedGymId == null || selectedGymId.isEmpty) {
        showGreenSnack('Please enter the gym code first.');
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(EnterGymId.routName);
        return;
      }

      // 1) Firebase Auth login
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final uid = cred.user!.uid;

      // 2) Get user document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        throw Exception('The account is not linked to any data in the system.');
      }

      final userData = userDoc.data()!;
      final userGymId = userData['gymId'] as String?;
      final userRole = (userData['role'] as String?) ?? 'player';
      final userNumericId = (userData['numericId']?.toString()) ?? 'Not set';

      // 3) Check gym link
      if (userGymId == null || userGymId.isEmpty) {
        await FirebaseAuth.instance.signOut();
        throw Exception('This account is not linked to any club.');
      }

      if (userGymId != selectedGymId) {
        await FirebaseAuth.instance.signOut();
        throw Exception('This account does not belong to the current club.');
      }

      // 4) Save user info
      await CacheHelper.setString(CacheKeys.userRole, userRole);
      await CacheHelper.setString(CacheKeys.userNumericId, userNumericId);
      await CacheHelper.setString(CacheKeys.userEmail, email);
      await CacheHelper.setString(
        CacheKeys.userName,
        (userData['fullName'] ?? 'User').toString(),
      );

      // 5) Remember me
      await CacheHelper.setBool(CacheKeys.rememberMe, rememberMe);

      if (rememberMe) {
        await CacheHelper.setString(CacheKeys.savedEmail, email);
        await _secureStorage.write(
          key: CacheKeys.savedPassword,
          value: passwordController.text,
        );
      } else {
        await CacheHelper.remove(CacheKeys.savedEmail);
        await _secureStorage.delete(key: CacheKeys.savedPassword);
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(HomePageScreen.routName);
    } catch (e) {
      String msg = 'Login failed. Please try again.';

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          msg = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          msg = 'Incorrect password.';
        } else if (e.code == 'invalid-email') {
          msg = 'Invalid email address.';
        } else if (e.code == 'network-request-failed') {
          msg = 'Connection error. Check your internet connection.';
        } else if (e.code == 'too-many-requests') {
          msg = 'Too many attempts. Please try again later.';
        } else {
          msg = e.message ?? msg;
        }
      } else if (e is Exception) {
        msg = e.toString().replaceAll('Exception: ', '');
      }

      if (mounted) showGreenSnack(msg);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                Column(
                  children: [
                    if (_selectedGymName != null &&
                        _selectedGymName!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                        child: Text(
                          'Gym: $_selectedGymName',
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
                ),
                Align(
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
                        controller: emailController,
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
                        controller: passwordController,
                        hintText: 'Password',
                        iconAsset: 'assets/image/lock.png',
                        isPassword: true,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => rememberMe = !rememberMe),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.kPrimaryGreen,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: rememberMe
                                        ? AppColors.kPrimaryGreen
                                        : Colors.transparent,
                                  ),
                                  height: 1.8.h,
                                  width: 4.w,
                                  child: rememberMe
                                      ? const Icon(Icons.check,
                                      size: 14, color: Colors.black)
                                      : null,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Keep me logged in',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color:
                                    const Color.fromRGBO(255, 255, 255, 0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(ForgetPassword.routName),
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
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                GestureDetector(
                  onTap: loading ? null : doLogin,
                  child: Container(
                    alignment: Alignment.center,
                    height: 7.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.kPrimaryGreen,
                    ),
                    child: loading
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
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}