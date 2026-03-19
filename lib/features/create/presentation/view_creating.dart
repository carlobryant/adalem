import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/core/components/animation_loader.dart';
import 'package:adalem/features/create/presentation/vm_create.dart';
import 'package:adalem/shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatingView extends StatefulWidget {
  const CreatingView({super.key});

  @override
  State<CreatingView> createState() => _CreatingViewState();
}

class _CreatingViewState extends State<CreatingView> {
  late final CreateViewModel _createViewModel;
  bool _createError = false;

  @override
  void initState() {
    super.initState();
    _createViewModel = context.read<CreateViewModel>();
    _createViewModel.addListener(_onViewModelChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
    _onViewModelChanged();
    });
  }

  @override
  void dispose() {
    _createViewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_createViewModel.isCreating) return;
    if (_createViewModel.createError != null) {
      setState(() {
        _createError = true;
      });
      Navigator.of(context, rootNavigator: true).pop();
      ToastCard.error(context, _createViewModel.createError![0], description: _createViewModel.createError![1]);
      _createViewModel.clearCreateError();
    }
    else if (_createViewModel.isSuccess) {
      ToastCard.success(context, "Notebook Created!");
      _createViewModel.resetCreate();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Shell(initIndex: 1)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _createError,
      child: const Scaffold(
        body: LoaderAnimation(loading: ["Creating Structured Summary", "Generating Flashcards and Quiz", "Applying Cognitive Load Principles"]),
      ),
    );
  }
}