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
  bool _showAnswer = false;

  Future<void> _submit() async {
    //if (_controller.text.trim().isEmpty) return;

    setState(() => _showAnswer = true);
    final typedAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = widget.correctAnswer.trim().toLowerCase();
    await widget.onSubmit(typedAnswer == correctAnswer, correctAnswer);
    if (!mounted) return;

    _controller.clear(); 
    setState(() => _showAnswer = false);
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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                const SizedBox(height: 20),
                
                TextField(
                  controller: _controller,
                  style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                  decoration: InputDecoration(
                    labelText: "Type your answer",
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        width: 2,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                
                const SizedBox(height: 24),
                
               XLButton(
                  isLocked: !_showAnswer,
                  onTap: _submit,
                  child: Text(
                    _showAnswer ? "Correct Answer: ${widget.correctAnswer}" : "Submit Answer",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              border: BoxBorder.fromLTRB(
                bottom: BorderSide(
                  width: 5, 
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.30,
            child: Padding(
              padding: const EdgeInsets.only(left: 26, right: 26, bottom: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        question,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: question.length > 150 ? 18 
                                  : question.length < 90 ? 22 : 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (hint != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          hint,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}