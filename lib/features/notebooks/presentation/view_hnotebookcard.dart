import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class HorizontalNotebookCard extends StatelessWidget {
  final String title;
  final String course;
  final String image;
  final String assessment;
  final bool isLoading;
  final String? description;


  const HorizontalNotebookCard({
    super.key,
    required this.title,
    required this.course,
    required this.image,
    required this.assessment,
    required this.isLoading,
    this.description,
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
            : Image(
              image: AssetImage("assets/nb_$image.jpg"),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
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
          ),
        ],
      )
    );
  }
}