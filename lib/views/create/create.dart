import 'package:flutter/material.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
            "Create",
            style: TextStyle(color: Colors.white),
        )
     ),
    );
  }
}