import 'package:fitova/features/home/screen/profile_screen.dart';
import 'package:fitova/features/home/screen/scan_screen.dart';
import 'package:fitova/features/home/widget/categories_container.dart';
import 'package:fitova/features/home/widget/daily_commitment_card.dart';
import 'package:fitova/features/home/widget/popular_traininng_contuner.dart';
import 'package:fitova/features/home/widget/top_traiers.dart';
import 'package:fitova/features/home/widget/widget_fitness_journey.dart';
import 'package:fitova/features/nutrition/screen/food_search.dart';
import 'package:fitova/features/workout/screen/workout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../widget/gym_chat_screen.dart';
import 'explore_screen.dart';

class HomePageScreen extends StatefulWidget {
  static const String routName = 'HomePageScreen';
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _index = 0;
  final List<Widget> _pages = const [
    HomePageScreen1(),
    ExploreScreen(),
    ScanScreen(),
    ProfileScreen(),
    GymChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2B06),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: SafeArea(
          top: false,
          bottom: true,
          child: SizedBox(
            height: 10.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 1.2.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 18,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(
                          label: "Home",
                          iconAsset: "assets/image/home.png",
                          selected:_index==0,
                          onTap: () {
                            setState(() {
                              _index=0;
                            });
                          },
                        ),
                        _NavItem(
                          label: "Explore",
                          iconAsset: "assets/image/calendar.png",
                          selected: _index==1,
                          onTap: () {
                            setState(() {
                              _index=1;
                            });
                          },
                        ),
                        SizedBox(width: 18.w),
                        _NavItem(
                          label: "Scan",
                          iconAsset: "assets/image/scan_Icon.png",
                          selected: _index==2,
                          onTap: () {
                            setState(() {
                              _index=2;
                            });
                          },
                        ),
                        _NavItem(
                          label: "Profile",
                          iconAsset: "assets/image/profile.png",
                          selected: _index==3,
                          onTap: () {
                            setState(() {
                              _index=3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -4.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                       onTap: () => setState(() => _index = 4),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(148, 246, 8, 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Image.asset(
                            "assets/image/botgym.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.8.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Fit Bot",
                      style: TextStyle(
                        color: Color.fromRGBO(164, 162, 162, 1),
                        fontSize: 15.sp,
                        // color: _index == 2 ? accent : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: IndexedStack(
        index: _index,
        children:_pages,
      ),
    );
  }
}
class HomePageScreen1 extends StatelessWidget{
  const HomePageScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(height: 6.h),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      height: 5.7.h,
                      width: 13.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Image.asset('assets/image/ann_image.png'),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello MO |AC',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: Color.fromRGBO(148, 246, 8, 1),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          'FitZone|Co:Ahmad',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 10.w),

                Container(
                  alignment: Alignment.center,
                  height: 6.h,
                  width: 13.w,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(59, 92, 13, 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset('assets/image/notification.png'),
                ),
                SizedBox(width: 4.w),
                Container(
                  alignment: Alignment.center,

                  height: 6.h,
                  width: 13.w,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(59, 92, 13, 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.chat_outlined, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: const Color(0xFF94F608).withOpacity(0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.white.withOpacity(0.75)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // open filters bottom sheet
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.tune, color: const Color(0xFF94F608)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),

                        Text(
                          'See all',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Color.fromRGBO(148, 246, 8, 1),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    SizedBox(
                      height: 13.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap:(){
                              Navigator.of(context).pushNamed(WorkOut.routName);
                            },
                            child: CategoriesContainer(
                              title: 'Workouts',
                              imageName: 'workouts_image.png',
                            ),
                          ),
                          SizedBox(width: 3.w),
                          CategoriesContainer(
                            title: "Exercises",
                            imageName: 'Coach.png',
                          ),
                          SizedBox(width: 3.w),
                          GestureDetector(
                            onTap: (){Navigator.of(context).pushNamed(FoodSearchScreen.routName);},
                            child: CategoriesContainer(
                              title: "Nutrition",
                              imageName: 'ni.png',
                            ),
                          ),
                          SizedBox(width: 3.w),
                          CategoriesContainer(
                            title: "AI Trainer",
                            imageName: 'bot.png',
                          ),
                          SizedBox(width: 3.w),
                          CategoriesContainer(
                            title: "Progress",
                            imageName: 'chart.png',
                          ),
                          SizedBox(width: 3.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    DailyCommitmentCard(),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Training',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Color.fromRGBO(148, 246, 8, 1),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 230,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          PopularTraininngContuner(
                            title: 'Skipping Training',
                            subtitle: 'Training',
                            imageAsset: 'fit_individual_doing_sport.jpg',
                          ),
                          SizedBox(width: 5.w),
                          PopularTraininngContuner(
                            title: 'Skipping Training',
                            subtitle: 'Training',
                            imageAsset: 'fit_individual_doing_sport_.jpg',
                          ),
                          SizedBox(width: 5.w),
                          PopularTraininngContuner(
                            title: 'Skipping Training',
                            subtitle: 'Training',
                            imageAsset:
                            'full-body-portrait-athletic-shirtless-male-doing-biceps-workouts-with-dumbbells-gym-club.jpg',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fitness Journey',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Color.fromRGBO(148, 246, 8, 1),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    WidgetFitnessJourney(
                      imageName: 'hart_rate.png',
                      title: 'Heart Rate',
                      value: '90 bpm',
                      subtitle: '+16% from yesterday',
                    ),
                    SizedBox(height: 2.h),

                    WidgetFitnessJourney(
                      imageName: 'blood_preasure.png',
                      title: 'Heart Rate',
                      value: '90 bpm',
                      subtitle: '+16% from yesterday',
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Trainers',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Color.fromRGBO(148, 246, 8, 1),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 13.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          return TopTraiers(
                            imageName: 'ann_image.png',
                            title: 'Angel',
                            subtitle: 'Cardio',
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
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
    const accent = Color(0xFF94F608);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconAsset, color: selected ? accent : Colors.white60),
          SizedBox(height: 0.6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: selected ? accent : Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
