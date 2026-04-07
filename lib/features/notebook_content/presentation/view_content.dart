import 'package:adalem/core/app_theme.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/flashcards/domain/flashcard_algo.dart';
import 'package:adalem/features/flashcards/domain/uc_syncflashcards.dart';
import 'package:adalem/features/flashcards/presentation/view_flashcard.dart';
import 'package:adalem/features/flashcards/presentation/vm_flashcard.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';
import 'package:adalem/features/notebook_content/domain/uc_getcontent.dart';
import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:adalem/features/notebook_content/presentation/view_contentdrawer.dart';
import 'package:adalem/features/notebook_content/presentation/vm_content.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/quiz/domain/uc_syncquiz.dart';
import 'package:adalem/features/quiz/presentation/view_quiz.dart';
import 'package:adalem/features/quiz/presentation/vm_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class ContentView extends StatelessWidget {
  final String notebookId;
  final String notebookTitle;
  final String notebookCourse;
  final bool toFlashcard;
  final bool toQuiz;
  final String image;

  const ContentView({
    super.key, 
    required this.notebookId,
    required this.notebookTitle,
    required this.notebookCourse,
    this.toFlashcard = false,
    this.toQuiz = false,
    required this.image,
    });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = ContentViewModel(
          getContent: GetContent(
            context.read<ContentRepo>(),
          ),
        );

        Future.microtask(() => viewModel.loadNotebookContent(notebookId));
        return viewModel;
      },
      child: _ContentView(
        notebookId: notebookId,
        notebookTitle: notebookTitle,
        notebookCourse: notebookCourse,
        toFlaschard: toFlashcard,
        toQuiz: toQuiz,
        image: image,

      ),
    );
  }
}

class _ContentView extends StatefulWidget {
  final String notebookId;
  final String notebookTitle;
  final String notebookCourse;
  final bool toFlaschard;
  final bool toQuiz;
  final String image;

  const _ContentView({
    required this.notebookId,
    required this.notebookTitle,
    required this.notebookCourse,
    this.toFlaschard = false,
    this.toQuiz = false,
    required this.image,
    });

  @override
  State<_ContentView> createState() => _ContentViewState();

  NotebookTheme _nbColors(String image) {
    return NotebookTheme.values.firstWhere(
      (t) => t.name == image,
      orElse: () => NotebookTheme.yellow,
    );
  }
}

class _ContentViewState extends State<_ContentView> {
  final ListController _listController = ListController();
  late final ContentViewModel _contentvm;

  // DRAWER WIDGET
  double _drawerOffset = 0.0; 
  bool _isDrawerVisible = true;

  // DRAWER BUTTON
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  // bool _hasAutoRedirected = false;

