import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/explore/presentation/view_filterpopup.dart';
import 'package:adalem/features/notebook_content/presentation/view_content.dart';
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
      PopupHeroDialog(builder: (context) => const FilterPopup())
    );
  }

  void _redirectToContent(String title, String id, String image, bool available, String? contentId) {
    if(contentId==null) {
      ToastCard.clearError();
      if(!available) {
        ToastCard.error(context, "Try Again Later",
        description: "$title is still processing.");
        return;
      } else {
        ToastCard.error(context, "Notebook Missing",
        description: "$title not found.");
        return;
      }
    }
    Navigator.of(context, rootNavigator: true)
      .push(MaterialPageRoute(
        builder: (context) => ContentView(notebookId: id, image: image)
        ));
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
                createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
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
          onRefresh: () async {
            viewModel.setSortOption(viewModel.currentSort); 
            await Future.delayed(const Duration(milliseconds: 550));
            },
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
        return GestureDetector(
          onTap: isLoading ? null 
          : () => _redirectToContent(
            notebook.title,
            notebook.id, 
            notebook.image,
            notebook.available,
            notebook.contentId,
          ),
          child: VerticalNotebookCard(
            title: notebook.title,
            course: notebook.course,
            updatedAt: notebook.updatedAt,
            image: notebook.image,
            isLoading: viewModel.isLoading,
          ),
        );
      },
    );
  }
}