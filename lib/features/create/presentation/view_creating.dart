import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/core/components/animation_loader.dart';
import 'package:adalem/features/create/presentation/vm_create.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:adalem/shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatingView extends StatefulWidget {
  const CreatingView({super.key});

  @override
  State<CreatingView> createState() => _CreatingViewState();
}

class _CreatingViewState extends State<CreatingView> {
  late final CreateViewModel createvm;
  bool _hasLoggedActivity = false;
  bool _createError = false;

  @override
  void initState() {
    super.initState();
    createvm = context.read<CreateViewModel>();
    createvm.addListener(_onViewModelChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _onViewModelChanged();
    });
  }

  @override
  void dispose() {
    createvm.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if(createvm.isCreating) return;

    final profilevm = context.read<ProfileViewModel>();
    if(createvm.error != null) {
      setState(() {
        _createError = true;
      });
      Navigator.of(context, rootNavigator: true).pop();
      ToastCard.error(context, createvm.error!.header, description: createvm.error!.description);
      createvm.clearCreateError();
    }
    else if(createvm.isSuccess && !_hasLoggedActivity) {
      _hasLoggedActivity = true; 
      profilevm.addActivityStat(created: 1); 
      ToastCard.success(context, "Notebook Created", 
      description: "Do not close app while generating!");
      createvm.resetCreate();
      
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