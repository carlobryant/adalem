import 'package:adalem/core/components/animation_loader.dart';
import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/domain/uc_sharenotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/share/presentation/view_selectpopup.dart';
import 'package:adalem/features/share/presentation/view_sharecomplete.dart';
import 'package:adalem/features/share/presentation/view_shareselect.dart';
import 'package:adalem/features/share/presentation/view_sharetopicker.dart';
import 'package:adalem/features/share/presentation/view_sharetousers.dart';
import 'package:adalem/features/share/presentation/vm_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareView extends StatelessWidget {
  const ShareView({
    super.key,
    });

  @override
  Widget build(BuildContext context) {
    final notebookrepo = context.read<NotebookRepo>();

    return ChangeNotifierProvider(
      create: (context) => ShareViewModel(
        getNotebookCount: GetNotebookCount(notebookrepo),
        getCurrentUser: GetCurrentUser(context.read<AuthRepo>()),
        getUserProfile: context.read<GetUserProfile>(),
        shareNotebooks: ShareNotebooks(notebookrepo),
      ),
      child: _ShareViewContent(),
    );
  }
}


class _ShareViewContent extends StatefulWidget {
  const _ShareViewContent();

  @override
  State<_ShareViewContent> createState() => _ShareViewContentState();
}

class _ShareViewContentState extends State<_ShareViewContent> {
  List<AuthUser> sharedUsers = [];
  List<NotebookModel> sharedNotebooks =[];

  void _onViewModelChanged({ErrorModel? error, String? success}) {
    if(error != null) {
      ToastCard.clearError();
      ToastCard.error(context, error.header, description: error.description);
    } else if(success != null) {
      ToastCard.success(context, success);
    }
    
  }

  void _shareToast(String? error) {
    if(error != null) {
      ToastCard.clearError();
      ToastCard.error(context, "Notebook Reached Share Limit",
      description: "Cannot share $error.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharevm = context.watch<ShareViewModel>();
    final users = sharevm.recipients;

    final notebookvm = context.watch<NotebookViewModel>();
    final shareableNotebooks = notebookvm.shareableNotebooks;
    final notebooks = notebookvm.selectedNotebooks;

    final error = sharevm.error;
    final success = sharevm.success;
    if (error != null || success != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          error != null ? _onViewModelChanged(error: error) : _onViewModelChanged(success: success);
          error != null ? context.read<ShareViewModel>().clearError() : context.read<ShareViewModel>().clearSuccess();
        }
      });
    } 

    return Scaffold(
     body: sharevm.isSharing ?
      LoaderAnimation(loading: ["Sharing notebooks"])

      : sharevm.isShared ?
      ShareCompleteView(
        onBack: () => sharevm.returnToShare(),
        notebooks: sharedNotebooks,
        users: sharedUsers
      )

      : NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            leadingWidth: 45,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text( notebooks.isEmpty ? shareableNotebooks.isEmpty ? "No Shareable Notebooks" : "Select Notebook To Share"
            : notebooks.length > 1 ? "${notebooks.length} Notebooks Selected" : notebooks[0].title,
                style: TextStyle(color: Colors.white),
            ),
            actions: [
            // NOTEBOOK SELECTION
            if(shareableNotebooks.isNotEmpty)
              Hero(
                tag: heroSelectTag,
                createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PopupHeroDialog(builder: (context) => SelectPopup(
                          onConfirm: (selected) async {
                            final error = await notebookvm.validateNotebooks();
                            error == null ? notebookvm.setSelectedNotebooks(selected) 
                            : _shareToast(error);
                          },
                          notebooks: notebooks,
                          shareableNotebooks: shareableNotebooks,
                          ))
                      );
                    }, 
                    icon: Icon(Icons.add_box_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    )
                  ),
                ),
              ),
            ],
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(height: 260, 
                child: notebooks.isNotEmpty ? ShareSelectionView(
                  notebooks: notebooks,
                  onToggle: notebookvm.toggleNotebookSelection,
                  ): Column(
                    children: [
                      Text("Study together with notebook sharing!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image(
                            image: const AssetImage("assets/img_sharing.png"),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  )),   
              ),

              ShareToPicker(
                onAdd: (email) async => await sharevm.searchUserByEmail(email, notebookvm.selectedNotebooks.length),
                isLoading: sharevm.isLoading,
              ),

              if(users.isNotEmpty)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: users.isNotEmpty ? ShareToUsers(
                  users: users,
                  isEmpty: notebooks.isEmpty,
                  key: const ValueKey("share_to_users"),
                  onRemove: (uid) => sharevm.removeRecipient(uid),
                  onShare: () async {
                    setState(() {
                      sharedUsers = users;
                      sharedNotebooks = notebooks;
                    });
                    await sharevm.shareNotebooks(notebookvm.selectedNotebooks);
                    notebookvm.clearSelection();
                  }
                ) : const SizedBox.shrink(key: ValueKey("empty")),
              ),
            ],
          ),
        ),
     ),
    );
  }
}