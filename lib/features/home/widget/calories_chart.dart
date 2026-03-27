import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CaloriesChart extends StatefulWidget {
  const CaloriesChart({super.key});

  @override
  State<CaloriesChart> createState() => _CaloriesChartState();
}

class _CaloriesChartState extends State<CaloriesChart> {
  int touchedIndex = 4; // مثلا اليوم الحالي (Fri)

  final List<double> calories = [220, 180, 150, 300, 520, 420, 120];
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0F12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Track your progress',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                'Calories',
                style: TextStyle(color: Color(0xFFB7BDC6), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 600,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF1E242C),
                    strokeWidth: 1,
                    dashArray: [6, 6],
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Color(0xFF8E96A3), fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= days.length) return const SizedBox();
                        final isSelected = i == touchedIndex;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[i],
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF66FF4D) : const Color(0xFF8E96A3),
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchCallback: (event, response) {
                    if (response != null && response.lineBarSpots != null) {
                      setState(() {
                        touchedIndex = response.lineBarSpots!.first.x.toInt();
                      });
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: const Color(0xFF16351A),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} kcal',
                          const TextStyle(color: Color(0xFF66FF4D), fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: touchedIndex.toDouble(),
                      color: const Color(0xFF66FF4D),
                      strokeWidth: 1,
                      dashArray: [6, 6],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: const Color(0xFF66FF4D),
                    barWidth: 2.5,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                    spots: List.generate(
                      calories.length,
                          (i) => FlSpot(i.toDouble(), calories[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}