import 'package:adalem/core/components/button_sm.dart';
import 'package:flutter/material.dart';

class FlashcardExitView extends StatelessWidget {
  final VoidCallback? onAgain;
  final VoidCallback onBack;

  const FlashcardExitView({
    super.key,
    this.onAgain,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/ic_sm2algo5.png",
              width: 200,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 30),
        
            Text("Flashcards Complete!".toUpperCase(),
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
            SizedBox(height: 20),

            Text(onAgain != null ? "Ready for more?"
              : "All caught up! Check back later.",
              style: TextStyle(
                      fontSize: 18,
                    ),
            ),
            SizedBox(height: 50),
        
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
          ],
        ),
      ),
    );
  }
}