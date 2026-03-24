import 'package:adalem/core/app_theme.dart';
import 'package:flutter/material.dart';

class MediumButton extends StatefulWidget {
  final void Function()? onTap;
  final Color? surface;
  final Color? color;
  final Widget child;

  const MediumButton({
    super.key,
    this.onTap,
    this.surface,
    this.color,
    required this.child,
    });

  @override
  State<MediumButton> createState() => _MediumButtonState();
}

class _MediumButtonState extends State<MediumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double hw = 2;
    final double vw = 4;

    final double width = MediaQuery.sizeOf(context).width * 0.33 - 15;
    final Color surface = widget.surface ?? Theme.of(context).colorScheme.surface;
    final Color color = widget.color ?? Theme.of(context).colorScheme.primary;
    final Color borderColor = widget.color != null ? Recolor.darken(widget.color!)
      : Theme.of(context).colorScheme.primaryContainer;

    return GestureDetector(
      onTap: widget.onTap ?? () {},
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        foregroundDecoration: _isPressed ? BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black26,
          border: BoxBorder.fromLTRB(
            left: BorderSide(color: surface, width: hw),
            top: BorderSide(color: surface, width: vw),
          )
        )
        : null,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.fromLTRB(
            left: _isPressed ? BorderSide(color: surface, width: hw)
            : BorderSide.none,
            top: _isPressed ? BorderSide(color: surface, width: vw)
            : BorderSide.none,
            right: _isPressed ? BorderSide.none
            : BorderSide(color: borderColor, width: hw),
            bottom: _isPressed ? BorderSide.none
            : BorderSide(color: borderColor, width: vw),
          ),
        ),
        width: width,
        height: 120,
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}