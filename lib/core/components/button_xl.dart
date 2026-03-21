import 'package:flutter/material.dart';

class XLButton extends StatefulWidget {
  final void Function()? onTap;
  final Color? surfacecolor;
  final bool isCorrect;
  final bool isLocked;
  final bool inversed;
  final bool isItem;
  final Widget child;
  
  const XLButton({
    super.key,
    required this.onTap,
    this.surfacecolor,
    this.isCorrect = false,
    this.isLocked = false,
    this.inversed = false,
    this.isItem = false,
    required this.child,
    });

  @override
  State<XLButton> createState() => _XLButtonState();

}

class _XLButtonState extends State<XLButton> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    final double hw = 3;
    final double vw = 5;
    final surfacecolor = widget.surfacecolor ?? Theme.of(context).colorScheme.surface;

    final bgcolor = widget.isItem == false ?
      widget.inversed == false ?
      Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.onPrimary
        : widget.isCorrect == false ? 
          Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.primary;

    final shadowcolor = widget.isItem == false ?
      widget.inversed == false ?
      Theme.of(context).colorScheme.primaryContainer
      : Theme.of(context).colorScheme.onSurface
        : widget.isCorrect == false ? 
        Theme.of(context).colorScheme.surfaceContainer
          : Theme.of(context).colorScheme.primaryContainer;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) async {
        if(widget.isLocked) {
          await Future.delayed(Duration(milliseconds: 1200));
        }
        if(!mounted) return;
        setState(() => _isPressed = false);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 10),
        foregroundDecoration: _isPressed ? BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black26,
          border: BoxBorder.fromLTRB(
            left: BorderSide(color: surfacecolor, width: hw),
            top: BorderSide(color: surfacecolor, width: vw),
          )
        )
        : null,
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(16),
          border: BoxBorder.fromLTRB(
            left: _isPressed ?
            BorderSide(
              color: surfacecolor, width: hw)
            : BorderSide.none,
            top: _isPressed ? BorderSide(color: surfacecolor, width: vw)
            : BorderSide.none,
            right: _isPressed ? BorderSide.none
            : BorderSide(color: shadowcolor, width: hw),
            bottom: _isPressed ? BorderSide.none
            : BorderSide(color: shadowcolor, width: vw),
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