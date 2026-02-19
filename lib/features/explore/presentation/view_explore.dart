import 'package:adalem/features/notebooks/presentation/view_vnotebookcard.dart';
import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/data/repo_impl.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebook.dart';
import 'package:adalem/features/explore/presentation/vm_explore.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  late final ExploreViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ExploreViewModel(
      getNotebooks: GetNotebooks(
        NotebookRepositoryImpl(
          dataSource: FirestoreDataSourceImpl(),
        ),
      ),
    );
    _viewModel.loadNotebooks();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
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
    if (_viewModel.errorMessage != null) {
      return Center(child: Text(_viewModel.errorMessage!));
    }

    final isLoading = _viewModel.isLoading;
  final items = isLoading
      ? List.filled(6, NotebookCardModel.empty()) 
      : _viewModel.notebooks;

    return GridView.builder(
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
          isLoading: _viewModel.isLoading,
        );
      },
    );
  }
}