import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WorkoutSessionScreen extends StatelessWidget {
  static String routName = 'WorkoutSessionScreen';
  const WorkoutSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final muscleId = args['muscleId'] as String? ?? 'chest';
    final exerciseId = args['exerciseId'] as String? ?? '';

    final docStream = FirebaseFirestore.instance
        .collection('muscle group')
        .doc(muscleId)
        .collection('exercises')
        .doc(exerciseId)
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: docStream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }
        if (!snap.hasData || !snap.data!.exists) {
          return const Scaffold(body: Center(child: Text('Exercise not found')));
        }

        final data = snap.data!.data() ?? {};

        // ✅ Firestore data
        final String name = (data['name'] ?? exerciseId).toString();
        final String level = (data['level'] ?? '').toString();
        final String imageUrl = (data['imageUrl'] ?? '').toString();
        final String notes = (data['notes'] ?? '').toString();
        final String videoUrl = (data['videoUrl'] ?? '').toString();

        final List<String> howTo =
        (data['howTo'] is List) ? List<String>.from(data['howTo']) : <String>[];

        final List<String> equipmentList =
        (data['equipment'] is List) ? List<String>.from(data['equipment']) : <String>[];

        final String equipmentText =
        equipmentList.isEmpty ? '' : equipmentList.join(', ');

        final List<String> secondary =
        (data['secondaryMuscles'] is List)
            ? List<String>.from(data['secondaryMuscles'])
            : <String>[];

        final dynamic t = data['targetMuscles'];
        final String target = (t is List) ? List<String>.from(t).join(', ') : (t ?? '').toString();

        // ✅ recommendedSetsReps map
        final Map<String, dynamic> rec =
        (data['recommendedSetsReps'] is Map)
            ? Map<String, dynamic>.from(data['recommendedSetsReps'])
            : <String, dynamic>{};

        final int sets = int.tryParse('${rec['sets'] ?? rec['set'] ?? 0}') ?? 0;
        final String reps = (rec['reps'] ?? rec['rep'] ?? '').toString();
        final String rest = (rec['rest'] ?? '').toString();

        // UI constants
        const accent = Color(0xFF9AFF00);
        const bg = Color(0xFF070A03);

        final size = MediaQuery.sizeOf(context);
        final w = size.width;
        final h = size.height;

        final double pad = (w * 0.045).toDouble();
        final double cardH = (h * 0.28).toDouble();
        // final double ringSize = min(w * 0.72, 280.0).toDouble();

        final double titleSize = (w * 0.07).toDouble();
        final double subSize = (w * 0.04).toDouble();
        // final double bigNumSize = (w * 0.16).toDouble();

        final double btnH = max(48.0, h * 0.06).toDouble();
        final double radiusBig = (w * 0.07).toDouble();

        final String headerImage = imageUrl;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(pad),
              child: Column(
                children: [
                  // ✅ CARD (Image URL)
                  Container(
                    height: cardH,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radiusBig),
                      color: Colors.white10,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          headerImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.white10,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image,
                                color: Colors.white54, size: 42),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.10),
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(pad),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: h * 0.004),
                              Text(
                                [target, equipmentText, level]
                                    .where((e) => e.trim().isNotEmpty)
                                    .join(' • '),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: subSize,
                                ),
                              ),
                              const Spacer(),

                              Center(
                                child: InkWell(
                                  onTap: () {
                                    _openHowToSheet(
                                      context,
                                      accent: accent,
                                      title: name,
                                      steps: howTo,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.10,
                                      vertical: h * 0.012,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.play_arrow,
                                            color: Colors.black, size: w * 0.055),
                                        SizedBox(width: w * 0.02),
                                        Text(
                                          "HOW TO",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: subSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.015),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: w * 0.02,
                            runSpacing: h * 0.01,
                            children: [
                              if (equipmentText.isNotEmpty)
                                _InfoChip(
                                  text: equipmentText,
                                  leading: Icons.fitness_center,
                                  accent: accent,
                                  fontSize: subSize,
                                ),
                              if (sets > 0 || reps.isNotEmpty)
                                _InfoChip(
                                  text: "Sets × Reps  $sets × $reps",
                                  leading: Icons.repeat,
                                  accent: accent,
                                  fontSize: subSize,
                                ),
                              if (rest.isNotEmpty)
                                _InfoChip(
                                  text: "Rest  $rest",
                                  leading: Icons.timer_outlined,
                                  accent: accent,
                                  fontSize: subSize,
                                ),
                            ],
                          ),

                          SizedBox(height: h * 0.02),

                          // ✅ Secondary muscles
                          if (secondary.isNotEmpty) ...[
                            _SectionTitle(
                              title: "Secondary Muscles",
                              icon: Icons.group_work_outlined,
                              accent: accent,
                              fontSize: subSize * 1.1,
                            ),
                            SizedBox(height: h * 0.01),
                            Wrap(
                              spacing: w * 0.02,
                              runSpacing: h * 0.01,
                              children: secondary
                                  .map((m) => _MiniPill(text: m, fontSize: subSize))
                                  .toList(),
                            ),
                            SizedBox(height: h * 0.02),
                          ],

                          // ✅ Notes
                          if (notes.trim().isNotEmpty) ...[
                            _SectionTitle(
                              title: "Notes",
                              icon: Icons.warning_amber_rounded,
                              accent: accent,
                              fontSize: subSize * 1.1,
                            ),
                            SizedBox(height: h * 0.01),
                            _NoteCard(text: notes, accent: accent, fontSize: subSize),
                            SizedBox(height: h * 0.02),
                          ],

                          // ✅ Video
                          if (videoUrl.trim().isNotEmpty)
                            _BottomButton(
                              height: btnH,
                              text: "WATCH VIDEO GUIDE",
                              color: Colors.white12,
                              textColor: Colors.white,
                              onTap: () {
                                _openYoutubeHowTo(
                                  context,
                                  videoUrl: videoUrl,
                                  title: "$name - How To",
                                );
                              },
                              fontSize: subSize,
                              radius: 999,
                              leading: Icons.play_circle_fill,
                            ),

                          SizedBox(height: h * 0.04),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _openHowToSheet(
      BuildContext context, {
        required Color accent,
        required String title,
        required List<String> steps,
      }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0F07),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.menu_book_outlined, color: accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: steps.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Center(
                            child: Text(
                              "${i + 1}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

// -------------------- UI Helpers --------------------

class _MetaPill extends StatefulWidget {
  final IconData icon;
  final String text;
  final double fontSize;

  const _MetaPill({
    required this.icon,
    required this.text,
    required this.fontSize,
  });

  @override
  State<_MetaPill> createState() => _MetaPillState();
}

class _MetaPillState extends State<_MetaPill> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: Colors.white70, size: widget.fontSize * 1.2),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white70, fontSize: widget.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  final IconData leading;
  final Color accent;
  final double fontSize;

  const _InfoChip({
    required this.text,
    required this.leading,
    required this.accent,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(leading, color: accent, size: fontSize * 1.2),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize)),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String text;
  final double fontSize;

  const _MiniPill({required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white70, fontSize: fontSize),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final double fontSize;

  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.accent,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accent, size: fontSize * 1.2),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StepsCard extends StatefulWidget {
  final List<String> steps;
  final Color accent;
  final double fontSize;

  const _StepsCard({
    required this.steps,
    required this.accent,
    required this.fontSize,
  });

  @override
  State<_StepsCard> createState() => _StepsCardState();
}

class _StepsCardState extends State<_StepsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: List.generate(widget.steps.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: widget.accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    child: Text(
                      "${i + 1}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.steps[i],
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: widget.fontSize,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String text;
  final Color accent;
  final double fontSize;

  const _NoteCard({
    required this.text,
    required this.accent,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: fontSize,
          height: 1.25,
        ),
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final double height;
  final double fontSize;
  final double radius;

  const _ControlButton({
    required this.text,
    required this.icon,
    required this.onTap,
    required this.height,
    required this.fontSize,
    required this.radius,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(widget.radius),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: widget.fontSize * 1.6),
              SizedBox(width: widget.fontSize * 0.5),
              Text(widget.text,
                  style: TextStyle(color: Colors.white, fontSize: widget.fontSize)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final double height;
  final double fontSize;
  final double radius;
  final IconData? leading;

  const _BottomButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
    required this.height,
    required this.fontSize,
    required this.radius,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                Icon(leading, color: textColor, size: fontSize * 1.3),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------- Custom Painter ---------

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

void _openYoutubeHowTo(
    BuildContext context, {
      required String videoUrl,
      required String title,
    }) {
  final videoId = YoutubePlayer.convertUrlToId(videoUrl);
  if (videoId == null) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0B0F07),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) {
      final controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          controlsVisibleAtStart: true,
        ),
      );

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.play_circle_fill, color: Color(0xFF9AFF00)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ✅ الفيديو داخل التطبيق
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: YoutubePlayer(
                    controller: controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: const Color(0xFF9AFF00),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },

  );
}
