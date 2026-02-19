import 'package:adalem/features/notebooks/presentation/view_vnotebookcard.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  final NotebookViewModel notebookViewModel;
  const ExploreView({super.key, required this.notebookViewModel});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() async {
  widget.notebookViewModel.loadNotebooks();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notebookViewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Explore",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: _buildBody(),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (widget.notebookViewModel.errorMessage != null) {
      return Center(child: Text(widget.notebookViewModel.errorMessage!));
    }

    final isLoading = widget.notebookViewModel.isLoading;
    final items = isLoading
      ? List.filled(6, NotebookModel.empty()) 
      : widget.notebookViewModel.notebooks;

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onRefresh: _refresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 240,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final notebook = items[index];
          return VerticalNotebookCard(
            title: notebook.title,
            course: notebook.course,
            createdAt: notebook.createdAt,
            image: notebook.image,
            isLoading: widget.notebookViewModel.isLoading,
          );
        },
      ),
    );
  }
}