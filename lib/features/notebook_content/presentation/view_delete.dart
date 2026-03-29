import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/notebook_content/presentation/vm_delete.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteNotebookView extends StatefulWidget {
  final String notebookId;
  final String contentId;
  final String ownerName;
  final String ownerImage;
  final String title;
  final String course;
  final String image;

  const DeleteNotebookView({
    super.key,
    required this.notebookId,
    required this.contentId,
    required this.ownerName,
    required this.ownerImage,
    required this.title,
    required this.course,
    required this.image,
    });

  @override
  State<DeleteNotebookView> createState() => _DeleteNotebookViewState();
}

class _DeleteNotebookViewState extends State<DeleteNotebookView> {
  late final DeleteViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DeleteViewModel>();
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
    if (_viewModel.isDeleting) return;
    if (_viewModel.deleteError != null) {
      ToastCard.error(context, _viewModel.deleteError![0], description: _viewModel.deleteError![1]);
      _viewModel.clearDeleteError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeleteViewModel>();
    final currentUser = context.read<ProfileViewModel>().user!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Delete")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              "Permanently delete ${widget.title}?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                "assets/nb_${widget.image}.jpg",
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text("Course code: ${widget.course}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Original owner: ", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(width: 5),
                CircleAvatar(
                  radius: 12,
                  foregroundImage: widget.ownerImage.isNotEmpty ? 
                  CachedNetworkImageProvider(widget.ownerImage) : null,
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  child: Image(
                    image: AssetImage("assets/ic_error.png"),
                    color: Theme.of(context).colorScheme.surface,
                    width: 18,
                    ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.ownerName.isNotEmpty ? widget.ownerName : "Unknown User",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold
                    ),
                ),
              ],
            ),
            
            const Spacer(flex: 2),
            
            XLButton(
              onTap: viewModel.isDeleting ?
              null : () {
                  viewModel.confirmDelete(
                  notebookId: widget.notebookId,
                  contentId: widget.contentId,
                  userId: currentUser,
                  context: context,
                  );
                
                ToastCard.success(context, "Notebook Deleted");
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text("Delete ${widget.title}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}