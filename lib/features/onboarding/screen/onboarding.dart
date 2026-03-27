import 'package:fitova/cache/chchehelper.dart';
import 'package:fitova/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../service/firebase/model/firebase_onboarding_model.dart';
import '../../auth/enter_gym_id/screen/enter_gym_id.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routName = 'OnboardingScreen';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  late final Future<List<OnboardingPageModel>> _futurePages =
  fetchOnboardingPages();

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/image/side_view_woman_with_colored_background.jpg',
      'title':
      'Track your journey\n'
          'toward optimal health\n'
          'and well-being.',
      'subtitle':
      'Stay motivated and see how every step brings\n'
          'you closer to your wellness goals.',
    },
    {
      'image': 'assets/image/muscular_man_helping_woman_with_workouts.jpg',
      'title': 'Measure your growth\ntoward total wellbeing',
      'subtitle':
      'Stay motivated and see how every step brings\n'
          'you closer to your wellness goals.',
    },
    {
      'image': 'assets/image/good_looking_athletic_young_man_gym.jpg',
      'title': 'Maintain your focus to\nbuild a stronger way of\nliving.',
      'subtitle':
      'It offers customized plans for all fitness levels,\n'
          'helping you build strength, improve stamina,\n'
          'and stay consistently active.',
    },
  ];
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<OnboardingPageModel>>(
        future: _futurePages,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No onboarding data found'));
          }

          if (currentIndex >= items.length) currentIndex = 0;

          final current = items[currentIndex];

          return Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(pages[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      textAlign: TextAlign.center,
                      current.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      textAlign: TextAlign.center,
                      current.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        items.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == index ? 24 : 8,
                          height: 6,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? AppColors.kPrimaryGreen
                                : Colors.white30,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 6.h,
                            width: 40.w,
                            child: OutlinedButton(
                              onPressed: () {
                                _controller.jumpToPage(items.length - 1);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.kPrimaryGreen,
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                  color: AppColors.kPrimaryGreen,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Skip'),
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                            width: 40.w,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (currentIndex < items.length - 1) {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  CacheHelper.setBool('onboardingDone', true);
                                  if (!mounted) return;
                                  Navigator.pushReplacementNamed(
                                    context,
                                    EnterGymId.routName,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(148, 246, 8, 1),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                style: TextStyle(fontSize: 16.sp),
                                currentIndex == items.length - 1
                                    ? 'Start'
                                    : 'Continue',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}