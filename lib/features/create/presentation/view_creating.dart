import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/core/components/loader_md.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatingView extends StatefulWidget {
  const CreatingView({super.key});

  @override
  State<CreatingView> createState() => _CreatingViewState();
}

class _CreatingViewState extends State<CreatingView> {
  late final NotebookViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<NotebookViewModel>();
    _viewModel.addListener(_onViewModelChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
    _onViewModelChanged();
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_viewModel.isCreating) return;

    if (_viewModel.isSuccess) {
      ToastCard.success(context, "Notebook Created!");
      _viewModel.resetCreate();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Shell(initIndex: 1)),
        (route) => false,
      );
    } else if (_viewModel.createError != null) {
      ToastCard.error(context, _viewModel.createError!);
      _viewModel.clearCreateError();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MediumLoader(loading: ["Creating Structured Summary", "Generating Flashcards and Quiz", "Applying Cognitive Load Principles"]),
    );
  }
}