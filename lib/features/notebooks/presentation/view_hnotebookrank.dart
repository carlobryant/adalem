import 'package:adalem/core/components/model_mastery.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class NotebookWithRank extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final String course;
  final String image;
  final int mastery;

  const NotebookWithRank({
    super.key,
    required this.image,
    required this.mastery,
    required this.course,
    required this.isLoading,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    final rank = MasteryLevel.fromXp(mastery);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/nb_$image.jpg",
                  width: 70, 
                  height: 70,
                  fit: BoxFit.cover,
                ).redacted(context: context, redact: isLoading),
              ),
              
              Positioned(
                bottom: -4, 
                right: -4,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  padding: const EdgeInsets.all(2), 
                  child: Image.asset(
                    rank.asset,
                    width: 28, 
                    height: 28,
                  ).redacted(context: context, redact: isLoading),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8), 
          
          Text(course,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).redacted(context: context, redact: isLoading),
        ],
      ),
    );
  }
}