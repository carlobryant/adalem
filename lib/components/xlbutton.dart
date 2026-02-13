import 'package:flutter/material.dart';

class XLButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;

  const XLButton({
    super.key,
    required this.child,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(25),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}