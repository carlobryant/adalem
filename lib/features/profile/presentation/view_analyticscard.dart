import 'package:adalem/core/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  final bool isQuiz;

  const AnalyticsCard({
    super.key,
    this.isQuiz = false,
    });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.inverseSurface;
    final borderColor = Recolor.darken(onSurface);
    final contrastColor = Theme.of(context).colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: onSurface,
          borderRadius: BorderRadius.circular(20),
          border: BoxBorder.fromLTRB(
            bottom: BorderSide(width: 5, color: borderColor),
            right: BorderSide(width: 3, color: borderColor),
            top: BorderSide.none,
            left: BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD TITLE
            Text(
              isQuiz ? "Quiz Accuracy over Time" : "Flashcard Mastery Progress",
              style: TextStyle(
                color: contrastColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // MULTI-LINE CHART
            Expanded(
              child: LineChart(
                LineChartData(
                  // Hide the grid background for a cleaner look
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: contrastColor.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  
                  // Setup the axis borders
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: contrastColor.withValues(alpha: 0.3), width: 1),
                      left: BorderSide.none,
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  
                  // Setup the axis labels
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    // Y-Axis Labels
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(color: contrastColor.withValues(alpha: 0.7), fontSize: 10),
                          );
                        },
                      ),
                    ),
                    // X-Axis Labels
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          // Dummy days of the week mapping
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[value.toInt()],
                                style: TextStyle(color: contrastColor.withValues(alpha: 0.7), fontSize: 10),
                              ),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),
                  
                  // DUMMY DATA LINES
                  lineBarsData: [
                    // Line 1 (e.g., Score / Mastery Level)
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 30),
                        FlSpot(1, 45),
                        FlSpot(2, 40),
                        FlSpot(3, 60),
                        FlSpot(4, 55),
                        FlSpot(5, 80),
                        FlSpot(6, 95),
                      ],
                      isCurved: true,
                      color: Colors.blueAccent, // Use distinct colors for visibility
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueAccent.withValues(alpha: 0.1),
                      ),
                    ),
                    
                    // Line 2 (e.g., Average Difficulty / Speed)
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 60),
                        FlSpot(1, 50),
                        FlSpot(2, 65),
                        FlSpot(3, 75),
                        FlSpot(4, 70),
                        FlSpot(5, 85),
                        FlSpot(6, 80),
                      ],
                      isCurved: true,
                      color: Colors.deepOrangeAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false), // Hide dots on secondary line for contrast
                    ),
                  ],
                  // Chart bounds
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}