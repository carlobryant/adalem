import 'package:adalem/features/notebook_content/presentation/model_content.dart';
import 'package:flutter/material.dart';

class ContentDrawer extends StatelessWidget {
  final List<ChapterModel> chapters;
  final Function(GlobalKey) onChapterTap;
  final VoidCallback onBack;

  const ContentDrawer({
    super.key,
    required this.chapters,
    required this.onChapterTap,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // HEADER SECTION
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pop(); 
                      // Navigator.of(context).pop(); 
                      onBack();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Chapters",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),

            // LIST CHAPTER
            Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapterModel = chapters[index];
                  final chapter = chapterModel.chapter;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                    title: Text(
                      "${index + 1}. ${chapter.header}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20), 
                    
                    onTap: () {
                      Navigator.of(context).pop(); 
                      onChapterTap(chapterModel.scrollKey); 
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}