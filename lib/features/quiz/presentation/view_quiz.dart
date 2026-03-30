import 'package:adalem/core/components/animation_loader.dart';
import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/features/notebook_content/presentation/model_quizitem.dart';
import 'package:adalem/features/quiz/presentation/view_exitpopup.dart';
import 'package:adalem/features/quiz/presentation/view_identification.dart';
import 'package:adalem/features/quiz/presentation/view_quizresults.dart';
import 'package:adalem/features/quiz/presentation/vm_quiz.dart';
import 'package:flutter/material.dart';

class QuizSessionView extends StatefulWidget {
  final QuizViewModel viewModel;
  final String notebookId;
  final int mastery;
  final String uid;

  const QuizSessionView({
    super.key,
    required this.viewModel,
    required this.notebookId,
    required this.mastery,
    required this.uid,
  });

  @override
  State<QuizSessionView> createState() => _QuizSessionViewState();
}

class _QuizSessionViewState extends State<QuizSessionView> {
  bool _isAnswerLocked = false;
  String? _selectedAnswer;
  int noItems = 0;

  Future<bool> _onWillPop() async {
    final vm = widget.viewModel;
    if (vm.status == QuizSessionStatus.complete) return true;

    final shouldExit = await Navigator.of(context).push<bool>(
      PopupHeroDialog(builder: (context) => QuizExitPopup(
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ))
    );

    if (shouldExit == true && context.mounted) {
      await vm.endSessionEarly();
      return true;
    }
    return false;
  }

  Future<void> _submitAnswer(bool isCorrect, String answer) async {
    if (_isAnswerLocked) return;
    setState(() {
      _isAnswerLocked = true;
      _selectedAnswer = answer;
      noItems++;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    widget.viewModel.submitAnswer(
      notebookId: widget.notebookId,
      uid: widget.uid,
      isCorrect: isCorrect,
    );

    setState(() {
      _isAnswerLocked = false;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();

        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final vm = widget.viewModel;

          // LOADING OR ERROR
          if (vm.status == QuizSessionStatus.idle) {
            return const Scaffold(body: Center(child: LoaderAnimation(loading: ["Loading Quiz"])));
          }
          if (vm.status == QuizSessionStatus.error || vm.status == QuizSessionStatus.syncError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(
                child: Text(vm.error?.description ?? "An unknown error occurred."),
              ),
            );
          }

          // QUIZ RESULTS
          if (vm.status == QuizSessionStatus.complete) {
            return QuizResultView(
                aveDifficulty: vm.difficultyLabel,
                sessionAccuracy: vm.sessionAccuracy,
                sessionScore: vm.sessionScore,
                prevMastery: widget.mastery,
                noItems: noItems,
              );
          }

          // QUIZ ACTIVE
          return Scaffold(
            appBar: AppBar(
              title: Text("Quiz Item ${vm.itemsServed + 1}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: Hero(
                tag: quizExitTag,
                createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PopupHeroDialog(builder: (context) => QuizExitPopup(
                          onConfirm: () {
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop();
                          },
                          onCancel: () => Navigator.of(context).pop(false),
                        ))
                      );
                    }, 
                    icon: Icon(Icons.close,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text("Score: ${vm.sessionScore}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontFamily: "LoveYaLikeASister",
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: _buildQuestionContent(vm),
                ),

                if (vm.isProcessing)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: LoaderAnimation(loading: ["Loading Quiz"])),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionContent(QuizViewModel vm) {
  if (vm.isScenario && vm.currentScenarioModel != null) {
    final s = vm.currentScenarioModel!.scenario;
    return _buildChoices(questionText: s.text, options: s.options, answer: s.answer);
  } 
  
  if (vm.currentQuizItemModel != null) {
    final qm = vm.currentQuizItemModel!;
    if (qm.mode == QuizMode.multipleChoice) {
      return _buildChoices(
        questionText: qm.quizItem.text,
        options: qm.generatedOptions ?? [],
        answer: qm.quizItem.answer,
      );
    }
    return IdentificationView(
      questionText: qm.quizItem.text,
      correctAnswer: qm.quizItem.answer,
      onSubmit: _submitAnswer,
    );
  }
  return const Center(child: Text("Loading question..."));
}


  Widget _buildChoices({
    required String questionText,
    required List<String> options,
    required String answer,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                const SizedBox(height: 20),
                ...options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: XLButton(
                    onTap: () => _submitAnswer(option == answer, answer),
                    isItem: true,
                    isLocked: !_isAnswerLocked,
                    isCorrect: _selectedAnswer == option,
                    child: Text(option,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: option.length > 35 ? 12 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              border: BoxBorder.fromLTRB(bottom: BorderSide(
                width: 5, 
                color: Theme.of(context).colorScheme.primaryContainer
              )),
            ),
            height: MediaQuery.of(context).size.height * 0.30,
            child: Padding(
              padding: const EdgeInsets.only(left: 26, right: 26, bottom: 24),
              child: Center(
                child: Text(
                  questionText,
                  style: TextStyle(
                    fontSize: questionText.length > 150 ? 18
                    : questionText.length < 90 ? 22 : 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

