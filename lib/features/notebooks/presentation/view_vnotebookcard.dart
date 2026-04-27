import 'package:adalem/core/components/animation_loader.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class VerticalNotebookCard extends StatelessWidget {
  final String title;
  final String course;
  final String updatedAt;
  final String image;
  final String available;
  final bool isLoading;
  final bool isSolid;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const VerticalNotebookCard({
    super.key,
    required this.title,
    required this.course,
    required this.updatedAt,
    required this.image,
    required this.available,
    required this.isLoading,
    this.isSolid = false,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = !isSolid ? 
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
      : Theme.of(context).colorScheme.surface;
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    final displayDate = updatedAt.split('-').first;

    return Container(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // shadowColor: Theme.of(context).colorScheme.shadow,
      // elevation: 5,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.fromLTRB(
            bottom: BorderSide(width: 5, color: borderColor),
            right: BorderSide(width: 3, color: borderColor),
            top: BorderSide.none,
            left: BorderSide.none,
          ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: isLoading ?
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade300,
            ).redacted(context: context, redact: true)
            : Stack(
              children: [
                Image(
                  image: AssetImage("assets/nb_$image.jpg"),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  color: available != "ready" ? Colors.black54 : null,
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey.shade400,
                      child: Center(
                        child: Image(
                          image: AssetImage("assets/ic_error.png"),
                          color: Colors.grey.shade700,
                          width: 50,
                          )
                        ),
                    );
                  },
                ),

                if(available != "ready")
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      available == "generating" ? LoaderAnimation(onBlack: true)
                      : Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Icon(Icons.error_outline_rounded, 
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 60,
                        ),
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          ),

          SizedBox(
            height: 75,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 4),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: isLoading ?
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ).redacted(context: context, redact: true)
                              : Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: 10, height: 30),
                        ],

                      ),

                      if (!isLoading && (onDelete != null || onShare != null))
                          Positioned(
                            right: 0,
                            child: SizedBox(
                              width: 30,
                              child: PopupMenuButton<String>(
                                icon: Padding(
                                  padding: EdgeInsetsGeometry.only(left: 10),
                                  child: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.inverseSurface),
                                ), 
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                menuPadding: EdgeInsets.zero,
                                borderRadius: BorderRadius.circular(40),
                                color: Theme.of(context).colorScheme.surface,
                                onSelected: (value) {
                                  if (value == "share") {
                                    onShare!();
                                  } else if (value == "delete") {
                                    onDelete!();
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  if (onShare != null && available == "ready")
                                  PopupMenuItem(
                                    value: "share",
                                    child: ListTile(
                                      leading: Icon(Icons.outbond_outlined,
                                        color: Theme.of(context).colorScheme.inverseSurface,
                                      ),
                                      title: Text("Share",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inverseSurface,
                                        fontWeight: FontWeight.w900
                                      ))
                                    ),
                                  ),
                                  if (onDelete != null)
                                  PopupMenuItem(
                                    value: "delete",
                                    child: ListTile(
                                      leading: Icon(Icons.highlight_remove_rounded,
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                      title: Text("Delete",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w900
                                      ))
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
            
                  Spacer(),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: isLoading ?
                        const SizedBox()
                        : Text(
                          available == "generating" ? "Generating..." 
                          : available != "ready" ? "Error" : displayDate,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
            
                      Flexible(
                        child: isLoading ?
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ).redacted(context: context, redact: true)
                        : Text(
                          course,
                          style: TextStyle(
                              fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
            
                ],
                
              ),
            ),
          ),
        ],

      ),

    );
  }
}