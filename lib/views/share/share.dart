import 'package:flutter/material.dart';

class ShareView extends StatelessWidget {
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
            "Share",
            style: TextStyle(color: Colors.white),
        )
     ),
    );
  }
}