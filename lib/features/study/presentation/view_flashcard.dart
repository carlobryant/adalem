import 'package:adalem/core/components/loader_md.dart';
import 'package:adalem/features/notebook_content/presentation/vm_content.dart';
import 'package:adalem/features/study/presentation/model_quiz.dart';
import 'package:flutter/material.dart';

class FlashcardView extends StatefulWidget {
  final ContentViewModel viewModel;
  const FlashcardView({super.key, required this.viewModel});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _answerRevealed = false;
  bool _switchSide = false;
  int _currentIndex = 0;
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // void _toggleCard() async {
  //   if (!_switchSide) {
  //     _controller.forward();
  //   } else {
  //     _controller.reverse();
  //   }
  //   await Future.delayed(Duration(milliseconds: 500));
  //   setState(() {
  //     _switchSide = !_switchSide;
  //     if (!_answerRevealed) _answerRevealed = true;
  //   });
  // }

  void _toggleCard() async {
    final vm = widget.viewModel;
    
    if (!_switchSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _switchSide = !_switchSide;
      if (!_answerRevealed) _answerRevealed = true;
    });

    // Reveal the current card in the model
    final updated = vm.quizItemModels[_currentIndex].revealFlashcard();
    vm.updateQuizItem(_currentIndex, updated);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {

        final vm = widget.viewModel;

        if (vm.isLoading || vm.errorMessage != null) {
          return Scaffold(
            body: SafeArea(child: MediumLoader(loading: ["Loading Flashcards"])),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(""),
          ),
          body: Stack(
            children: [
              // FLASHCARD
              Center(
                child: GestureDetector(
                  onTap: _toggleCard,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.rotationY(_animation.value * 3.14159),
                        alignment: Alignment.center,
                        child: _animation.value < 0.5 ?
                          _buildCard(false, vm.quizItemModels[_currentIndex])
                          : Transform.scale(
                          scaleX: -1,
                          child: _buildCard(true, vm.quizItemModels[_currentIndex]),
                        ),
                      );
                    }
                  ),
                ),
              ),
        
              // QUALITY BUTTONS
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                bottom: _answerRevealed ? 0 : -225, 
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: BoxBorder.fromLTRB(top: BorderSide(
                        width: 3,
                        color: Theme.of(context).colorScheme.onSurface,
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
                    child: Row(
                      children: [
                        _buildQualityButton("No Idea", 0, Colors.red.shade900,
                          "Complete blackout"),
                        _buildQualityButton("Somewhat", 1, Colors.red,
                          "Wrong answer, but familiar"),
                        _buildQualityButton("Almost", 2, Colors.orange,
                          "Wrong answer, but I remember this"),
                        _buildQualityButton("Hard", 3, Colors.yellow,
                          "Correct answer, but struggled"),
                        _buildQualityButton("Good", 4, Colors.lightGreen,
                          "Correct answer, but hesitated"),
                        _buildQualityButton("Easy", 5, Colors.green,
                          "Correct answer, no hesitations"),  
                      ],
                    ),
                  ),
        
                ), 
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildCard(bool answer, QuizItemModel item) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: answer ?
        Theme.of(context).colorScheme.inverseSurface
        : Theme.of(context).colorScheme.primary,
      ),
      alignment: Alignment.center,
      child: answer ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ANSWER:",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 10,
            ),
          ),
          Text(item.quizItem.answer,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 30,
            ),
          ),
        ],
      )
      : Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Spacer(),
          Center(
            child: Expanded(
              child: Text(item.quizItem.text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Spacer(),
          Text("TAP FLASHCARD TO SHOW ANSWER",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 10,
            ),
          ),
        SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildQualityButton(String quality, int value, Color color, String desc) {
    return ElevatedButton(
      onPressed: () {
        // TODO: use `value` for SM-2 spaced repetition logic later
        setState(() {
          _currentIndex++;
          _answerRevealed = false;
          _switchSide = false;
          _controller.reset();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color, 
        foregroundColor: Colors.white,
        fixedSize: const Size(2, 60), 
      ),
      child: Column(
        children: [
          Text(quality,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}