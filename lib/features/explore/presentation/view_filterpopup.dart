import 'package:flutter/material.dart';

const String heroFilterTag = "filter-popup";

class FilterPopup extends StatelessWidget {
  const FilterPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 64;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Hero(
            tag: heroFilterTag,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: cardWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text("Sort Notebooks",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _radioOption(context, "Latest", true),
                        _radioOption(context, "Oldest", false),
                        _radioOption(context, "Alphabetical", false),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {Navigator.of(context).pop();},
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
                              )),
                            child: Text("Apply",
                                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
        ),
      ),
    );
  }

  Widget _radioOption(BuildContext context, String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(isSelected ?
            Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ?
            Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
              style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}