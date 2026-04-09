import 'package:adalem/features/profile/presentation/view_analyticscard.dart';
import 'package:flutter/material.dart';

class AnalyticsView extends StatefulWidget {
  final Map<DateTime, ({int total, String summary})>? detailedData;
  const AnalyticsView({super.key, required this.detailedData});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 290,
          child: PageView.builder(
            controller: _controller,
            itemCount: 2,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == 0 ? 4 : 0),
              child: AnalyticsCard(detailedData: index == 0 ? widget.detailedData : null),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _DotsIndicator(count: 2, current: _currentPage),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.surfaceContainer
                : Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}