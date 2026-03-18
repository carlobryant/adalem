import 'package:adalem/core/components/button_xl.dart';
import 'package:flutter/material.dart';

class QuizResultView extends StatelessWidget {
  final int calculatedQuizLevel;
  final double calculatedMastery;
  final double sessionScore;

  const QuizResultView({
    required this.calculatedQuizLevel,
    required this.calculatedMastery,
    required this.sessionScore,
    super.key,
    });

  @override
  Widget build(BuildContext context) {
    final masteryPercent = (calculatedMastery * 100).clamp(0, 100).toStringAsFixed(1);
    final scorePercent = (sessionScore * 100).clamp(0, 100).toStringAsFixed(0);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              Text(
                "Current Assessment".toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: "LoveYaLikeASister",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  height: 0.9,
                  fontSize: 42,
              ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildStatRow("Level Reached", "Tier $calculatedQuizLevel"),
              const Divider(),
              _buildStatRow("Topic Mastery", "$masteryPercent%"),
              const Divider(),
              _buildStatRow("Accuracy Score", "$scorePercent%"),
              const SizedBox(height: 60),
              XLButton(onTap: () => Navigator.of(context).pop(),
              child: Text("Done", 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                ))),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}