  @override
  void initState() {
    super.initState();
    _contentvm = context.read<ContentViewModel>();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isFabVisible) setState(() => _isFabVisible = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isFabVisible) setState(() => _isFabVisible = true);
      }
    });

    if (widget.toFlaschard || widget.toQuiz) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleStudyRedirect(isQuiz: widget.toQuiz));
    }
  }

  // STUDY TOOLS NAVIGATION
  void _handleStudyRedirect({bool isQuiz = false}) async {
    // if ((widget.toFlaschard || widget.toQuiz) && _hasAutoRedirected) return;
    // _hasAutoRedirected = true;

    final currentUser = context.read<AuthRepo>().getCurrentUser();
    if (currentUser == null) return;
    final uid = currentUser.uid;

    final notebookvm = context.read<NotebookViewModel>();
    final mastery = notebookvm.getMasteryFor(widget.notebookId, uid);
    final currentUserEntity = notebookvm.getUserEntityFor(widget.notebookId, uid);

    if (isQuiz) {
      final quizvm = QuizViewModel(syncQuizHistory: context.read<SyncQuizHistory>());
      if (!mounted) return;
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

      if (_contentvm.content == null) {
        await _contentvm.loadNotebookContent(widget.notebookId);
      }
      // GET INITIAL DIFFICULTY FROM HISTORY
      quizvm.initSession(_contentvm.content!, currentUserEntity, currentMastery: mastery);
      
    } else {
      final flashcardvm = FlashcardViewModel(
        sm2: const SM2Algorithm(),
        sessionService: const FlashcardSession(),
        syncFlashcardProgress: context.read<SyncFlashcards>(),
      );
      
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(value: flashcardvm,
            child: FlashcardView(viewModel: flashcardvm,
              notebookId: widget.notebookId, 
              uid: uid, mastery: mastery,
              onAgain: () => WidgetsBinding.instance.addPostFrameCallback((_) => _handleStudyRedirect(isQuiz: false)),
            ),
          ),
        ),
      );

      if (_contentvm.quizItemModels.isEmpty) {
        await _contentvm.loadNotebookContent(widget.notebookId, load: {ContentType.flashcards});
      }
      final allItems = _contentvm.quizItemModels.map((q) => q.quizItem).toList();
      flashcardvm.initSession(allItems, currentUserEntity);
    }
  }

  void _openDrawer() {
    setState(() {
      _drawerOffset = 0.0;
      _isDrawerVisible = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _drawerOffset = -1.0;
      _isDrawerVisible = false;
    });
  }

  void _scrollToChapter(int index) {
    _closeDrawer();

    _listController.animateToItem(
      index: index,
      scrollController: _scrollController, 
      alignment: 0.0,
      duration: (estimatedDistance) => Duration(milliseconds: 2000),
      curve: (estimatedDistance) => Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContentViewModel>();
    final notebookColors = widget._nbColors(widget.image);

    final notebookVM = context.read<NotebookViewModel>();
    final currentUser = context.read<AuthRepo>().getCurrentUser();
    final int mastery = currentUser != null ? 
    notebookVM.getMasteryFor(widget.notebookId, currentUser.uid) : 0;

    if(viewModel.isLoading) {
      return Scaffold(
        body: ContentDrawer(
          onBack: () => Navigator.of(context, rootNavigator: true).pop(),
          notebookId: widget.notebookId,
          mastery: mastery,
          image: widget.image,
          course: widget.notebookCourse,
          primary: notebookColors.primary,
          notebookTitle: widget.notebookTitle,
          onFlashcardTap: () => _handleStudyRedirect(isQuiz: false),
          onQuizTap: () => _handleStudyRedirect(isQuiz: true),
          ),
      );
    }

    if (viewModel.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text(viewModel.error!.header),
              Text(viewModel.error!.description),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _contentvm.loadNotebookContent(widget.notebookId),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final chapters = viewModel.chapterModels;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: _isDrawerVisible,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!_isDrawerVisible) {
          _openDrawer();
        } 
      },
      child: Scaffold(
        body: Stack(
          children: [
            // CONTENT
            _buildNotebookContent(chapters, notebookColors),
            
            // DRAWER BUTTON
            Positioned(
              top: topPadding > 0 ? topPadding + 10 : 20,
              left: 16,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                scale: (_isFabVisible && !_isDrawerVisible) ? 1.0 : 0.0,
                child: FloatingActionButton(
                  mini: true, 
                  heroTag: "drawer_menu_btn",
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  onPressed: _openDrawer,
                  child: Icon(
                    Icons.menu, 
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),

            // DRAWER OVERLAY
            if (_isDrawerVisible) 
            Positioned.fill(
                  child: GestureDetector(
                    onTap: _closeDrawer,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _drawerOffset == 0 ? 1.0 : 0.0,
                      child: Container(color: Colors.black54),
                    ),
                  ),
                ),
            
            // DRAWER
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: _drawerOffset * (screenWidth),
              top: 0,
              bottom: 0,
              width: screenWidth,
              child: ContentDrawer(
                notebookTitle: widget.notebookTitle,
                primary: notebookColors.primary,
                chapters: chapters, 
                onChapterTap: _scrollToChapter, 
                notebookId: widget.notebookId,
                course: widget.notebookCourse,
                mastery: mastery,
                image: widget.image,
                onBack: () => Navigator.of(context, rootNavigator: true).pop(),
                onClose: _closeDrawer,
                onFlashcardTap: () => _handleStudyRedirect(isQuiz: false),
                onQuizTap: () => _handleStudyRedirect(isQuiz: true),
                ),
            ),

          // NOT FOUND
          if (chapters.isEmpty && !viewModel.isLoading)
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: screenWidth,
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(child: Text("No chapters found in this notebook."))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotebookContent(List<ChapterModel> chapters, NotebookTheme notebookColors){
    return SafeArea(
      child: SuperListView.builder(
        controller: _scrollController,
        listController: _listController,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapterModel = chapters[index];
          final chapter = chapterModel.chapter;
      
          return Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("CHAPTER ${index + 1}: "),
                ),
                Container(
                  width: double.infinity, 
                  decoration: BoxDecoration(
                    color: notebookColors.primary,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(40.0), bottomRight: Radius.circular(40.0)),
                  ),
                  padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 35.0, bottom: 5.0),
                  margin: EdgeInsets.only(right: 20.0),
                  child: Text(
                    chapter.header.toUpperCase(),
                    style: TextStyle(
                      color: Recolor.darken(notebookColors.primary),
                      fontFamily: "LoveYaLikeASister",
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MarkdownBody(
                    data: chapter.body,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 16, height: 1.5),
                      listBullet: const TextStyle(fontSize: 16, height: 1.5),
                      a: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        ),
                      blockquote: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      blockquoteDecoration: BoxDecoration(
                        color: notebookColors.secondary,
                        borderRadius: BorderRadius.circular(15.0),
                        ),
                      horizontalRuleDecoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
      }),
    );
  }
}