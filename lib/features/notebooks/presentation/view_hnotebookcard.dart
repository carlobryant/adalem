import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class HorizontalNotebookCard extends StatelessWidget {
  final String title;
  final String course;
  final String image;
  final bool isLoading;
  final int streak;
  final DateTime lastAccess;

  const HorizontalNotebookCard({
    super.key,
    required this.title,
    required this.course,
    required this.image,
    required this.isLoading,
    required this.streak,
    required this.lastAccess,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
      elevation: 5,
      child: SizedBox(
        height: 130, 
        child: Row( 
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    
                    // TASK NAME
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoading 
                          ? Container(width: 140, height: 24, color: Colors.grey).redacted(context: context, redact: true)
                          : Text(
                              "Review Flashcards", 
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.inverseSurface,
                              ),
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                            ),
                        const SizedBox(height: 4),
                        isLoading
                          ? Container(width: 100, height: 16, color: Colors.grey).redacted(context: context, redact: true)
                          : Text(
                              title, 
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ],
                    ),

                    // COURSE AND LAST ACCESS
                    isLoading 
                      ? Container(width: 140, height: 14, color: Colors.grey).redacted(context: context, redact: true)
                      : Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "$course  •  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: _formatDate(lastAccess),
                                style: TextStyle(
                                  fontStyle: FontStyle.italic, 
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                  ],
                ),
              ),
            ),

            // IMAGE
            SizedBox(
              width: 110,
              height: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(15)),
                    child: isLoading
                        ? Container(color: Colors.grey.shade300).redacted(context: context, redact: true)
                        : Image(
                            image: AssetImage("assets/nb_$image.jpg"),
                            fit: BoxFit.cover,
                            color: Colors.black.withValues(alpha: 0.35),
                            colorBlendMode: BlendMode.darken,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade400,
                                child: Center(
                                  child: Image(
                                    image: const AssetImage("assets/ic_error.png"),
                                    color: Colors.grey.shade700,
                                    width: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  if (!isLoading)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: const Icon(
                                  Icons.local_fire_department_rounded, 
                                  size: 45, 
                                  color: Colors.deepOrange, 
                                  shadows: [
                                      Shadow(offset: Offset(0, 1), blurRadius: 4.0, color: Colors.black54),
                                    ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  "$streak",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "LoveYaLikeASister",
                                    fontSize: 40, 
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          
                          Text(
                            streak != 1 ? "days streak".toUpperCase() : "day streak".toUpperCase(),
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w900,
                              fontFamily: "LoveYaLikeASister",
                              color: Theme.of(context).colorScheme.onPrimary,
                              shadows: [
                                Shadow(offset: Offset(0, 1), blurRadius: 4.0, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}