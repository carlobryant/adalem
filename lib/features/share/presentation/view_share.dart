import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/share/presentation/view_selectpopup.dart';
import 'package:adalem/features/share/presentation/view_shareselect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareView extends StatefulWidget {
  const ShareView({super.key});

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  @override
  Widget build(BuildContext context) {
    final notebookvm = context.watch<NotebookViewModel>();
    final shareableNotebooks = notebookvm.shareableNotebooks;
    final notebooks = notebookvm.selectedNotebooks;
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
              if(notebooks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(height: 280, 
                child: ShareSelectionView(
                  notebooks: notebooks,
                  onToggle: notebookvm.toggleNotebookSelection,
                )),
              ),
              const Placeholder(),
            ],
          ),
        ),
     ),
    );
  }
}