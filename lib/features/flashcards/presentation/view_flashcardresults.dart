import 'package:adalem/core/components/animation_mastery.dart';
import 'package:adalem/core/components/button_sm.dart';
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
    final int flashcardXp = onAgain != null ? 30 : 0;

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
                child: MasteryAnimation (mastery: currentLevel.id)
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
                        flashcardXp > 0 ?
                        Text(
                          "+$flashcardXp Points",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                        : Spacer(),
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
                SizedBox(height: 30),

                onAgain != null ? 
                Text("30 Points is rewarded for every completed flashcard session",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                )
                : SizedBox(height: 20),
                SizedBox(height: 50),
                Text(onAgain != null ? "Ready for more?"
                  : "All caught up! Check back later.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallButton(
                      onBack: onBack,
                      child:  Text("Return",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
            
                    if (onAgain != null)
                    SizedBox(width: 30),
            
                    if (onAgain != null)
                    SmallButton(
                      onTap: onAgain,
                      child: Text("Ready",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}