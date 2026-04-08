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
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final difference = today.difference(targetDate).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference >= 2 && difference < 7) {
      return "$difference Days Ago";
    } else {
      return "A Week Ago"; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color streakColor = Theme.of(context).colorScheme.tertiary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
      elevation: 5,
      child: SizedBox(
        height: 120, 
        child: Row( 
          children: [

            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: isLoading
                  ? Container(
                      width: 70,
                      height: double.infinity,
                      color: Colors.grey.shade300,
                    ).redacted(context: context, redact: true)
                  : Image(
                      image: AssetImage("assets/nb_$image.jpg"),
                      width: 70,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      colorBlendMode: BlendMode.saturation,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 70,
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
            
            // TEXT DETAILS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    
                    // TASK AND TITLE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoading 
                          ? Container(width: 140, height: 20, color: Colors.grey).redacted(context: context, redact: true)
                          : Text(
                              title, 
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.inverseSurface,
                              ),
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis,
                            ),
                        if(!isLoading)
                        Text(course,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100, 
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),

                    // COURSE AND LAST ACCESS
                    isLoading 
                      ? Container(width: 140, height: 12, color: Colors.grey).redacted(context: context, redact: true)
                      : Row(
                        children: [
                          if(streak < 1) Spacer(),
                          Text( _formatDate(lastAccess),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      if(!isLoading && streak > 0) Spacer(),
                      // STREAK ROW
                      if(!isLoading && streak > 0)
                      Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded, 
                                size: 18, 
                                color: streak > 1 ? streakColor : Theme.of(context).colorScheme.onSurface, 
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$streak ${streak == 1 ? 'Day' : 'Days'} Streak".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "LoveYaLikeASister",
                                  fontWeight: FontWeight.bold,
                                  color: streak > 1 ? streakColor : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}