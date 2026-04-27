import 'package:adalem/core/components/card_carouseldots.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/view_vnotebookcard.dart';
import 'package:flutter/material.dart';

class ShareSelectionView extends StatefulWidget {
  final void Function(String)? onToggle;
  final List<NotebookModel> notebooks;
  final bool isSolid;

  const ShareSelectionView({
    super.key,
    this.onToggle,
    this.isSolid = false,
    required this.notebooks,
    });

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
    final pages = _pairPages();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 240,
          child: widget.notebooks.length > 1 ? 
          PageView.builder(
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
          )
          : Center(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.29),
            child: Stack(
              children: [
                VerticalNotebookCard(
                  title: widget.notebooks[0].title,
                  course: widget.notebooks[0].course,
                  updatedAt: widget.notebooks[0].updatedAt,
                  image: widget.notebooks[0].image,
                  available: widget.notebooks[0].available,
                  isLoading: false,
                  isSolid: widget.isSolid,
                ),

                if (widget.onToggle != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => widget.onToggle!(widget.notebooks[0].id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.close_rounded, size: 20,
                        color: Theme.of(context).colorScheme.inverseSurface),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ),
        const SizedBox(height: 12),
        if (pages.length > 1) CarouselCardDots(count: pages.length, current: _currentPage),
      ],
    );
  }

  Widget _buildNotebookCard(List<NotebookModel> pair, int index) {
    return Expanded(
      child: Stack(
        children: [
          VerticalNotebookCard(
            title: pair[index].title,
            course: pair[index].course,
            updatedAt: pair[index].updatedAt,
            image: pair[index].image,
            available: pair[index].available,
            isLoading: false,
            isSolid: widget.isSolid,
          ),

          if (widget.onToggle != null)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => widget.onToggle!(pair[index].id),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.close_rounded, size: 20,
                  color: Theme.of(context).colorScheme.inverseSurface),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}