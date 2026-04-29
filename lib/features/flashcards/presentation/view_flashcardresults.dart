import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/core/components/animation_mastery.dart';
import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/model_mastery.dart';
import 'package:flutter/material.dart';

class FlashcardResultsView extends StatelessWidget {
  final VoidCallback? onAgain;
  final VoidCallback onBack;
  final int prevMastery;

  const FlashcardResultsView({
    super.key,
    this.onAgain,
    required this.onBack,
    required this.prevMastery,
  });

  @override
  Widget build(BuildContext context) {
    final int flashcardXp = onAgain != null ? Constraint.flashcardPts : 0;

    final totalXp = prevMastery + flashcardXp;
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

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
                bottom: 150,
                child: MasteryAnimation (
                  addPts: flashcardXp,
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
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(onAgain != null ? "${Constraint.flashcardPts} points is rewarded for every completed flashcard session."
                      : "Flashcards are displayed at calculated intervals to reduce extraneous cognitive load.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(color: Theme.of(context).colorScheme.inversePrimary),
                      const SizedBox(height: 18),
                      Text(onAgain != null ? "Ready for more?"
                        : "All caught up! Check back later.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      onAgain != null ?
                      XLButton(onTap: onAgain, inversed: true,
                      surfacecolor: Theme.of(context).colorScheme.primary,
                      child: Text("Start Again",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ))) : const SizedBox.shrink(),
                      SizedBox(height: 10),
                      XLButton(onTap: onBack, inversed: true,
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
    );
  }
}