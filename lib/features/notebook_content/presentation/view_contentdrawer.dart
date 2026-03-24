import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/model_mastery.dart';
import 'package:adalem/core/app_theme.dart';
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
  final String notebookTitle;
  final String notebookId;
  final Color primary;
  final String course;
  final String image;
  final int mastery;

  final bool toQuiz;
  final bool toFlashcard;
  final Function(int)? onChapterTap;
  final VoidCallback? onClose; 
  final VoidCallback onBack;
  
  const ContentDrawer({
    super.key,
    this.chapters,
    required this.notebookTitle,
    required this.notebookId,
    required this.primary,
    required this.course,
    required this.image,
    required this.mastery,
    
    this.toQuiz = false,
    this.toFlashcard = false,
    this.onChapterTap,
    this.onClose,
    required this.onBack,
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

    if (widget.toFlashcard || widget.toQuiz) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _redirectToStudy(isQuiz: widget.toQuiz));
    }
  }

  void _redirectToStudy({bool isQuiz = false}) async {
    final currentUser = context.read<AuthRepo>().getCurrentUser();
    if (currentUser == null) return;

    final contentvm = context.read<ContentViewModel>();
    final notebookvm = context.read<NotebookViewModel>();
    
    final uid = currentUser.uid;
    final mastery = notebookvm.getMasteryFor(widget.notebookId, uid);

    if (isQuiz) {
      final quizvm = QuizViewModel(syncQuizHistory: context.read<SyncQuizHistory>());
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(value: quizvm,
            child: QuizSessionView(viewModel: quizvm, 
              notebookId: widget.notebookId, 
              mastery: mastery, uid: uid,
            ),
          ),
        ),
      );

      quizvm.initSession(contentvm.content!, currentMastery: mastery);
    } else {
      final userProgress = notebookvm.getProgressFor(widget.notebookId, uid);
      final flashcardvm = FlashcardViewModel(
        sm2: const SM2Algorithm(),
        sessionService: const FlashcardSession(),
        syncFlashcardProgress: context.read<SyncFlashcards>(),
      );
      
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(value: flashcardvm,
            child: FlashcardView(viewModel: flashcardvm,
              notebookId: widget.notebookId, 
              uid: uid, mastery: mastery,
              onAgain: () => WidgetsBinding.instance.addPostFrameCallback((_) => _redirectToStudy()),
            ),
          ),
        ),
      );

      if (contentvm.quizItemModels.isEmpty) {
        await contentvm.loadNotebookContent(widget.notebookId, load: {ContentType.flashcards});
      }
      final allItems = contentvm.quizItemModels.map((q) => q.quizItem).toList();
      flashcardvm.initSession(allItems, userProgress);
    }
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
        backgroundColor: Recolor.darken(widget.primary),
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
        actions: [
          if (widget.onClose != null)
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.menu_open, size: 28),
            ),
        ],
      ),
     
      // DRAWER LIST
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is OverscrollNotification) {
                setState(() => _isBottomBarVisible = notification.overscroll < 0);
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.builder(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: widget.chapters == null ? 10 : widget.chapters!.length,
                  itemBuilder: (context, index) {
                    final isLoading = widget.chapters == null || widget.onChapterTap == null;
                  
                    final headerText = isLoading ? "Fetching Chapters of ${widget.notebookTitle}..." 
                    : widget.chapters![index].chapter.header;
                      
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                      title: Row(
                        children: [
                          Text(
                            "${index + 1}. ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inverseSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ).redacted(context: context, redact: isLoading),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(headerText,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inverseSurface,
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
            ),
          ),

            // DRAWER BUTTONS
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              bottom: _isBottomBarVisible ? 0 : -(MediaQuery.sizeOf(context).height * 0.28),
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.primary,
                  border: BoxBorder.fromLTRB(top: BorderSide(
                    width: 3,
                    color: Recolor.darken(widget.primary),
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                    child: Column(
                      children: [

                        // NOTEBOOK INFO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(5),
                              child: Image(
                                image: AssetImage("assets/nb_${widget.image}.jpg"),
                                fit: BoxFit.cover,
                                alignment: AlignmentGeometry.center,
                                width: 22,
                                height: 22,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(widget.course,
                              style: TextStyle(
                                color: Recolor.darken(widget.primary),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Text(MasteryLevel.fromXp(widget.mastery).label.toUpperCase(),
                              style: TextStyle(
                                color: Recolor.darken(widget.primary),
                                fontFamily: "LoveYaLikeASister",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                            Image(
                              image: AssetImage(MasteryLevel.fromXp(widget.mastery).asset),
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),

                        // FLASHCARD BUTTON
                        XLButton(
                          onTap: () => _redirectToStudy(),
                          surfacecolor: widget.primary,
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
                        SizedBox(height: 10),

                        // QUIZ BUTTON
                        XLButton(
                          onTap: () => _redirectToStudy(isQuiz: true),
                          surfacecolor: widget.primary,
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