import 'dart:math';

import 'package:adalem/features/home/presentation/model_infocard.dart';
import 'package:adalem/features/home/presentation/view_infocard.dart';
import 'package:adalem/features/notebook_content/presentation/view_content.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/notebooks/presentation/view_hnotebookcard.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListView extends StatelessWidget {
  final List<NotebookModel> notebooks;
  final bool isLoading;
  final String uid;

  const HomeListView({
    super.key,
    required this.notebooks,
    required this.isLoading,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final items = InfoCardModel.all;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
          child: Text(notebooks.isEmpty ?
            "No Tasks for Today" : "Up Next for You",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        
        notebooks.isEmpty ? 
        ListView.separated(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: items.length,

          separatorBuilder: (context, index) => const SizedBox(height: 16),

          itemBuilder: (context, index) {
            final item = items[index];
            return InfoCardView(
              title: item.title,
              details: item.details,
              description: item.description,
              image: item.image,
              isLoading: isLoading,
            );
          },
        )
        : ListView.separated(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: notebooks.length,
          
          separatorBuilder: (context, index) => const SizedBox(height: 16), 
          
          itemBuilder: (context, index) {
            var random = Random();
            final notebook = notebooks[index];
            final userModel = notebook.users[uid];

            final bool flashcardAvailable = context.read<NotebookViewModel>()
              .flashcardAvailable(notebook.id);
            final List<List<String>> task = [
              ["Review flashcards for", "Flashcards available on", "Spaced-repetition flashcards"],
              ["Try out the quiz on", "Quiz yourself for", "Take adaptive quiz"],
            ];

            final flashcardDate = userModel?.flashcardSession;
            final quizDate = userModel?.quizSession;
            
            DateTime latestAccess;
            if (flashcardDate != null && quizDate != null) {
              latestAccess = flashcardDate.isAfter(quizDate) ? flashcardDate : quizDate;
            } else {
              latestAccess = flashcardDate ?? quizDate ?? DateTime.now();
            }
            
            return GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => ContentView(
                    notebookId: notebook.id,
                    notebookTitle: notebook.title,
                    notebookCourse: notebook.course,
                    image: notebook.image,
                    toFlashcard: flashcardAvailable,
                    toQuiz: !flashcardAvailable,
                  ),
                ),
              ),
              child: HorizontalNotebookCard(
                title: "${task[flashcardAvailable ? 0 : 1][random.nextInt(2)]} ${notebook.title}",
                course: notebook.course,
                image: notebook.image,
                isLoading: isLoading,
                streak: userModel?.streak ?? 0,
                lastAccess: latestAccess,
              ),
            );
          },
        ),
      ],
    );
  }
}