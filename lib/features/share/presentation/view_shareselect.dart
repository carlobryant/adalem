import 'package:adalem/core/components/card_carouseldots.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/view_vnotebookcard.dart';
import 'package:flutter/material.dart';

class ShareSelectionView extends StatefulWidget {
  final List<NotebookModel> notebooks;
  const ShareSelectionView({super.key, required this.notebooks});

  @override
  State<ShareSelectionView> createState() => _ShareSelectionViewState();
}

class _ShareSelectionViewState extends State<ShareSelectionView> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<List<NotebookModel>> _pairPages() {
    final pages = <List<NotebookModel>>[];
    for (int i = 0; i < widget.notebooks.length; i += 2) {
      pages.add(widget.notebooks.sublist(i, 
        (i + 2).clamp(0, widget.notebooks.length)));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final pages = _pairPages();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final pair = pages[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: index == 0 ?  0 : 5,
                    right: index == pages.length-1
                    || pages.length == 1 ? 0 : 5,
                  ),
                child: Row(
                  children: [
                    _buildNotebookCard(pair, 0),
                    if (pair.length > 1) ...[
                      const SizedBox(width: 10),
                      _buildNotebookCard(pair, 1),
                    ] else const Expanded(child: SizedBox()),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        if (pages.length > 1) CarouselCardDots(count: pages.length, current: _currentPage),
      ],
    );
  }

  Widget _buildNotebookCard(List<NotebookModel> pair, int index) {
    return Expanded(
      child: VerticalNotebookCard(
        title: pair[index].title,
        course: pair[index].course,
        updatedAt: pair[index].updatedAt,
        image: pair[index].image,
        available: pair[index].available,
        isLoading: false,
      ),
    );
  }
}