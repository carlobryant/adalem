import 'package:adalem/components/card_popup.dart';
import 'package:adalem/features/explore/presentation/view_filterpopup.dart';
import 'package:adalem/features/notebooks/presentation/view_searchbar.dart';
import 'package:adalem/features/notebooks/presentation/view_vnotebookcard.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => ExploreViewState();
}

class ExploreViewState extends State<ExploreView> {
  Future<void> _refresh() async {context.read<NotebookViewModel>();}
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void scrollToTop() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    _refresh();
    
    if(_scrollController.hasClients) {
      await _scrollController.animateTo(0.0,
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeOut,
      );
    }
    _searchFocusNode.requestFocus();
  }

  void _filterSearch() {
    _searchFocusNode.unfocus();
    Navigator.of(context).push(
      PopupCard(builder: (context) => const FilterPopup())
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotebookViewModel>();
    return Scaffold(
      body: NestedScrollView(
        //floatHeaderSlivers: true,
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: NotebookSearchbar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onClear: () {
                _searchController.clear();
                viewModel.setSearchQuery("");
              },
              onChanged: (value) {
                viewModel.setSearchQuery(value);
              },
            ),
            actions: [
              Hero(
                tag: heroFilterTag,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    onPressed: _filterSearch, 
                    icon: Icon(Icons.filter_list,
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          )
        ], 
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onRefresh: _refresh,
          child: SafeArea(
            child: _buildBody(viewModel),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NotebookViewModel viewModel) {
    if (viewModel.streamError != null) {
      return Center(child: Text(viewModel.streamError!));
    }

    final isLoading = viewModel.isLoading;
    final items = isLoading ? 
    List.filled(6, NotebookModel.empty()) : viewModel.filteredNotebooks;
    
    return !isLoading && items.isEmpty ?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/ic_notfound.png"),
            width: 180,
            color: Theme.of(context).colorScheme.onSurface,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text("No Notebooks Found!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    )
    : GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
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
    );
  }
}