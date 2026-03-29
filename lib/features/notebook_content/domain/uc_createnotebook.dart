import 'dart:async';
import 'dart:typed_data';
import 'package:adalem/features/create/domain/ai_repo.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';

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
        files: params.files,
        topic: params.title,
        description: params.description,
        notebookId: ids.notebookId, 
        contentId: ids.contentId,
      )
    );
    return;
  }

  Future<void> _generateAndSaveBackground({
    required List<({Uint8List bytes, String mimeType})> files,
    required String topic,
    required String? description,
    required String notebookId,
    required String contentId,
  }) async {
    try {
      NotebookContent content = await _aiRepo.generateStudyMaterial(
        files, topic, description
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
  final String? description;
  final List<({Uint8List bytes, String mimeType})> files; 

  CreateNotebookParams({
    required this.owner,
    required this.title, 
    required this.course,
    required this.image,
    this.description,
    required this.files,
  });
}