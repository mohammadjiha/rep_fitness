import 'package:fitova/core/constants/color.dart';
import 'package:fitova/features/exercisses/set_goal_muscle/screen/set_goal_muscle_screen.dart';
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

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: AppColors.kBackgroundGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              _HomeHeader(),
              SizedBox(height: 2.h),
              _SearchBar(),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _SectionHeader(title: 'Categories', onSeeAll: () {}),
                      SizedBox(height: 1.h),
                      _CategoriesRow(),
                      SizedBox(height: 3.h),
                      const DailyCommitmentCard(),
                      SizedBox(height: 2.h),
                      _SectionHeader(title: 'Popular Training', onSeeAll: () {}),
                      SizedBox(height: 2.h),
                      _PopularTrainingRow(),
                      SizedBox(height: 2.h),
                      _SectionHeader(title: 'Fitness Journey', onSeeAll: () {}),
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
                        title: 'Blood Pressure',
                        value: '120/80',
                        subtitle: '+16% from yesterday',
                      ),
                      SizedBox(height: 2.h),
                      _SectionHeader(title: 'Top Trainers', onSeeAll: () {}),
                      SizedBox(height: 2.h),
                      _TopTrainersRow(),
                      SizedBox(height: 2.h),
                    ],
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

// ─── Header ───────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar + name
        Expanded(
          child: Row(
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
                    style: _poppins(
                      fontSize: 15.sp,
                      color: AppColors.kPrimaryGreen,
                    ),
                  ),
                  Text(
                    'FitZone|Co:Ahmad',
                    style: _poppins(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Notification button
        _IconButton(iconAsset: 'assets/image/notification.png'),
        SizedBox(width: 4.w),

        // Chat button
        _IconButton(icon: Icons.chat_outlined),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final String? iconAsset;
  final IconData? icon;

  const _IconButton({this.iconAsset, this.icon})
      : assert(iconAsset != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 6.h,
      width: 13.w,
      decoration: BoxDecoration(
        color: AppColors.kDarkGreen,
        borderRadius: BorderRadius.circular(50),
      ),
      child: iconAsset != null
          ? Image.asset(iconAsset!)
          : Icon(icon, color: Colors.white),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.kPrimaryGreen.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white.withValues(alpha: 0.75)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // TODO: open filters bottom sheet
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.tune, color: AppColors.kPrimaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: _poppins(fontSize: 16.sp, color: Colors.white)),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'See All',
            style: _poppins(
              fontSize: 16.sp,
              color: AppColors.kPrimaryGreen,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Categories ───────────────────────────────────────────────────────────────

class _CategoriesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _CategoryItem('Workouts', 'workouts_image.png',
              () => Navigator.of(context).pushNamed(WorkOut.routName)),
      _CategoryItem('Exercises', 'Coach.png', ()=>
        Navigator.of(context).pushNamed(SetGoalMuscleScreen.routName)
      ),
      _CategoryItem('Nutrition', 'ni.png',
              () => Navigator.of(context).pushNamed(FoodSearchScreen.routName)),
      _CategoryItem('AI Trainer', 'bot.png', null),
      _CategoryItem('Progress', 'chart.png', null),
    ];

    return SizedBox(
      height: 13.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 3.w),
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: item.onTap,
            child: CategoriesContainer(
              title: item.title,
              imageName: item.imageName,
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final String imageName;
  final VoidCallback? onTap;
  const _CategoryItem(this.title, this.imageName, this.onTap);
}

// ─── Popular Training ─────────────────────────────────────────────────────────

class _PopularTrainingRow extends StatelessWidget {
  static const _trainings = [
    ('Skipping Training', 'Training', 'fit_individual_doing_sport.jpg'),
    ('Skipping Training', 'Training', 'fit_individual_doing_sport_.jpg'),
    (
    'Skipping Training',
    'Training',
    'full-body-portrait-athletic-shirtless-male-doing-biceps-workouts-with-dumbbells-gym-club.jpg'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _trainings.length,
        separatorBuilder: (_, __) => SizedBox(width: 5.w),
        itemBuilder: (context, i) {
          final t = _trainings[i];
          return PopularTraininngContuner(
            title: t.$1,
            subtitle: t.$2,
            imageAsset: t.$3,
          );
        },
      ),
    );
  }
}

// ─── Top Trainers ─────────────────────────────────────────────────────────────

class _TopTrainersRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 13.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => TopTraiers(
          imageName: 'ann_image.png',
          title: 'Angel',
          subtitle: 'Cardio',
        ),
      ),
    );
  }
}

// ─── Style Helper ─────────────────────────────────────────────────────────────

TextStyle _poppins({
  required double fontSize,
  required Color color,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
  );
}