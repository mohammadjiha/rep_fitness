import 'package:fitova/core/constants/color.dart';
import 'package:fitova/features/home/screen/home/home_content_screen.dart';
import 'package:fitova/features/home/screen/profile_screen.dart';
import 'package:fitova/features/home/screen/scan_screen.dart';
import 'package:fitova/features/home/screen/explore_screen.dart';
import 'package:fitova/features/home/widget/gym_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePageScreen extends StatefulWidget {
  static const String routName = 'HomePageScreen';
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomeContentScreen(),
    ExploreScreen(),
    ScanScreen(),
    ProfileScreen(),
    GymChatScreen(),
  ];

  void _onNavTap(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBackground,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _index,
        onTap: _onNavTap,
      ),
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 10.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Nav items row
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.only(bottom: 1.2.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 18,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        label: 'Home',
                        iconAsset: 'assets/image/home.png',
                        selected: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                      _NavItem(
                        label: 'Explore',
                        iconAsset: 'assets/image/calendar.png',
                        selected: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                      // Center spacer for FAB
                      SizedBox(width: 18.w),
                      _NavItem(
                        label: 'Scan',
                        iconAsset: 'assets/image/scan_Icon.png',
                        selected: currentIndex == 2,
                        onTap: () => onTap(2),
                      ),
                      _NavItem(
                        label: 'Profile',
                        iconAsset: 'assets/image/profile.png',
                        selected: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),
                    ],
                  ),
                ),
              ),

              // Center FAB (FitBot)
              Positioned(
                top: -4.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => onTap(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.kPrimaryGreen,
                          ),
                          padding: EdgeInsets.all(3.w),
                          child: Image.asset('assets/image/botgym.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // FitBot label
              Positioned(
                bottom: 0.8.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Fit Bot',
                    style: TextStyle(
                      color: currentIndex == 4
                          ? AppColors.kPrimaryGreen
                          : const Color(0xFFA4A2A2),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Nav Item Widget ──────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconAsset,
            color: selected ? AppColors.kPrimaryGreen : Colors.white60,
          ),
          SizedBox(height: 0.6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: selected ? AppColors.kPrimaryGreen : Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}