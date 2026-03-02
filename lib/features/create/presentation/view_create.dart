import 'package:adalem/core/components/card_network.dart';
import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/create/presentation/view_creating.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  late final NotebookViewModel _viewModel;

  final List<String> _imageOptions = [
    "red",
    "orange",
    "yellow",
    "green",
    "blue",
    "purple",
    "pink",
    "grey",
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<NotebookViewModel>();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final viewModel = context.read<NotebookViewModel>();
    if(viewModel.createError != null) {
      ToastCard.error(context, viewModel.createError!);
      viewModel.clearCreateError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotebookViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
            "Create",
            style: TextStyle(color: Colors.white),
        )
     ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TITLE
              TextField(
                controller: viewModel.titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // COURSE
              TextField(
                controller: viewModel.courseController,
                decoration: const InputDecoration(
                  labelText: "Course",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              // IMAGE SELECTION
              Text(
                "Cover Image",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageOptions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final option = _imageOptions[index];
                    final isSelected = viewModel.selectedImage == option;
                    return GestureDetector(
                      onTap: () => viewModel.selectImage(option),
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
                            image: AssetImage("assets/nb_$option.jpg"),
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
                label: const Text("Upload Files"),
              ),

              const SizedBox(height: 40),

              // CREATE BUTTON
              SizedBox(
                width: double.infinity,
                child: XLButton(
                  onTap: () => CheckNetwork.execute(
                    signedIn: true,
                    context: context,
                    onTap: () async {
                      if (!viewModel.validateCreate()) return;

                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => const CreatingView()),
                      );
                      viewModel.handleCreate(); 
                    },
                  ),
                  child: Text(
                          "Create",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
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
  }
}