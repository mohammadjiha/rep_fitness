import 'package:fitova/features/home/widget/show_today_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class DailyCommitmentCard extends StatefulWidget {
  final double percent; // 0.0 -> 1.0
  const DailyCommitmentCard({super.key, this.percent = 1.0});

  @override
  State<DailyCommitmentCard> createState() => _DailyCommitmentCardState();
}

class _DailyCommitmentCardState extends State<DailyCommitmentCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF94F608);
    const cardBg = Color(0xFF0B0F0A);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
          decoration: BoxDecoration(
            color: cardBg.withOpacity(0.65),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withOpacity(0.55), width: 1.4),

          ),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // ✅ Header (Title + Arrow)
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 1.w),
                  child: Row(
                    children: [
                      Text(
                        "Today Summary",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // سهم يدور
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 220),
                        turns: _expanded ? 0.5 : 0.0, // 0.5 = 180°
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: accent,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 1.2.h),
              _GlowDivider(),

              // ✅ Expand area (details)
              AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Column(
                  children: [
                    SizedBox(height: 2.h),

                    _StatRow(
                      icon: Icons.fitness_center,
                      text: 'Workout: Completed',
                      accent: accent,
                    ),
                    _LineDivider(),

                    _StatRow(
                      icon: Icons.restaurant,
                      text: 'Nutrition: On Track',
                      accent: accent,
                    ),
                    _LineDivider(),

                    _StatRow(
                      icon: Icons.water_drop_rounded,
                      text: 'Water: 2.5L',
                      accent: accent,
                    ),
                    _LineDivider(),

                    _StatRow(
                      icon: Icons.fastfood_rounded,
                      text: 'Protein: 120g   Carb: 220g',
                      accent: accent,
                    ),

                    SizedBox(height: 1.2.h),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 1.6.h),

              _PrimaryBtn(
                text: "View Achievements",
                accent: accent,
                onTap: () => showTodayDetailsSheet(context),
              ),

              SizedBox(height: 0.6.h),
            ],
          ),
        ),

        // TOP CHECK BADGE (زي ما عندك)
        Positioned(
          top: -22,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cardBg,
                border: Border.all(color: accent.withOpacity(0.8), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(Icons.check_rounded, color: accent, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}


// ======================= Helpers =======================

class _GlowDivider extends StatelessWidget {
  const _GlowDivider();

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF94F608);
    return Container(
      height: 2,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.transparent, accent, Colors.transparent],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _LineDivider extends StatelessWidget {
  const _LineDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.9.h),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accent;

  const _StatRow({
    required this.icon,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accent, size: 22),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String text;
  final Color accent;
  final VoidCallback onTap;

  const _PrimaryBtn({
    required this.text,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.2.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// class _SecondaryBtn extends StatelessWidget {
//   final String text;
//   final Color accent;
//   final VoidCallback onTap;
//
//   const _SecondaryBtn({
//     required this.text,
//     required this.accent,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 5.2.h,
//       child: OutlinedButton.icon(
//         onPressed: onTap,
//         icon: Icon(Icons.bar_chart, color: accent, size: 18),
//         label: Text(
//           text,
//           style: GoogleFonts.poppins(
//             textStyle: TextStyle(
//               fontSize: 13.sp,
//               color: Colors.white.withOpacity(0.85),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: Colors.white.withOpacity(0.12)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//       ),
//     );
//   }
// }
