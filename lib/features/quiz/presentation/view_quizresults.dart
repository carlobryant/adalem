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
              child: MasteryAnimation(
                addPts: sessionScore,
                currPts: relativeXp,
                maxPts: relativeMaxXp,
                mastery: currentLevel.id,
                progress: progress,
                )
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: BoxBorder.fromLTRB(top: BorderSide(
                    width: 3,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    )),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24, top: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text( noItems < 4 ? 
                            "Quiz ended early, take a break! You may be cognitively overloaded."
                            : (aveDifficulty == "Hard" || aveDifficulty == "Very Hard") && sessionAccuracy <= 0.5 ?
                            "No progress without challenge, that's learning. You're doing great!"
                            : (aveDifficulty == "Hard" || aveDifficulty == "Very Hard") && sessionAccuracy > 0.5 ?
                            "Those items were difficult, you did a great job!" :
                            "Quiz adjusts based on performance and difficulty of items.",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                        Divider(color: Theme.of(context).colorScheme.inversePrimary),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _buildStatRow("Quiz Difficulty", aveDifficulty, context, isContainer: true)
                        ),
                        const SizedBox(height: 8),
                        _buildStatRow("Accuracy", "$accuracyPercent%", context),
                        const SizedBox(height: 3),
                        _buildStatRow("Number of Items", "$noItems", context),
                        const SizedBox(height: 18),
                        XLButton(onTap: () => Navigator.of(context).pop(),
                        inversed: true,
                        surfacecolor: Theme.of(context).colorScheme.primary,
                        child: Text("Done", 
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildStatRow(String label, String value, context,{isContainer = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: isContainer ? 0 : 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${label.toUpperCase()}: ", 
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isContainer ? Theme.of(context).colorScheme.primary 
              : Theme.of(context).colorScheme.inversePrimary,
          )),
          Text(value.toUpperCase(), 
            style: TextStyle(
              fontSize: 24,
              fontFamily: "LoveYaLikeASister",
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: isContainer ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          )),
        ],
      ),
    );
  }
}