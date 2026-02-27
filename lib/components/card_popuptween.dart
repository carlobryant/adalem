import 'dart:ui';
import 'package:flutter/material.dart';

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