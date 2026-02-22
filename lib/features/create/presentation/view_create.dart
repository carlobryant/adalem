import 'package:adalem/components/button_xl.dart';
import 'package:adalem/components/card_toast.dart';
import 'package:adalem/components/loader_md.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';

class CreateView extends StatefulWidget {
  final NotebookViewModel notebookViewModel;
  const CreateView({super.key, required this.notebookViewModel});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  //late final CreateViewModel _viewModel;

  // correlates to assets/nb_<value>.jpg
  final List<String> _imageOptions = [
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
    'purple',
    'pink',
    'grey',
  ];

  @override
  void initState() {
    super.initState();
    widget.notebookViewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.notebookViewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (widget.notebookViewModel.isSuccess) {
      ToastCard.success(context, 'Notebook created!');
      widget.notebookViewModel.resetCreate();
    } else if (widget.notebookViewModel.errorMessage != null) {
      ToastCard.error(context, widget.notebookViewModel.errorMessage!);
      widget.notebookViewModel.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notebookViewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              'Create Notebook',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: widget.notebookViewModel.isLoading ? 
          const MediumLoader() : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE
                  TextField(
                    controller: widget.notebookViewModel.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // COURSE
                  TextField(
                    controller: widget.notebookViewModel.courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // IMAGE SELECTION
                  Text(
                    'Cover Image',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final option = _imageOptions[index];
                        final isSelected = widget.notebookViewModel.selectedImage == option;
                        return GestureDetector(
                          onTap: () => widget.notebookViewModel.selectImage(option),
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image: AssetImage('assets/nb_$option.jpg'),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  // UPLOAD FILES
                  OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Files'),
                  ),

                  const SizedBox(height: 40),

                  // CREATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: XLButton(
                      onTap: widget.notebookViewModel.isLoading ? null : widget.notebookViewModel.handleCreate,
                      child: Text(
                              "Create",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}