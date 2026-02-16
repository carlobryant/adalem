import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastCard {
  ToastCard._();

  static void success(
    BuildContext context,
    String title, {
    String? description,
    Widget? icon,
    }) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text(title),
        description: description != null ? Text(
          description,
          style:
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ) : null,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 6),
        icon: icon ?? const Icon(Icons.check_circle),
        primaryColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      );
    }

  static void error(
    BuildContext context,
    String title, {
    String? description,
    }) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(title),
        description: description != null ? Text(
          description,
          style:
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ) : null,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 6),
        icon: Image(
          image: AssetImage("assets/ic_error.png"),
          width: 50,
          color: const Color.fromARGB(255, 75, 2, 2),
          ),
        primaryColor: Colors.red.shade500,
        backgroundColor: const Color.fromARGB(255, 75, 2, 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 75, 2, 2),
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      );
    }

  static void warning() {}
  static void info() {}
}