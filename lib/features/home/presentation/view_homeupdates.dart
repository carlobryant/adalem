import 'package:adalem/core/components/card_carouseldots.dart';
import 'package:adalem/features/home/domain/updates_entity.dart';
import 'package:adalem/features/home/presentation/view_updatecard.dart';
import 'package:flutter/material.dart';

class HomeUpdatesView extends StatefulWidget {
  final List<Update> updates;
  const HomeUpdatesView({super.key, required this.updates});

  @override
  State<HomeUpdatesView> createState() => _HomeUpdatesViewState();
}

class _HomeUpdatesViewState extends State<HomeUpdatesView> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  bool onTap = false;
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

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    final surfaceColor = Theme.of(context).colorScheme.surface;
    // final boxHgColor = Theme.of(context).colorScheme.onTertiary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 210,
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: onSurface,
                borderRadius: BorderRadius.circular(20),
                border: BoxBorder.fromLTRB(
                  bottom: onTap ? BorderSide.none : BorderSide(width: 5, color: borderColor),
                  right: onTap ? BorderSide.none : BorderSide(width: 3, color: borderColor),
                  top: onTap ?  BorderSide(width: 5, color: surfaceColor) : BorderSide.none,
                  left: onTap ?  BorderSide(width: 3, color: surfaceColor) : BorderSide.none,
                ),
              ),
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.updates.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ?  8 : 16,
                    right: index == widget.updates.length-1
                    || widget.updates.length == 1 ? 8 : 16,
                  ),
                  child: UpdateCardView(
                    title: widget.updates[index].title,
                    description: widget.updates[index].description,
                    createdAt: widget.updates[index].createdAt,
                    photoURL: widget.updates[index].photoURL,
                    path: widget.updates[index].path,
                    onTap: () async {
                      setState(() => onTap = true);
                      await Future.delayed(Duration(milliseconds: 2000));
                      setState(() => onTap = false);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.updates.length > 1)
          CarouselCardDots(count: widget.updates.length, current: _currentPage),
      ],
    );
  }
}