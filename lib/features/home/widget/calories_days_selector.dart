import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CaloriesDaysSelector extends StatefulWidget {
  const CaloriesDaysSelector({super.key});

  @override
  State<CaloriesDaysSelector> createState() => _CaloriesDaysSelectorState();
}

class _CaloriesDaysSelectorState extends State<CaloriesDaysSelector> {
  late List<DateTime> weekDays;
  late int selectedIndex;

  final List<String> dayNames = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday % 7)); // Sunday = 0

    weekDays = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    selectedIndex = weekDays.indexWhere((d) => _isSameDay(d, now));
    if (selectedIndex == -1) selectedIndex = 0;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical:1.h,horizontal: 4.w ),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0F12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Calories Burnt',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                '1.2K kcal',
                style: TextStyle(color: Color(0xFFB7BDC6), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final d = weekDays[i];
                final isSelected = i == selectedIndex;

                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF16351A) : const Color(0xFF12161B),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF66FF4D) : const Color(0xFF1E242C),
                        width: isSelected ? 2.2 : 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayNames[d.weekday % 7], // الأحد يطلع Sun
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF66FF4D) : const Color(0xFFB7BDC6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _twoDigits(d.day),
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF66FF4D) : const Color(0xFF8E96A3),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}