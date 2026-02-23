import 'package:adalem/features/notebooks/presentation/view_vnotebookcard.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  Future<void> _refresh() async {
  context.read<NotebookViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotebookViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Explore",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _buildBody(viewModel),
      ),
    );
  }

  Widget _buildBody(NotebookViewModel viewModel) {
    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    final isLoading = viewModel.isLoading;
    final items = isLoading
      ? List.filled(6, NotebookModel.empty()) 
      : viewModel.notebooks;

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
            isLoading: viewModel.isLoading,
          );
        },
      ),
    );
  }
}