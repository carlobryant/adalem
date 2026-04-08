import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class InfoCardView extends StatelessWidget {
  final String title;
  final String details;
  final String description;
  final String image;
  final bool isLoading;
  final bool keepImage;
  const InfoCardView({
    super.key,
    required this.title,
    required this.details,
    required this.description,
    required this.image,
    required this.isLoading,
    this.keepImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    return Container(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
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
      child: SizedBox(
        height: 130, 
        child: Row( 
          children: [

            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: isLoading
                  ? Container(
                      width: 80,
                      height: double.infinity,
                      color: Colors.grey.shade300,
                    ).redacted(context: context, redact: true)
                  : Image(
                      image: AssetImage("assets/$image.png"),
                      width: 80,
                      height: double.infinity,
                      fit: keepImage ? BoxFit.cover : BoxFit.fitWidth,
                      color: keepImage ? null : Theme.of(context).colorScheme.primary,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
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
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    
                    // TITLE AND DETAILS
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
                        Text(details,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w100, 
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),

                        Text(description,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ).redacted(context: context, redact: isLoading),
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