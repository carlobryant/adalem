import 'package:adalem/core/components/animation_loader.dart';
import 'package:adalem/features/flashcards/presentation/view_flashcardresults.dart';
import 'package:adalem/features/flashcards/presentation/vm_flashcard.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:flutter/material.dart';

class FlashcardView extends StatefulWidget {
  final FlashcardViewModel viewModel;
  final String notebookId;
  final int mastery;
  final String uid;
  const FlashcardView({
    super.key,
    required this.viewModel,
    required this.notebookId,
    required this.mastery,
    required this.uid,
  });

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _answerRevealed = false;
  bool _infoRevealed = false;
  bool _switchSide = false;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      widget.viewModel.saveProgressEarly(widget.notebookId, widget.uid);
    }
  }

  void _toggleCard() async {
    if (!_switchSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _switchSide = !_switchSide;
      if (!_answerRevealed) _answerRevealed = true;
      if (_infoRevealed) _infoRevealed = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop) {
          widget.viewModel.saveProgressEarly(widget.notebookId, widget.uid);
        }
      },
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final vm = widget.viewModel;

          if(vm.status == FlashcardSessionStatus.idle
          || vm.status == FlashcardSessionStatus.error
          || vm.status == FlashcardSessionStatus.syncError) {
            return Scaffold(
              body: SafeArea(child: LoaderAnimation(loading: ["Loading Flashcards"])),
            );
          }

          if(vm.status == FlashcardSessionStatus.complete
          || vm.status == FlashcardSessionStatus.caughtUp) {
            return Scaffold(
              body: FlashcardResultsView(
                onBack: () => Navigator.of(context, rootNavigator: true).pop(),
                onAgain: (vm.status == FlashcardSessionStatus.complete 
                && vm.hasMoreCardsForToday) ? () {
                  setState(() {
                    _answerRevealed = false;
                    _infoRevealed = false;
                    _switchSide = false;
                    _controller.reset();
                  });
                  vm.startNextSession();
                } : null,
                prevMastery: widget.mastery,
              ),
            );
          }

          final currentItem = vm.currentItem!;
          final int toReview = vm.sessionItems.length - vm.currentIndex + 1;
          return Scaffold(
            appBar: AppBar(
              title: toReview > 0 ? Text("Flashcards to review: ${toReview - 1}")
              : Text("Flashcards to Review: 0"),
            ),
            body: Stack(
              children: [
                // FLASHCARD
                Column(
                  children: [
                    Spacer(),
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
                                _buildCard(false, currentItem)
                                : Transform.scale(
                                scaleX: -1,
                                child: _buildCard(true, currentItem),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
          
                // QUALITY BUTTONS
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  bottom: _answerRevealed ? _infoRevealed? 0 : -170 : -400, 
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Do you recall this?",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                IconButton(onPressed: () => setState(()
                                  => _infoRevealed = !_infoRevealed
                                ), 
                                icon: Icon( _infoRevealed ?
                                  Icons.close : Icons.info_outline_rounded,
                                  color: Theme.of(context).colorScheme.onSurface
                                )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _buildQualityButton("No Idea", 0, Color(0xFF4b0202), Color(0xFFba5447), vm), 
                              _buildQualityButton("Somewhat", 1, Color(0xFF6a464a), Color(0xFFbf9694), vm),
                              _buildQualityButton("Almost", 2, Color(0xFF757575), Color(0xFFbfbfbf), vm),
                              _buildQualityButton("Barely", 3, Color(0xFF607568), Color(0xFFadc1ba), vm),
                              _buildQualityButton("Alright", 4, Color(0xFF406d46), Color(0xFF8dc1a0), vm),
                              _buildQualityButton("Easily", 5, Color(0xFF1b5e20), Color(0xFF66bb7e), vm),
                            ],
                          ),
      
                          SizedBox(height: 20),
                          // QUALITY LEGEND
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildInfo("Easily", "Correct answer, no hesitations"),
                              _buildInfo("Alright", "Correct answer, but hesitated"),
                              _buildInfo("Barely", "Correct answer, but struggled"),
                              _buildInfo("Almost", "Wrong answer, but I remember this"),
                              _buildInfo("Somewhat", "Wrong answer, but familiar"),
                              _buildInfo("No Idea", "Complete blackout"),
                              SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
          
                  ), 
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildInfo(String legend, String info) {
    return Row(
      children: [
        SizedBox(width: 20),
        Text("$legend - ",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        )),
        Expanded(
          child: Text(info,
            style: TextStyle(
              fontSize: 15
          )),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildCard(bool answer, QuizItem item) {
    return Container(
      width: 300,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: answer ?
        Theme.of(context).colorScheme.inverseSurface
        : Theme.of(context).colorScheme.primary,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Text(item.answer,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )
        : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Center(
              child: Text(item.text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
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
      ),
    );
  }

  Widget _buildQualityButton(
    String quality,
    int value,
    Color primary,
    Color secondary,
    FlashcardViewModel vm,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: vm.isProcessingRating ? null
            : () async {
              await vm.rateCard(widget.notebookId, widget.uid, value);

              if(vm.status == FlashcardSessionStatus.active) {
                setState(() {
                  _answerRevealed = false;
                  _switchSide = false;
                  _infoRevealed = false;
                  _controller.reset();
                });
              }
              
            }, 
            icon: Image.asset("assets/ic_sm2algo$value.png", color: secondary),
            style: IconButton.styleFrom(
              backgroundColor: primary, 
              foregroundColor: Colors.white,
              fixedSize: const Size(50, 50), 
            ),
          ),
      
          Text(quality,
                  style: TextStyle(fontSize: 12),
                ),
        ],
      ),
    );
  }
}