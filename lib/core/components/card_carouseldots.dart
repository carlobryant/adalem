import 'package:flutter/material.dart';

class CarouselCardDots extends StatelessWidget {
  const CarouselCardDots({super.key, required this.count, required this.current});

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