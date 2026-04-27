import 'package:adalem/core/components/button_sm.dart';
import 'package:adalem/core/components/card_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareToPicker extends StatefulWidget {
  final Function(String email) onAdd;
  final bool isLoading;

  const ShareToPicker({
    super.key,
    required this.onAdd,
    required this.isLoading,
    });

  @override
  State<ShareToPicker> createState() => _ShareToPickerState();
}

class _ShareToPickerState extends State<ShareToPicker> {
  final TextEditingController _controller = TextEditingController();
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      if (text.contains('@')) {
        final stripped = text.split('@').first;
        _controller.value = _controller.value.copyWith(
          text: stripped,
          selection: TextSelection.collapsed(offset: stripped.length),
        );
      }
    final hasInput = _controller.text.trim().length >= 6;
      if (hasInput != _hasInput) setState(() => _hasInput = hasInput);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() async {
    final email = "${_controller.text.trim()}@gmail.com";
    if (_controller.text.trim().isEmpty) return;
    final result = await widget.onAdd(email);
    if (result != null) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.fromLTRB(
            bottom: BorderSide(width: 5, color: borderColor),
            right: BorderSide(width: 3, color: borderColor),
            top: BorderSide.none,
            left: BorderSide.none,
          ),
      ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 30,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[\s]')),
                  ],
                  style: TextStyle(
                    fontSize: 13
                  ),
                  controller: _controller,
                  onSubmitted: (_) => _handleAdd(),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Enter email",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                    suffix: Text(
                      "@gmail.com",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  scale: _hasInput ? 1 : 0,
                  child: !widget.isLoading ? !_hasInput ? null : SmallButton(
                    surfacecolor: Theme.of(context).colorScheme.surface,
                    onTap: () => CheckNetwork.execute(
                      signedIn: true,
                      context: context,
                      onTap: () async { _handleAdd(); }),
                    child:Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ) : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}