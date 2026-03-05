import 'package:adalem/core/components/loader_md.dart';
import 'package:adalem/features/notebook_content/data/firestore_datasource.dart';
import 'package:adalem/features/notebook_content/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/domain/uc_getcontent.dart';
import 'package:adalem/features/notebook_content/presentation/view_contentdrawer.dart';
import 'package:adalem/features/notebook_content/presentation/vm_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentView extends StatelessWidget {
  final String notebookId;

  const ContentView({super.key, required this.notebookId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContentViewModel(
        getContent: GetContent(
          ContentRepositoryImpl(dataSource: ContentDataSourceImpl()),
        ),
      )..loadNotebookContent(notebookId),
      child: _ContentViewContent(notebookId: notebookId),
    );
  }
}

class _ContentViewContent extends StatefulWidget {
  final String notebookId;
  const _ContentViewContent({required this.notebookId});

  @override
  State<_ContentViewContent> createState() => _ContentViewContentState();
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

  void _scrollToChapter(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContentViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        body: MediumLoader(),
      );
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
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                    Text(
                      "${index + 1}. ${chapter.header}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      chapter.body,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}