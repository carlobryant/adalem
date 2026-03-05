import 'dart:ui';

import 'package:flutter/material.dart';

class PopupHeroDialog<T> extends PageRoute<T> {
  PopupHeroDialog({
    required WidgetBuilder builder,
    super.settings,
    super.fullscreenDialog,
  }) : _builder = builder;

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 150);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => "Popup dialog open";

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
    return child;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,) {
      return _builder(context);
  }
}

class PopupTween extends RectTween {
  PopupTween({required super.begin, required super.end});

  @override
  Rect lerp(double t) {
    final curvedT = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, curvedT)!,
      lerpDouble(begin!.top, end!.top, curvedT)!,
      lerpDouble(begin!.right, end!.right, curvedT)!,
      lerpDouble(begin!.bottom, end!.bottom, curvedT)!,
    );
  }
}