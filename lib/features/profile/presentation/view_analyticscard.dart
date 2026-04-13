import 'package:adalem/core/app_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

class AnalyticsCard extends StatefulWidget {
  final Map<DateTime, ({int total, String summary})>? detailedData;

  const AnalyticsCard({
    super.key,
    this.detailedData,
  });

  @override
  State<AnalyticsCard> createState() => _AnalyticsCardState();
}

class _AnalyticsCardState extends State<AnalyticsCard> {
  String _selectedSummary = "Study Activity"; 

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    final contrastColor = Theme.of(context).colorScheme.inverseSurface;
    final boxBgColor = Theme.of(context).colorScheme.onSurface;
    final boxHgColor = Theme.of(context).colorScheme.onTertiary;

    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year, now.month, now.day);
    final DateTime startDate = endDate.subtract(Duration(days: Constraint.maxActivity));
    final String defaultTitle = "Study Activity: ${DateFormat('MMMM d').format(startDate)} to Present";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
              widget.detailedData == null ? "Quiz Accuracy over Time" : (_selectedSummary == "Study Activity" ? defaultTitle : _selectedSummary),
              style: TextStyle(
                color: widget.detailedData == null || _selectedSummary.contains("Study Activity") ? contrastColor :  Theme.of(context).colorScheme.tertiary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            widget.detailedData == null 
                ? _buildLastQuiz() 
                : _buildHeatmap(endDate, startDate, contrastColor, boxBgColor, boxHgColor, defaultTitle),
          ],
        ),
      ),
    );
  }

  Widget _buildLastQuiz() {
    return const Text(""); 
  }

  Widget _buildHeatmap(
    DateTime endDate, 
    DateTime startDate, 
    Color contrastColor, 
    Color boxBgColor, 
    Color boxHgColor,
    String defaultTitle,
  ) {
    final Map<DateTime, int> simpleHeatmapData = widget.detailedData?.map(
      (key, value) => MapEntry(key, value.total)
    ) ?? {};

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeatMap(
            startDate: startDate,
            endDate: endDate,
            datasets: simpleHeatmapData,
            colorMode: ColorMode.color,
            
            size: 17.5, 
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
            
            onClick: (DateTime value) {
              final record = widget.detailedData?[value];
              final dateString = DateFormat('MMMM d').format(value); 

              setState(() {
                if (record != null) {
                  _selectedSummary = "$dateString: ${record.summary}";
                } else {
                  _selectedSummary = defaultTitle;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}