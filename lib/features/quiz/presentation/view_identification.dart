import 'package:adalem/core/components/button_xl.dart';
import 'package:flutter/material.dart';

class IdentificationView extends StatefulWidget {
  final String questionText;
  final String correctAnswer;
  final Future<void> Function(bool, String) onSubmit;

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

    _controller.clear(); 
    widget.onSubmit(typedAnswer == correctAnswer, correctAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.questionText.split('?:');
    final question = parts[0].trim();
    final hint = parts.length > 1 ? parts[1].trim() : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      
      children: [
        Spacer(),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    question,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  if (hint != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      hint,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
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
        XLButton(
          onTap: _submit,
          child: Text("Submit Answer",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
        ),
        Spacer(),
      ],
    );
  }
}