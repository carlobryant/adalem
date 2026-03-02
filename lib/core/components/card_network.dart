
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/core/network_status.dart';
import 'package:flutter/material.dart';

class CheckNetwork {
  static Future<void> execute({
    required bool signedIn,
    required BuildContext context,
    required Future<void> Function() onTap,
    VoidCallback? onNoConnection,
    
  }) async {
    ToastCard.clearNoInternet();
    try {
      final hasInternet = await NetworkStatus.hasInternet();
      if (!context.mounted) return;

      if (hasInternet) {
        await onTap();
      } else {
        if (onNoConnection != null) {
          onNoConnection();
        } else {
          ToastCard.noInternet(context, 
            "No Internet Connection!",
            description: signedIn ?
            "You can still view notebooks offline."
            : "Make sure your internet is stable to sign in.",
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      ToastCard.noInternet(context, 
        "Unexpected Error",
        description: "An unexpected error happened.",
      ); 
    } 
  }
}
