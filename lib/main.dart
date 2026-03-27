import 'package:firebase_core/firebase_core.dart';
import 'package:fitova/cache/chchehelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:get/get.dart' hide ScreenType;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_transitions.dart';
import 'features/auth/enter_gym_id/screen/enter_gym_id.dart';
import 'features/auth/reset_password/screen/check_email.dart';
import 'features/auth/reset_password/screen/create_new_password.dart';
import 'features/auth/reset_password/screen/forget_password.dart';
import 'features/auth/reset_password/screen/reset_password.dart';
import 'features/auth/sign_in/screen/signin_screen.dart' show SignInScreen;
import 'features/nutrition/screen/food_scan_screen.dart';
import 'features/nutrition/screen/food_search.dart';
import 'features/onboarding/screen/onboarding.dart' show OnboardingScreen;
import 'firebase_options.dart';



import 'features/home/screen/home_page_screen.dart';
import 'features/splash/screen/splash_screen.dart';

import 'features/workout/screen/workout.dart';
import 'features/workout/screen/workout_session_screen.dart';
import 'features/workout/chest_screen/screen/workout_exercises.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await dotenv.load(fileName: "assets/env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
   // DevicePreview(enabled: !kReleaseMode, builder: (context) => const
    MyApp()
 // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fitova',
          theme: ThemeData(useMaterial3: false),
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          useInheritedMediaQuery: true,
          home: const StartGate(),
          onGenerateRoute: (settings) {
            Widget page;

            if (settings.name == SplashScreen.routName) {
              page = const SplashScreen();
            } else if (settings.name == OnboardingScreen.routName) {
              page = const OnboardingScreen();
            } else if (settings.name == SignInScreen.routName) {
              page = const SignInScreen();
            } else if (settings.name == EnterGymId.routName) {
              page = const EnterGymId();
            } else if (settings.name == OtpScreen.routName) {
              page = const OtpScreen();
            } else if (settings.name == ForgetPassword.routName) {
              page = const ForgetPassword();
            } else if (settings.name == CheckEmail.routName) {
              page = const CheckEmail();
            } else if (settings.name == CreateNewPassword.routName) {
              page = const CreateNewPassword();
            } else if (settings.name == HomePageScreen.routName) {
              page = const HomePageScreen();
            } else if (settings.name == WorkOut.routName) {
              page = const WorkOut();
            } else if (settings.name == WorkoutSessionScreen.routName) {
              page = const WorkoutSessionScreen();
            } else if (settings.name == WorkoutChest.routName) {
              page = WorkoutChest();
            } else if (settings.name == NutritionScreen.routName) {
              page = NutritionScreen();
            } else if (settings.name == FoodSearchScreen.routName) {
              page = const FoodSearchScreen();
            } else {
              page = const SplashScreen();
            }

            return AppTransitions.fadeScale(page);
          },
        );
      },
    );
  }
}

class FoodScanScreen {
}

class StartGate extends StatelessWidget {
  const StartGate({super.key});

  Future<Widget> _decideStart() async {
    // لأول مرة — ما خلّص الـ onboarding بعد
    final onboardingDone = CacheHelper.getBool('onboardingDone') ?? false;
    if (!onboardingDone) {
      return const OnboardingScreen();
    }

    // خلّص الـ onboarding — نشوف إذا حاط gym id قبل
    final gymId = CacheHelper.getString('selectedGymId') ?? '';
    if (gymId.isEmpty) {
      return const EnterGymId();
    }

    // عنده gym id — يروح للـ sign in
    return const SignInScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _decideStart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data ?? const EnterGymId();
      },
    );
  }
}
