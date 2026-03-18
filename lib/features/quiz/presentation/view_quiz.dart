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
  final String uid;

  const QuizSessionView({
    super.key,
    required this.viewModel,
    required this.notebookId,
    required this.uid,
  });

  @override
  State<QuizSessionView> createState() => _QuizSessionViewState();
}

class _QuizSessionViewState extends State<QuizSessionView> {

  Future<bool> _onWillPop() async {
  final vm = widget.viewModel;
  if (vm.status == QuizSessionStatus.complete) return true;

  final shouldExit = await Navigator.of(context).push<bool>(
    PopupHeroDialog(builder: (context) => QuizExitPopup(
      onConfirm: () {
        Navigator.of(context).pop(true);
      },
      onCancel: () => Navigator.of(context).pop(false),
    ))
  );

  if (shouldExit == true && context.mounted) {
    await vm.endSessionEarly(notebookId: widget.notebookId, uid: widget.uid);
    return true;
  }
  return false;
}

  void _submitAnswer(bool isCorrect) {
    widget.viewModel.submitAnswer(
      notebookId: widget.notebookId,
      uid: widget.uid,
      isCorrect: isCorrect,
    );
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
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
              calculatedQuizLevel: vm.calculatedQuizLevel,
              calculatedMastery: vm.calculatedMastery,
              sessionScore: vm.sessionScore
              );
          }

          // QUIZ ACTIVE
          return Scaffold(
            appBar: AppBar(
              title: Text("Quiz Item ${vm.itemsServed + 1}".toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: "LoveYaLikeASister",
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
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildQuestionContent(vm),
                  ),
                ),
                // Processing Overlay
                if (vm.isProcessing)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── UI Dispatcher ─────────────────────────────────────────────
  Widget _buildQuestionContent(QuizViewModel vm) {
    if (vm.isScenario && vm.currentScenarioModel != null) {
      return _buildScenario(vm.currentScenarioModel!);
    } else if (vm.currentQuizItemModel != null) {
      final qm = vm.currentQuizItemModel!;
      if (qm.mode == QuizMode.multipleChoice) {
        return _buildMultipleChoice(qm);
      } else {
        return _buildIdentification(qm);
      }
    }
    return const Center(child: Text("Loading question..."));
  }

  // ── Multiple Choice / Scenario Builders ─────────────────────────
  Widget _buildMultipleChoice(QuizItemModel model) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Text(
              model.quizItem.text,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...?model.generatedOptions?.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: XLButton(
                onTap: () => _submitAnswer(option == model.quizItem.answer), 
                child: Text(option, 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: option.length > 35 ? 12 : 16,
                  ),
                textAlign: TextAlign.center,
                ),
                ),
            )),
      ],
    );
  }

  Widget _buildScenario(ScenarioModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              model.scenario.text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...model.scenario.options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: XLButton(
                onTap: () => _submitAnswer(option == model.scenario.answer), 
                child: Text(option, 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: option.length > 35 ? 12 : 16,
                  ),
                textAlign: TextAlign.center,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildIdentification(QuizItemModel model) {
    // Delegates to a separate Stateful widget to handle text input lifecycle
    return IdentificationView(
      questionText: model.quizItem.text,
      correctAnswer: model.quizItem.answer,
      onSubmit: _submitAnswer,
    );
  }
}

