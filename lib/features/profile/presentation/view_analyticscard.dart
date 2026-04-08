import 'package:adalem/core/app_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

class AnalyticsCard extends StatelessWidget {
  final Map<DateTime, int>? heatmapData;

  const AnalyticsCard({
    super.key,
    this.heatmapData,
    });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    final contrastColor = Theme.of(context).colorScheme.inverseSurface;
    final boxBgColor = Theme.of(context).colorScheme.onSurface;
    final boxHgColor = Theme.of(context).colorScheme.onTertiary;

    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year, now.month, now.day); 
    final DateTime startDate = endDate.subtract(const Duration(days: Constraint.maxActivity));

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
              heatmapData == null ? "Quiz Accuracy over Time" 
              : "Study Activity: ${DateFormat('MMMM d').format(startDate)} to Present",
              style: TextStyle(
                color: contrastColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            heatmapData == null ? _buildLastQuiz() : _buildHeatmap(endDate, startDate, contrastColor, boxBgColor, boxHgColor),
            
          ],
        ),
      ),
    );
  }

  Widget _buildLastQuiz() {
    return Text("");
  }

  Widget _buildHeatmap(DateTime endDate, DateTime startDate, Color contrastColor, Color boxBgColor, Color boxHgColor) {
    

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeatMap(
            startDate: startDate,
            endDate: endDate,
            datasets: heatmapData,
            colorMode: ColorMode.color,
            
          
            size: 16, 
            margin: const EdgeInsets.all(2),
            borderRadius: 4,
            defaultColor: boxBgColor,
            textColor: contrastColor,
            colorsets: {
              1: boxHgColor.withValues(alpha: 0.3),
              3: boxHgColor.withValues(alpha: 0.5),
              5: boxHgColor.withValues(alpha: 0.8),
              7: boxHgColor, 
            },
            showText: false, 
            showColorTip: false, 
          ),
        ],
      ),
    );
  }
}