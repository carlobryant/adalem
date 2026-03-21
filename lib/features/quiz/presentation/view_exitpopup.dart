import 'package:adalem/core/components/button_sm.dart';
import 'package:adalem/core/components/card_popuptween.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String quizExitTag = "quiz-exit-popup";

class QuizExitPopup extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const QuizExitPopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    });

  @override
  State<QuizExitPopup> createState() => _QuizExitPopupState();
}

class _QuizExitPopupState extends State<QuizExitPopup> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 64;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ClipRect(
          child: Hero(
            tag: quizExitTag,
            createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
            child: Material(
              shadowColor: Colors.transparent,
              color: Theme.of(context).colorScheme.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: OverflowBox(
                  minWidth: cardWidth,
                  maxWidth: cardWidth,
                  fit: OverflowBoxFit.deferToChild,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text("End Quiz?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Current quiz session and points earned will not be saved.",
                                    style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SmallButton(
                                onBack: () {
                                  widget.onCancel;
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16,
                                      ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              SmallButton(
                                onTap: () => widget.onConfirm(),
                                child: Text("Confirm",
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}