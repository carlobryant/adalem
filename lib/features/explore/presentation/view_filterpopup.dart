import 'package:adalem/components/card_popuptween.dart';
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
        child: ClipRect(
          child: Hero(
            tag: heroFilterTag,
            createRectTween: (begin, end) => PopupTween(begin: begin, end: end),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: cardWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text("Sort Notebooks",
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _radioOption(context, "Latest", true),
                            Divider(height: 5, color: Theme.of(context).colorScheme.onSurface),
                            _radioOption(context, "Oldest", false),
                            Divider(height: 5, color: Theme.of(context).colorScheme.onSurface),
                            _radioOption(context, "Alphabetical", false),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () { Navigator.of(context).pop(); },
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: Text("Apply",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontSize: 16,
                                      ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
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