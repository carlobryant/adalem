import 'dart:io';

import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/core/app_theme.dart';
import 'package:adalem/core/components/button_sm.dart';
import 'package:adalem/core/components/card_network.dart';
import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/card_popuptween.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/create/presentation/view_creating.dart';
import 'package:adalem/features/create/presentation/view_imagepopup.dart';
import 'package:adalem/features/create/presentation/vm_create.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  List<PlatformFile> _files = [];
  bool _fileUploaded = false;
  bool _isUploading = false;
  int _sizeUploaded = 0;

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

  Future<void> listFiles(List<PlatformFile> files) async {
    ToastCard.clearError();
    final combined = [..._files, ...files];

    bool isCorrupted = false;
    final seen = <String>{};
    final selected = <PlatformFile>[];
    final sizeRejected = <PlatformFile>[];
    final pageRejected = <PlatformFile>[];
    
    int runningTotalSize = 0; 
    final maxSizeBytes = Constraint.maxUploadMB * 1024 * 1024;

    setState(() => _isUploading = true);

    for (final f in combined) {
      if (!seen.add(f.name)) continue;
      if (runningTotalSize + f.size > maxSizeBytes) {
        sizeRejected.add(f);
        continue;
      }
      
      if (f.extension?.toLowerCase() == 'pdf') {
        try {
          final bytes = f.bytes ?? await File(f.path!).readAsBytes();
          
          final stream = ByteStream(bytes);
          final parser = PDFParser(stream);
          final document = await parser.parse();
          final catalog = await document.catalog;
          final pages = await catalog.getPages();

          if (pages.pageCount > Constraint.maxPdfPage) {
            pageRejected.add(f);
            continue; 
          }
        } catch (e) {
          isCorrupted = true;
          continue;
        }
      }
      selected.add(f);
      runningTotalSize += f.size;
    }

    setState(() {
      _files = selected;
      _fileUploaded = selected.isNotEmpty;
      _sizeUploaded = runningTotalSize; 
      
      _isUploading = false;
    });
    if(!mounted) return;
    if (isCorrupted) {
      ToastCard.error(context, "Uploaded File Access Denied",
        description: "Removed corrupted or password-protected files."
      );
    }
    else if (sizeRejected.isNotEmpty) {
      ToastCard.error(context, "${Constraint.maxUploadMB} MB Limit Exceeded",
        description: sizeRejected.length > 1 
          ? "${sizeRejected.length} files were removed."
          : "Please make sure the files don't exceed the limit."
      );
    } else if (pageRejected.isNotEmpty) {
      ToastCard.error(context, "Page Limit Exceeded",
        description: pageRejected.length > 1 
          ? "${pageRejected.length} PDFs exceeded the limit."
          : "Please upload PDFs with ${Constraint.maxPdfPage} pages or less."
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateViewModel>();
    final theme = NotebookTheme.values.firstWhere(
      (t) => t.name == viewModel.selectedImage,
      orElse: () => NotebookTheme.yellow,
    );
    Color primary = theme.primary;
    Color secondary = theme.secondary;
    Color darkPrimary = Recolor.darken(primary);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 60,
        title: Text(
            viewModel.titleController.text != "" ? viewModel.titleController.text : "Untitled Notebook",
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
                              color: Theme.of(context).colorScheme.primaryContainer,
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
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.color_lens_rounded, size: 14,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Container(
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(20),
                  border: BoxBorder.fromLTRB(
                      bottom: BorderSide(width: 5, color: darkPrimary),
                      right: BorderSide(width: 3, color: darkPrimary),
                    ),
                  ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    children: [

                      // TITLE
                      TextField(
                        maxLength: 60,
                        cursorColor: darkPrimary,
                        controller: viewModel.titleController,
                        style: TextStyle(color: darkPrimary),
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(color: darkPrimary),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: darkPrimary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder( 
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: secondary,
                              width: 2,
                            ),
                          ),
                          counterText: "",
                        ),
                      ),
                    
                      const SizedBox(height: 15),
                    
                      // COURSE
                      TextField(
                        maxLength: 15,
                        cursorColor: darkPrimary,
                        controller: viewModel.courseController,
                        style: TextStyle(color: darkPrimary),
                        decoration: InputDecoration(
                          labelText: "Course",
                          labelStyle: TextStyle(color: darkPrimary),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: darkPrimary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: secondary,
                              width: 2,
                            ),
                          ),
                          counterText: "",
                        ),
                      ),
          
                      const SizedBox(height: 18),
                      Text("Ensure uploaded files are clear and legible.",
                        style: TextStyle(color: darkPrimary, fontStyle: FontStyle.italic, fontSize: 10),
                      ),
                      const SizedBox(height: 8),
                          
                      // FILE UPLOAD LIST
                      _fileUploaded ?
                      DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                            color: darkPrimary,
                            dashPattern: [10, 10],
                            strokeWidth: 2,
                            radius: Radius.circular(20),
                            
                          ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            children: [
                              ..._files.map((f) => _fileItem(f, darkPrimary, primary)),
                              Row(
                                children: [
                                  IconButton(onPressed: () {}, 
                                  icon: Icon(Icons.build_circle_rounded, color: darkPrimary.withValues(alpha: 0.4), size: 40),
                                  ),
                                  Spacer(),
                                  SmallButton(
                                    onBack: () async {
                                      final result = await FilePicker.platform.pickFiles(
                                        allowMultiple: true,
                                        type: FileType.custom,
                                        allowedExtensions: Constraint.allowedExts,
                                      );
                                      if (result == null) return;
                                      listFiles([..._files, ...result.files]);
                                    },
                                    surfacecolor: primary,
                                    child: Center(child: Icon(Icons.add)),
                                  ),
                                ],
                              ),
                              Text("Total Upload Size: ${_sizeUploaded < 1024 * 1024 ? 
                                  "${(_sizeUploaded / 1024).toStringAsFixed(1)} KB" 
                                  : "${(_sizeUploaded / (1024 * 1024)).toStringAsFixed(1)} MB"}",
                                style: TextStyle(color: darkPrimary, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      )
                      // UPLOAD FILES
                      : _isUploading ?
                      DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: darkPrimary,
                          dashPattern: [10, 10],
                          strokeWidth: 2,
                          radius: Radius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width/3, 
                            vertical: MediaQuery.sizeOf(context).height/6,
                          ),
                          child: CircularProgressIndicator(color: darkPrimary),
                        ),
                      )
                      : GestureDetector(
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: Constraint.allowedExts,
                            );
                          if (result==null) return;
                          listFiles(result.files);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            color: darkPrimary,
                            dashPattern: [10, 10],
                            strokeWidth: 2,
                            radius: Radius.circular(20),
                            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                            child: Column(
                              children: [
                                Icon(Icons.upload, size: 30, color: darkPrimary),
                                Text("Upload Files", style: TextStyle(color: darkPrimary)),
                              ],
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(_fileUploaded)
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(Constraint.noticeAI,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                    final notebookvm = context.read<NotebookViewModel>();
                    viewModel.handleCreate(
                      notebookvm.notebookCount, 
                      notebookvm.isNotebookCreating(), 
                      context.read<ProfileViewModel>().isLimitReached(),
                      _files
                    ); 
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

  Widget _fileItem(PlatformFile file, Color darkPrimary, Color primary) {
  final sizeLabel = file.size < 1024 * 1024
      ? "${(file.size / 1024).toStringAsFixed(1)} KB"
      : "${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB";

  IconData fileIcon = Icons.library_books;

  switch(file.extension) {
    case 'pdf': fileIcon = Icons.picture_as_pdf_rounded; break;
    case 'png' || 'jpg' || 'jpeg': fileIcon = Icons.filter; break;
    case 'pptx': fileIcon = Icons.photo_library_rounded; break;
    case 'mp4': fileIcon = Icons.video_library; break;
    case 'mp3': fileIcon = Icons.library_music; break;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: darkPrimary.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(18),
      border: Border(),
    ),
    child: Row(
      children: [
        Icon(fileIcon, color: darkPrimary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.name,
                style: TextStyle(color: darkPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                sizeLabel,
                style: TextStyle(color: darkPrimary, fontSize: 11),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: darkPrimary, size: 18),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            setState(() {
              _files.remove(file);
              _fileUploaded = _files.isNotEmpty;
            });
          },
        ),
      ],
    ),
  );
}
}