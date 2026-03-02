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
        title: Text(
          title,
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        description: description != null ? Text(
          description,
          maxLines: 2, 
          overflow: TextOverflow.ellipsis,
          style:
            TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ) : null,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 6),
        icon: icon ?? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
        primaryColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
        title: Text(
          title,
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
        ),
        description: description != null ? Text(
          description,
          maxLines: 2, 
          overflow: TextOverflow.ellipsis,
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
          color: Theme.of(context).colorScheme.onError,
          ),
        primaryColor: Theme.of(context).colorScheme.error,
        backgroundColor: Theme.of(context).colorScheme.onError,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onError,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      );
    }

    static ToastificationItem? _activeNoInternetToast;

    static void clearNoInternet() {
      if (_activeNoInternetToast != null) {
        toastification.dismiss(_activeNoInternetToast!);
        _activeNoInternetToast = null;
      }
    }

    static void noInternet(
    BuildContext context,
    String title, {
    String? description,
    }) {
      _activeNoInternetToast = toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(
          title,
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
        ),
        description: description != null ? Text(
          description,
          maxLines: 2, 
          overflow: TextOverflow.ellipsis,
          style:
            TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ) : null,
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 6),
        icon: Image(
          image: AssetImage("assets/ic_warning.png"),
          width: 50,
          color: Theme.of(context).colorScheme.onError,
          ),
        primaryColor: Theme.of(context).colorScheme.error,
        backgroundColor: Theme.of(context).colorScheme.onError,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onError,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        callbacks: ToastificationCallbacks(
          onAutoCompleteCompleted: (_) => _activeNoInternetToast = null,
          onDismissed: (_) => _activeNoInternetToast = null,
        ),
      );
    }
}