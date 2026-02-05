import 'package:flutter/material.dart';

class NotebookCard extends StatelessWidget {
  final String title;
  final String course;
  final String imageUrl;

  const NotebookCard({
    super.key,
    required this.title,
    required this.course,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      shadowColor: Theme.of(context).colorScheme.inverseSurface,
      elevation: 5,
      

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  course,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                    )
                ),

              ],
              
            ),
          ),
        ],

      ),

    );
  }
}