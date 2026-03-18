import 'package:flutter/material.dart';

class XLButton extends StatefulWidget {
  final void Function()? onTap;
  final Widget child;

  const XLButton({
    super.key,
    required this.onTap,
    required this.child,
    });

  @override
  State<XLButton> createState() => _XLButtonState();
}

class _XLButtonState extends State<XLButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        foregroundDecoration: _isPressed ? BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black26,
          border: BoxBorder.fromLTRB(
            left: BorderSide(color: Theme.of(context).colorScheme.surface, width: 3),
            top: BorderSide(color: Theme.of(context).colorScheme.surface, width: 5),
          )
        )
        : null,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          border: BoxBorder.fromLTRB(
            left: _isPressed ? BorderSide(color: Theme.of(context).colorScheme.surface, width: 3)
            : BorderSide.none,
            top: _isPressed ? BorderSide(color: Theme.of(context).colorScheme.surface, width: 5)
            : BorderSide.none,
            right: _isPressed ? BorderSide.none
            : BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 3),
            bottom: _isPressed ? BorderSide.none
            : BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 5),
          ),
        ),
        padding: EdgeInsets.all(25),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}