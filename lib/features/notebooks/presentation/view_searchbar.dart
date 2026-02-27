import 'package:flutter/material.dart';

class NotebookSearchbar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final ValueChanged<String>? onChanged;

  const NotebookSearchbar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child:  TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
        decoration: InputDecoration(
          hintText: "Search notebooks",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if(value.text.isNotEmpty){
                return IconButton(
                  icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  onPressed: onClear, // CALLBACK 
                );
              } return const SizedBox.shrink();
            }
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}