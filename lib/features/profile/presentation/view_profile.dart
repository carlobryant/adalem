import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/auth/presentation/view_login.dart';
import 'package:adalem/features/auth/presentation/vm_login.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/profile/presentation/view_signoutpopup.dart';
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
    _viewModel.init();
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
    final profilevm = context.read<ProfileViewModel>();
    await profilevm.handleSignOut();
    if(!mounted) return;
    if(profilevm.errorMessage != null) return;

    context.read<NotebookViewModel>().clearData();
    context.read<LoginViewModel>().reset();

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginView()),
    (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final user = viewModel.user!;
    final username = user.name.isNotEmpty ? user.name : "User";

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:(context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
            username,
            style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              Hero(
                tag: heroSignoutTag,
                createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PopupHeroDialog(builder: (context) => SignOutPopup(
                          username: username,
                          onConfirm: _handleSignOut,
                        ))
                      );
                    }, 
                    icon: Icon(Icons.logout,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
        body: Text("test")),
    );
  }
}