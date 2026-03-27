import 'package:flutter/material.dart';

import '../../onboarding/screen/onboarding.dart' show OnboardingScreen;


class SplashScreen extends StatefulWidget {
  static const String routName = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        OnboardingScreen.routName,
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:Alignment.topCenter,
            end: Alignment.bottomLeft,
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
        child: Center(child: Image.asset('assets/image/Logo.png')),
      ),
    );
  }
}
