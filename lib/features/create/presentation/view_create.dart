import 'package:adalem/core/components/card_network.dart';
import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/create/presentation/view_creating.dart';
import 'package:adalem/features/create/presentation/view_imagepopup.dart';
import 'package:adalem/features/create/presentation/vm_create.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
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
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 60,
        title: const Text(
            "Create",
            style: TextStyle(color: Colors.white),
        ),
        actions: [
          // IMAGE SELECTION
              Hero(
                tag: heroImageTag,
                createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PopupHeroDialog(builder: (context) => ImagePopup(
                          selected: viewModel.selectedImage,
                          onConfirm: (option) => viewModel.selectImage(option),
                          imageOptions: _imageOptions,
                        ))
                      );
                    }, 
                    icon: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: AssetImage("assets/nb_${viewModel.selectedImage}.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.edit, 
                            color: Theme.of(context).colorScheme.onPrimary
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
        ],
     ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // TITLE
              TextField(
                maxLength: 60,
                controller: viewModel.titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // COURSE
              TextField(
                maxLength: 15,
                controller: viewModel.courseController,
                decoration: const InputDecoration(
                  labelText: "Course",
                  border: OutlineInputBorder(),
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
              XLButton(
                onTap: () => CheckNetwork.execute(
                  signedIn: true,
                  context: context,
                  onTap: () async {
                    ToastCard.clearError();
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => const CreatingView()),
                    );

                    viewModel.handleCreate(context.read<NotebookViewModel>().notebookCount); 
                  },
                ),
                child: Text("Create",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Powered with ",
                    style: TextStyle(fontSize: 12),
                  ),
                  Flexible(
                    child: SvgPicture.asset("assets/gemini.svg",
                    colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.inverseSurface,
                          BlendMode.srcIn,
                        ),
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}