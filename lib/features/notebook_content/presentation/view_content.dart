import 'package:adalem/core/components/loader_md.dart';
import 'package:adalem/features/notebook_content/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/domain/uc_getcontent.dart';
import 'package:adalem/features/notebook_content/presentation/view_contentdrawer.dart';
import 'package:adalem/features/notebook_content/presentation/vm_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';

class ContentView extends StatelessWidget {
  final String notebookId;
  final String image;

  const ContentView({
    super.key, 
    required this.notebookId,
    required this.image,
    });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContentViewModel(
        getContent: GetContent(
          context.read<ContentRepositoryImpl>(),
        ),
      )..loadNotebookContent(notebookId),
      child: _ContentViewContent(notebookId: notebookId, image: image),
    );
  }
}

class _NotebookColorScheme {
  final Color primary;
  final Color secondary;

  const _NotebookColorScheme({required this.primary, required this.secondary});
}

class _ContentViewContent extends StatefulWidget {
  final String notebookId;
  final String image;
  const _ContentViewContent({required this.notebookId, required this.image});

  @override
  State<_ContentViewContent> createState() => _ContentViewContentState();

  _NotebookColorScheme _nbColors(String image) {
    switch(image) {
      case "red": return _NotebookColorScheme(primary: Color(0xFF270506), secondary: Color.fromARGB(255, 156, 64, 92));
      case "orange": return _NotebookColorScheme(primary: Color(0xFF2f1a05), secondary: Color(0xFFce4d25));
      case "yellow": return _NotebookColorScheme(primary: Color(0xFF373006), secondary: Color(0xFFc88e06));
      case "green": return _NotebookColorScheme(primary: Color(0xFF092d07), secondary: Color.fromARGB(255, 84, 109, 3));
      case "blue": return _NotebookColorScheme(primary: Color(0xFF00224f), secondary: Color(0xFF15599a));
      case "purple": return _NotebookColorScheme(primary: Color(0xFF210132), secondary: Color(0xFF5e4dfe));
      case "pink": return _NotebookColorScheme(primary: Color(0xFFd319de), secondary: Color(0xFF460a3d));
      case "grey": return _NotebookColorScheme(primary: Color(0xFF333333), secondary: Color.fromARGB(255, 100, 100, 100));
    }
    return _NotebookColorScheme(primary: Color(0xFF373006), secondary: Color(0xFFc88e06));
  }
}

class _ContentViewContentState extends State<_ContentViewContent> {
  late final ContentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ContentViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

// The following assertion was thrown while finalizing the widget tree:
// A ContentViewModel was used after being disposed.

  void _scrollToChapter(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContentViewModel>();
    final notebookColors = widget._nbColors(widget.image);

    if (viewModel.isLoading) {
      return const Scaffold(body: MediumLoader());
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text(viewModel.errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _viewModel.loadNotebookContent(widget.notebookId),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final chapters = viewModel.chapterModels;
    if (chapters.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No chapters found in this notebook.")),
      );
    }

    return Scaffold(
      drawer: ContentDrawer(
        chapters: chapters,
        onChapterTap: _scrollToChapter,
        onBack: () => Navigator.of(context, rootNavigator: true).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: chapters.asMap().entries.map((entry) {
              final index = entry.key;
              final chapterModel = entry.value;
              final chapter = chapterModel.chapter;
          
              return Container(
                key: chapterModel.scrollKey,
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
                          color: Theme.of(context).colorScheme.onPrimary,
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
                    //_buildBody(chapter.body),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Widget _buildBody(String rawBody) {
  //   final lines = rawBody
  //       .replaceAll(r'\\n', '<LITERAL_NEWLINE>')
  //       .replaceAll(r'\\t', '<LITERAL_TAB>')
  //       .replaceAll(r'\n', '\n')
  //       .replaceAll(r'\t', '\t')
  //       .replaceAll('<LITERAL_NEWLINE>', r'\n')
  //       .replaceAll('<LITERAL_TAB>', r'\t')
  //       .split('\n');

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: lines.map((line) {
  //       final hasIndent = line.startsWith('\t') || line.startsWith('    ');
  //       final indentWidth = 24.0; // match your tab size visually

  //       return Padding(
  //         padding: EdgeInsets.only(bottom: 4),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             if (hasIndent) SizedBox(width: indentWidth),
  //             Expanded(
  //               child: Text(
  //                 hasIndent ? line.trimLeft() : line,
  //                 style: const TextStyle(fontSize: 16, height: 1.5),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}