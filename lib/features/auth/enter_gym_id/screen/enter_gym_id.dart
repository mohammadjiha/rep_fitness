import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import '../../../../../core/widgets/snack_bar text_field.dart';
import '../../../../cache/chchehelper.dart' show CacheHelper;
import '../../sign_in/screen/signin_screen.dart';
import '../../../../../core/utils/digits_formatter.dart';

class EnterGymId extends StatefulWidget {
  static const String routName = 'EnterGymId';
  const EnterGymId({super.key});

  @override
  State<EnterGymId> createState() => _EnterGymIdState();
}

class _EnterGymIdState extends State<EnterGymId> {
  bool _loading = false;

  final TextEditingController gymIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
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
                    Text.rich(
                      TextSpan(
                        text: 'Enter Gym ID',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Image.asset('assets/image/Logo.png'),
                    SizedBox(height: 1.h),
                  ],
                ),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text:
                        'This ID links your account to the correct\n'
                        ' gym and unlocks its workouts, coaches,\n'
                        'and services.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        'Gym ID',
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
                        controller: gymIdController,
                        inputFormatters: [
                          DigitsOnlyWithSnackBarFormatter(context),
                        ],
                        keyboardType: TextInputType.number,
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
                          hintText: 'Enter ID',
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                GestureDetector(
                  onTap: () async {
                    if (_loading) return;
                    final codeText = gymIdController.text.trim();
                    if (codeText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnakBarInterGymCode(errorTitle: 'Please enter Gym ID')
                            as SnackBar,
                      );
                      return;
                    }
                    final gymCode = int.tryParse(codeText);
                    if (gymCode == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnakBarInterGymCode(
                              errorTitle: 'Gym ID must be numbers only',
                            )
                            as SnackBar,
                      );
                      return;
                    }
                    setState(() => _loading = true);
                    try {
                      final qs = await FirebaseFirestore.instance
                          .collection('gyms')
                          .where('gymCode', isEqualTo: gymCode)
                          .limit(1)
                          .get();
                      if (qs.docs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnakBarInterGymCode(
                                errorTitle:
                                    'The club does not exist. Please make sure the code is correct: $gymCode',
                              )
                              as SnackBar,
                        );
                        return;
                      }
                      final gymDoc = qs.docs.first;
                      final gymId = gymDoc.id;
                      final gymName = gymDoc['name'] ?? 'بدون اسم';
                      // حفظ بيانات النادي
                      await CacheHelper.setString('selectedGymId', gymId);
                      await CacheHelper.setInt('selectedGymCode', gymCode);
                      await CacheHelper.setString('selectedGymName', gymName);
                      if (!mounted) return;
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(SignInScreen.routName);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnakBarInterGymCode(errorTitle: 'Connection error:$e')
                            as SnackBar,
                      );
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 7.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromRGBO(148, 246, 8, 1),
                    ),
                    child: _loading
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Join Gym',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),

                Spacer(flex: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
