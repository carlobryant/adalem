import 'package:adalem/core/components/animation_mastery.dart';
import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/model_mastery.dart';
import 'package:flutter/material.dart';

class QuizResultView extends StatelessWidget {
  final String aveDifficulty;
  final double sessionAccuracy;
  final int sessionScore;
  final int prevMastery;
  final int noItems;

  const QuizResultView({
    required this.aveDifficulty,
    required this.sessionAccuracy,
    required this.sessionScore,
    required this.prevMastery,
    required this.noItems,
    super.key,
    });

  @override
  Widget build(BuildContext context) {
    final accuracyPercent = (sessionAccuracy * 100).clamp(0, 100).toStringAsFixed(0);

    final totalXp = prevMastery + sessionScore;
    final currentLevel = MasteryLevel.fromXp(totalXp);
    final minXp = currentLevel.minXp;

    int nextMinXp = MasteryLevel.level5.maxXp!;
    if (currentLevel.index < MasteryLevel.values.length - 1) {
      final nextLevel = MasteryLevel.values[currentLevel.index + 1];
      nextMinXp = nextLevel.minXp;
    }

    final relativeXp = totalXp - minXp;
    final relativeMaxXp = nextMinXp - minXp;
    
    final currentMinXp = currentLevel.minXp;
    final range = (nextMinXp - currentMinXp) == 0 ? 1 : (nextMinXp - currentMinXp);
    final progress = ((totalXp - currentMinXp) / range).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
              Positioned(
                bottom: 150,
                child: MasteryAnimation(mastery: currentLevel.id)
                ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  const SizedBox(height: 40),

                  // MASTERY PROGRESS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 24,
                          backgroundColor: Theme.of(context).colorScheme.onSurface,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "+$sessionScore Points",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "$relativeXp / $relativeMaxXp Points",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  Divider(color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(height: 25),
                  _buildStatRow("Quiz Difficulty", aveDifficulty, context),
                  const SizedBox(height: 8),
                  _buildStatRow("Number of Items", "$noItems", context),
                  const SizedBox(height: 8),
                  _buildStatRow("Accuracy", "$accuracyPercent%", context),
                  const SizedBox(height: 50),
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
          ],
        ),
      ),
    );
  }

    Widget _buildStatRow(String label, String value, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${label.toUpperCase()}: ", 
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
          )),
          Text(value.toUpperCase(), 
            style: TextStyle(
              fontSize: 20,
              fontFamily: "LoveYaLikeASister",
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.primary,
          )),
        ],
      ),
    );
  }
}