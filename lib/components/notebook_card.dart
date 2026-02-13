import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class NotebookCard extends StatelessWidget {
  final String title;
  final String course;
  final String imageUrl;
  final bool isLoading;

  const NotebookCard({
    super.key,
    required this.title,
    required this.course,
    required this.imageUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 5,
      

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
            : Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: Center(child: Icon(Icons.error)),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [ 
                isLoading ?
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
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    isLoading ?
                    const SizedBox()
                    : Text(
                      course,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Spacer(),

                    isLoading ?
                    Expanded(
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ).redacted(context: context, redact: true),
                    )
                    : Text(
                      course,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

              ],
              
            ),
          ),
        ],

      ),

    );
  }
}