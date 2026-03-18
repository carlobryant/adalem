import 'package:adalem/core/components/button_xl.dart';
import 'package:flutter/material.dart';

class IdentificationView extends StatefulWidget {
  final String questionText;
  final String correctAnswer;
  final ValueChanged<bool> onSubmit;

  const IdentificationView({
    required this.questionText,
    required this.correctAnswer,
    required this.onSubmit,
    super.key,
  });

  @override
  State<IdentificationView> createState() => _IdentificationViewState();
}

class _IdentificationViewState extends State<IdentificationView> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final typedAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = widget.correctAnswer.trim().toLowerCase();
    
    // Clear controller for the next potential question
    _controller.clear(); 
    widget.onSubmit(typedAnswer == correctAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                widget.questionText,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "Type your answer...",
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        // ElevatedButton(
        //   onPressed: _submit,
        //   style: ElevatedButton.styleFrom(
        //     padding: const EdgeInsets.all(16.0),
        //     backgroundColor: Theme.of(context).colorScheme.primary,
        //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
        //   ),
        //   child: const Text("Submit Answer", style: TextStyle(fontSize: 16)),
        // ),
        XLButton(
          onTap: _submit,
          child: Text("Submit Answer",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
        ),
      ],
    );
  }
}