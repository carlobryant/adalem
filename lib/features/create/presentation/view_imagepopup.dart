import 'package:adalem/core/components/button_sm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String heroImageTag = "image-popup";

class ImagePopup extends StatefulWidget {
  final String selected;
  final Function(String) onConfirm; 
  final List<String> imageOptions;

  const ImagePopup({
    super.key,
    required this.selected,
    required this.onConfirm,
    required this.imageOptions,
    });

  @override
  State<ImagePopup> createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 64;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: heroImageTag,
          child: Material(
            shadowColor: Colors.transparent,
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: OverflowBox(
                minWidth: cardWidth,
                maxWidth: cardWidth,
                fit: OverflowBoxFit.deferToChild,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text("Select Notebook Theme",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                              ),
                              itemCount: widget.imageOptions.length,
                              itemBuilder: (context, index) {
                                final option = widget.imageOptions[index];
                                final isSelected = widget.selected == option;
                                return GestureDetector(
                                  onTap: () {
                                    widget.onConfirm(option);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? 
                                        Theme.of(context).colorScheme.inversePrimary : Colors.transparent,
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
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SmallButton(
                                onBack: () => Navigator.of(context).pop(),
                                child: Text("Cancel",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
      ),
    );
  }
}