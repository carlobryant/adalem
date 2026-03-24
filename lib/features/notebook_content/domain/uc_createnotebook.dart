import 'dart:async';

import 'package:adalem/features/create/domain/ai_repo.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';

// class CreateNotebook {
//   final ContentRepo _contentRepo;
//   final AIRepo _aiRepo;

//   CreateNotebook({
//     required ContentRepo contentRepo,
//     required AIRepo aiRepo,
//     }) : _contentRepo = contentRepo, _aiRepo = aiRepo;

//   Future<void> call(CreateNotebookParams params) async {
//     //final content = await _contentRepo.parseContent();
//     final ids = _contentRepo.generateIds();

//     NotebookContent content = await _aiRepo.generateStudyMaterial(
//       params.filetype,
//       params.title,
//       params.description,
//     );
//     content = content.copyWith(id: ids.contentId);
    
    
//     await _contentRepo.createNotebook(
//       params: params,
//       content: content,
//       notebookId: ids.notebookId,
//       contentId: ids.contentId,
//     );
//   }
// }

class CreateNotebook {
  final ContentRepo _contentRepo;
  final AIRepo _aiRepo;

  CreateNotebook({
    required ContentRepo contentRepo,
    required AIRepo aiRepo,
  }) : _contentRepo = contentRepo, _aiRepo = aiRepo;

  Future<void> call(CreateNotebookParams params) async {
    final ids = _contentRepo.generateIds();

    await _contentRepo.createNotebook(
      params: params,
      notebookId: ids.notebookId,
      contentId: ids.contentId,
    );

    unawaited(
      _generateAndSaveBackground(
        topic: params.title, 
        notebookId: ids.notebookId, 
        contentId: ids.contentId,
      )
    );
    return;
  }

  Future<void> _generateAndSaveBackground({
    required String topic,
    required String notebookId,
    required String contentId,
  }) async {
    try {
      NotebookContent content = await _aiRepo.generateStudyMaterial(
        [], topic, null
      );
      
      content = content.copyWith(id: contentId, notebookId: notebookId);
      await _contentRepo.generateContent(
        content: content,
        notebookId: notebookId,
        contentId: contentId,
      );

    } catch (e) {
      await _contentRepo.generateFailed(notebookId: notebookId);
    }
  }
}

class CreateNotebookParams {
  final String owner;
  final String title;
  final String course;
  final String image;
  final List<String> filetype;
  final String? description;

  CreateNotebookParams({
    required this.owner,
    required this.title, 
    required this.course,
    required this.image,
    required this.filetype,
    this.description,
  });
}