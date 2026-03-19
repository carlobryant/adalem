import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/flashcards/domain/flashcard_algo.dart';
import 'package:adalem/features/flashcards/domain/uc_syncflashcards.dart';
import 'package:adalem/features/flashcards/presentation/vm_flashcard.dart';
import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:adalem/features/notebook_content/presentation/vm_content.dart';
import 'package:adalem/features/flashcards/presentation/view_flashcard.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/quiz/domain/uc_syncquiz.dart';
import 'package:adalem/features/quiz/presentation/view_quiz.dart';
import 'package:adalem/features/quiz/presentation/vm_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:redacted/redacted.dart';

class ContentDrawer extends StatefulWidget {
  final List<ChapterModel>? chapters;
  final Function(int)? onChapterTap;

  final String notebookTitle;
  final String notebookId;
  final int mastery;

  final VoidCallback onBack;
  final Color primary;
  

  const ContentDrawer({
    super.key,
    this.chapters,
    this.onChapterTap,

    required this.notebookTitle,
    required this.notebookId,
    required this.mastery,

    required this.onBack,
    required this.primary,
    
  });

  @override
  State<ContentDrawer> createState() => _ContentDrawerState();
}

class _ContentDrawerState extends State<ContentDrawer> {
  final ScrollController _scrollController = ScrollController();
  bool _isBottomBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isBottomBarVisible) setState(() => _isBottomBarVisible = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isBottomBarVisible) setState(() => _isBottomBarVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      // DRAWER HEADER
      appBar: AppBar(
        backgroundColor: widget.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary, 
        elevation: 4, 
        shadowColor: Colors.black45,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(Icons.close, size: 30),
        ),
        title: Text(
          widget.notebookTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
     
      // DRAWER LIST
      body: Stack(
        children: [
          ListView.builder(
              controller: _scrollController,
              itemCount: widget.chapters == null ? 10 : widget.chapters!.length,
              itemBuilder: (context, index) {
                final isLoading = widget.chapters == null || widget.onChapterTap == null;
              
                final headerText = isLoading 
                ? "Fetching Chapters of ${widget.notebookTitle}..." 
                : widget.chapters![index].chapter.header;
        
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                  title: Row(
                    children: [
                      Text(
                        "${index + 1}. ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ).redacted(context: context, redact: isLoading),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(headerText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                        ).redacted(context: context, redact: isLoading),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: isLoading ? null : () => widget.onChapterTap!(index),
                );
              },
            ),

            // DRAWER BUTTONS
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              bottom: _isBottomBarVisible ? 0 : -225, 
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [

                        // FLASHCARD BUTTON
                        XLButton(
                          onTap: () async {
                            final contentvm = context.read<ContentViewModel>();
                            final notebookvm = context.read<NotebookViewModel>();
                            final currentUser = context.read<AuthRepo>().getCurrentUser();
                            if (currentUser == null) return;

                            final userProgress = notebookvm.getProgressFor(
                              widget.notebookId,
                              currentUser.uid,
                            );

                            final flashcardvm = FlashcardViewModel(
                              sm2: const SM2Algorithm(),
                              sessionService: const FlashcardSession(),
                              syncFlashcardProgress: context.read<SyncFlashcards>(),
                            );

                            if (!context.mounted) return;
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: flashcardvm,
                                  child: FlashcardView(
                                    viewModel: flashcardvm,
                                    notebookId: widget.notebookId,
                                    uid: currentUser.uid,
                                    mastery: widget.mastery,
                                  ),
                                ),
                              ),
                            );

                            if (contentvm.quizItemModels.isEmpty) {
                              await contentvm.loadNotebookContent(
                                widget.notebookId,
                                load: {ContentType.flashcards},
                              );
                            }

                            final allItems = contentvm.quizItemModels
                                .map((q) => q.quizItem)
                                .toList();

                            flashcardvm.initSession(allItems, userProgress);
                          },
                          child: Column(
                          children: [
                            Text(
                              "Flashcards",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Spaced-repetition review",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(height: 20),

                        // QUIZ BUTTON
                        XLButton(
                          onTap: () async {
                            final contentvm = context.read<ContentViewModel>();
                            final currentUser = context.read<AuthRepo>().getCurrentUser();
                            if (currentUser == null) return;

                            final quizvm = QuizViewModel(
                              syncQuizHistory: context.read<SyncQuizHistory>(),
                            );

                            if (!context.mounted) return;
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: quizvm,
                                  child: QuizSessionView(
                                    viewModel: quizvm,
                                    notebookId: widget.notebookId,
                                    mastery: widget.mastery,
                                    uid: currentUser.uid,
                                  ),
                                ),
                              ),
                            );

                            quizvm.initSession(contentvm.content!, currentMastery: widget.mastery);
                          },
                          child: Column(
                          children: [
                            Text(
                              "Start Quiz",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Performance-based adaptive quiz",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        )),
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