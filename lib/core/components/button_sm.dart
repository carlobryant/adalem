
import 'package:flutter/material.dart';

class SmallButton extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onBack;
  final Widget child;

  const SmallButton({
    super.key,
    this.onTap,
    this.onBack,
    required this.child,
    });

  @override
  State<SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = widget.onTap != null ?
    Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainer;

    return GestureDetector(
      onTap: widget.onTap ?? widget.onBack ?? () {},
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        foregroundDecoration: _isPressed ? BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black26,
          border: BoxBorder.fromLTRB(
            left: BorderSide(color: Theme.of(context).colorScheme.surface, width: 1),
            top: BorderSide(color: Theme.of(context).colorScheme.surface, width: 3),
          )
        )
        : null,
        decoration: BoxDecoration(
          color: widget.onTap != null ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.fromLTRB(
            left: _isPressed ? BorderSide(color: Theme.of(context).colorScheme.surface, width: 1)
            : BorderSide.none,
            top: _isPressed ? BorderSide(color: Theme.of(context).colorScheme.surface, width: 3)
            : BorderSide.none,
            right: _isPressed ? BorderSide.none
            : BorderSide(color: borderColor, width: 1),
            bottom: _isPressed ? BorderSide.none
            : BorderSide(color: borderColor, width: 3),
          ),
        ),
        width: 100,
        height: 50,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}