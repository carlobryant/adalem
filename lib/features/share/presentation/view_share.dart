import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
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
    final notebooks = notebookvm.selectedNotebooks;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 60,
        title: Text( notebooks.isEmpty ? "Select Notebook Share"
        : notebooks.length > 1 ? "${notebooks.length} Notebooks Selected" : notebooks[0].title,
            style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   // IMAGE SELECTION
        //       Hero(
        //         tag: heroImageTag,
        //         createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
        //         child: Material(
        //           color: Colors.transparent,
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //           child: IconButton(
        //             onPressed: () {
        //               Navigator.of(context).push(
        //                 PopupHeroDialog(builder: (context) => ImagePopup(
        //                   selected: viewModel.selectedImage,
        //                   onConfirm: (option) => viewModel.selectImage(option),
        //                   imageOptions: _imageOptions,
        //                 ))
        //               );
        //             }, 
        //             icon: Stack(
        //               children: [
        //                 Container(
        //                   width: 40,
        //                   height: 40,
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(10),
        //                     border: Border.all(
        //                       color: Theme.of(context).colorScheme.primaryContainer,
        //                       width: 3,
        //                     ),
        //                   ),
        //                   child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(8),
        //                     child: Image(
        //                       image: AssetImage("assets/nb_${viewModel.selectedImage}.jpg"),
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                 ),

        //                 Positioned(
        //                   left: 0,
        //                   bottom: 0,
        //                   child: Container(
        //                     width: 20,
        //                     height: 20,
        //                     decoration: BoxDecoration(
        //                       color: Theme.of(context).colorScheme.primaryContainer,
        //                       borderRadius: BorderRadius.circular(20),
        //                     ),
        //                     child: Icon(Icons.color_lens_rounded, size: 14,
        //                     color: Theme.of(context).colorScheme.onPrimary
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //],
     ),
     body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(height: 280,
              child: ShareSelectionView(notebooks: notebooks)),
          ),
          const Placeholder(),
        ],
      )
      ),
    );
  }
}