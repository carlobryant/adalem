import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/model_mastery.dart';
import 'package:adalem/core/app_theme.dart';
import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redacted/redacted.dart';

class ContentDrawer extends StatefulWidget {
  final List<ChapterModel>? chapters;
  final String notebookTitle;
  final String notebookId;
  final Color primary;
  final String course;
  final String image;
  final int mastery;

  final VoidCallback onFlashcardTap;
  final VoidCallback onQuizTap;
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
    
    this.onChapterTap,
    this.onClose,
    required this.onBack,
    required this.onFlashcardTap,
    required this.onQuizTap,
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
              child: GestureDetector(
                onTap: _isBottomBarVisible ? () {} 
                : () => setState(() => _isBottomBarVisible = true),
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
                              Stack(
                                alignment: AlignmentGeometry.center,
                                children: [
                                  Image(
                                    image: AssetImage(MasteryLevel.fromXp(widget.mastery).asset),
                                    color: Recolor.darken(widget.primary),
                                    width: 25,
                                  ),
                                  Image(
                                    image: AssetImage(MasteryLevel.fromXp(widget.mastery).asset),
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                
                          // FLASHCARD BUTTON
                          XLButton(
                            onTap: widget.onFlashcardTap,
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
                            onTap: widget.onQuizTap,
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
            ),

        ],
      ),
    );
  }
}