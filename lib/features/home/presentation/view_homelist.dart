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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            "Up Next for You",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        
        notebooks.isEmpty
            ? Padding( 
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    "You're all caught up!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(), 
                
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: notebooks.length,
                
                separatorBuilder: (context, index) => const SizedBox(height: 16), 
                
                itemBuilder: (context, index) {
                  final notebook = notebooks[index];
                  final userModel = notebook.users[uid];
                  final bool flashcardAvailable = context.read<NotebookViewModel>()
                    .flashcardAvailable(notebook.id);
                  
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
                      title: notebook.title,
                      course: notebook.course,
                      image: notebook.image,
                      isLoading: isLoading,
                      streak: userModel?.streak ?? 0,
                      lastAccess: userModel?.flashcardSession ?? DateTime.now(),
                    ),
                  );
                },
              ),
      ],
    );
  }
}