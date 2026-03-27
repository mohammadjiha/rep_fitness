import 'package:fitova/features/home/widget/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool darkMode = true;
  String lang = "English (USA)";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back, color: Colors.white),
                Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Icon(Icons.edit_note_sharp, color: Colors.white),
              ],
            ),
            SizedBox(height: 2.h),
            Image.asset('assets/image/image_profile.png'),
            Text(
              'William Son',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Premium ',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
            SettingsCard(
              darkMode: darkMode,
              onDarkModeChanged: (v) => setState(() => darkMode = v),
              languageText: lang,
              onLanguageTap: () => setState(() {
                lang = (lang == "English (USA)") ? "Arabic (Jordan)" : "English (USA)";
              }),
              onWalletTap: () {},
              onNotificationTap: () {},
              onSubscribeTap: () {},
              onSecurityTap: () {},
              onPrivacyTap: () {},
              onLogoutTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
