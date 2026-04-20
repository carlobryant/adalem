import 'package:adalem/core/components/button_sm.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String heroSelectTag = "select-popup";

class SelectPopup extends StatefulWidget {
  final ValueChanged<List<NotebookModel>> onConfirm; 
  final List<NotebookModel> shareableNotebooks;
  final List<NotebookModel> notebooks;
  
  const SelectPopup({
    super.key,
    required this.onConfirm,
    required this.notebooks,
    required this.shareableNotebooks,
    });

  @override
  State<SelectPopup> createState() => _SelectPopupState();
}

class _SelectPopupState extends State<SelectPopup> {
  final TextEditingController _searchController = TextEditingController();
  late List<NotebookModel> _tempNotebooks;

  @override
  void initState() {
    super.initState();
    _tempNotebooks = List.from(widget.notebooks); 
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 64;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: heroSelectTag,
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
                        child: Text("Add Notebooks to Share",
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
                            height: 300,
                            child: widget.shareableNotebooks.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage("assets/ic_notfound.png"),
                                        width: 180,
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 16),
                                      Text("No Notebooks Found!",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(top: 12),
                                  itemCount: widget.shareableNotebooks.length,
                                  separatorBuilder: (_, _) => Divider(
                                    height: 5, 
                                    color: Theme.of(context).colorScheme.onSurface
                                  ),
                                  itemBuilder: (context, index) {
                                    final notebook = widget.shareableNotebooks[index];
                                    return _buildItem(notebook);
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

                              if(widget.shareableNotebooks.isNotEmpty && !listEquals(widget.notebooks, _tempNotebooks))
                              const SizedBox(width: 12),
                              
                              if(widget.shareableNotebooks.isNotEmpty && !listEquals(widget.notebooks, _tempNotebooks))
                              SmallButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onConfirm(_tempNotebooks);
                                },
                                child: Text("Confirm",
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

  Widget _buildItem(NotebookModel notebook) {
    bool isSelected = _tempNotebooks.contains(notebook);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => isSelected ?
        _tempNotebooks.remove(notebook) : _tempNotebooks.add(notebook)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            isSelected ?
            Icon(Icons.check_box_rounded,
              color: Theme.of(context).colorScheme.primary,
            ) 
            : Icon(Icons.check_box_outline_blank_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(notebook.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              ),
            ),
            const SizedBox(width: 6),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(5),
              child: Image(
                image: AssetImage("assets/nb_${notebook.image}.jpg"),
                fit: BoxFit.cover,
                alignment: AlignmentGeometry.center,
                width: 22,
                height: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}