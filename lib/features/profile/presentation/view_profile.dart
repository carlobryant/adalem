import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/auth/presentation/view_login.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/profile/presentation/view_analytics.dart';
import 'package:adalem/features/profile/presentation/view_signoutpopup.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    if(viewModel.error != null) {
      ToastCard.error(context, viewModel.error!.header, description:  viewModel.error!.description);
    }
  }

  void _handleSignOut() async {
    final profilevm = context.read<ProfileViewModel>();
    await profilevm.handleSignOut();
    if(!mounted) return;
    if(profilevm.error != null) return;

    context.read<NotebookViewModel>().clearData();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
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
            leadingWidth: 45,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: CircleAvatar(
                  foregroundImage: user.photoURL.isNotEmpty ? 
                  CachedNetworkImageProvider(user.photoURL) : null,
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  child: Image(
                    image: const AssetImage("assets/ic_error.png"),
                    color: Theme.of(context).colorScheme.surface,
                    width: 18,
                  ),
                ),
              ),
            ),
            title: Text(
            user.name,
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
                          username: user.name,
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
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final notebookvm = context.read<NotebookViewModel>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AnalyticsView(),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10),
              _buildRow("Total Notebooks", "${notebookvm.notebookCount}", "total"), 
              SizedBox(height: 20),
              _buildRow("Shared Notebooks", "${notebookvm.sharedNotebookCount}", "shared"),
              SizedBox(height: 20),
              _buildRow("Received Notebooks", "${notebookvm.receivedNotebookCount}", "received"),
              SizedBox(height:  10),
            ],
          )
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("test"),
            ),
          ),
        ),

        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("test"),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String title, String end, [String? icon]){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(icon != null)
        Image(image: AssetImage("assets/ic_nb_$icon.png"),
          color: Theme.of(context).colorScheme.inverseSurface,
          width: 50,
        ),
        if(icon != null)
        SizedBox(width: 10),
        Text(title,
          style: TextStyle(
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Spacer(),
        Text(end,
          style: TextStyle(
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}