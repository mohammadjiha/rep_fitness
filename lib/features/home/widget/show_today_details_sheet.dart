import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showTodayDetailsSheet(BuildContext context) {
  const accent = Color(0xFF94F608);
  const bg = Color(0xFF0B0F0A);

  final size = MediaQuery.of(context).size;
  final w = size.width;
  final h = size.height;

  // Responsive sizes
  final titleSize = (w * 0.05).clamp(16.0, 20.0);
  final subSize = (w * 0.032).clamp(11.0, 13.0);
  final sectionSize = (w * 0.04).clamp(13.0, 15.0);
  final btnTextSize = (w * 0.038).clamp(13.0, 15.0);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.40,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.fromLTRB(18, 10, 18, 18),
            decoration: BoxDecoration(
              color: bg.withOpacity(0.98),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              border: Border.all(color: accent.withOpacity(0.35), width: 1),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.18),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: w * 0.18,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Top Title (Today Details + X)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Today Details",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.close, color: Colors.white.withOpacity(0.75)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // Header Card (check + date)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accent.withOpacity(0.12)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withOpacity(0.16),
                          border: Border.all(color: accent.withOpacity(0.7)),
                        ),
                        child: const Icon(Icons.check_rounded, color: accent),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Completed",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: sectionSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "02 Feb 2026",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.60),
                                  fontSize: subSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                _GlowDividerLine(),

                const SizedBox(height: 18),

                // Summary title
                Text(
                  "Summary",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: sectionSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Summary grid 2x2
                LayoutBuilder(
                  builder: (context, c) {
                    final itemW = (c.maxWidth - 12) / 2;
                    final itemH = (itemW * 0.55).clamp(64.0, 82.0);

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: itemW,
                          height: itemH,
                          child: const _MiniStat(
                            icon: Icons.local_fire_department,
                            title: "Streak",
                            value: "7 days",
                          ),
                        ),
                        SizedBox(
                          width: itemW,
                          height: itemH,
                          child: const _MiniStat(
                            icon: Icons.timer,
                            title: "Workout",
                            value: "45 min",
                          ),
                        ),
                        SizedBox(
                          width: itemW,
                          height: itemH,
                          child: const _MiniStat(
                            icon: Icons.whatshot,
                            title: "Calories",
                            value: "520 kcal",
                          ),
                        ),
                        SizedBox(
                          width: itemW,
                          height: itemH,
                          child: const _MiniStat(
                            icon: Icons.water_drop,
                            title: "Water",
                            value: "2.5L",
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 18),

                // Macros
                Text(
                  "Macros",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: sectionSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const _MacroBar(title: "Protein", current: 120, target: 140),
                const SizedBox(height: 12),
                const _MacroBar(title: "Carbs", current: 220, target: 250),
                const SizedBox(height: 12),
                const _MacroBar(title: "Fat", current: 55, target: 60),

                const SizedBox(height: 18),

                // Workout Details
                Text(
                  "Workout Details",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: sectionSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const _DetailTile(
                  title: "Upper Body Blast",
                  subtitle: "5 exercises • 4 sets each",
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 10),
                const _DetailTile(
                  title: "Coach Notes",
                  subtitle: "Great form today — increase weight next session.",
                  icon: Icons.message,
                ),

                SizedBox(height: h * 0.02),

                // Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Weekly Progress",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: btnTextSize,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _GlowDividerLine extends StatelessWidget {
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
            color: accent.withOpacity(0.55),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF94F608);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white.withOpacity(0.70),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String title;
  final int current;
  final int target;

  const _MacroBar({
    required this.title,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF94F608);
    final p = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Text(
              "$current / $target g",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: p,
            minHeight: 10,
            backgroundColor: Colors.white.withOpacity(0.10),
            valueColor: const AlwaysStoppedAnimation(accent),
          ),
        ),
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _DetailTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF94F608);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
