import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/core/components/model_error.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';
import 'package:adalem/features/notebooks/domain/uc_sharenotebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/share/presentation/view_selectpopup.dart';
import 'package:adalem/features/share/presentation/view_shareselect.dart';
import 'package:adalem/features/share/presentation/view_sharetopicker.dart';
import 'package:adalem/features/share/presentation/vm_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareView extends StatelessWidget {
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShareViewModel(
        getCurrentUser: GetCurrentUser(context.read<AuthRepo>()),
        getUserProfile: context.read<GetUserProfile>(),
        shareNotebooks: ShareNotebooks(context.read<NotebookRepo>()),
      ),
      child: const _ShareViewContent(),
    );
  }
}


class _ShareViewContent extends StatefulWidget {
  const _ShareViewContent();

  @override
  State<_ShareViewContent> createState() => _ShareViewContentState();
}

class _ShareViewContentState extends State<_ShareViewContent> {

  void _onViewModelChanged(ErrorModel error) {
    ToastCard.clearError();
    ToastCard.error(context, error.header, description: error.description);
  }

  @override
  Widget build(BuildContext context) {
    final sharevm = context.watch<ShareViewModel>();

    final notebookvm = context.watch<NotebookViewModel>();
    final shareableNotebooks = notebookvm.shareableNotebooks;
    final notebooks = notebookvm.selectedNotebooks;

    final error = sharevm.error;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _onViewModelChanged(error);
          context.read<ShareViewModel>().clearError();
        }
      });
    }

    return Scaffold(
     body: NestedScrollView(
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
                          onConfirm: (selected) {
                            notebookvm.setSelectedNotebooks(selected);
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

              ShareToPicker(onAdd: (email) {
                sharevm.searchUserByEmail(email);
              },
              isLoading: sharevm.isLoading,
              ),
            ],
          ),
        ),
     ),
    );
  }
}