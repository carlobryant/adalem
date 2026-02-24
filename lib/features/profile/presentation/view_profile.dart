import 'package:adalem/components/card_toast.dart';
import 'package:adalem/features/auth/presentation/view_login.dart';
import 'package:adalem/features/auth/presentation/vm_login.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ProfileViewModel>();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final viewModel = context.read<ProfileViewModel>();
    if(viewModel.errorMessage != null) {
      ToastCard.error(context, viewModel.errorMessage!);
    }
  }

  void _handleSignOut() async {
    await context.read<ProfileViewModel>().handleSignOut();
    if(!mounted) return;
    context.read<LoginViewModel>().reset();
    Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder: (context) => const LoginView()),
    (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final user = viewModel.user!;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:(context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
            user.name.isNotEmpty ? user.name : "User",
            style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          )
        ],
        body: Text("test")),
    );
  }
}