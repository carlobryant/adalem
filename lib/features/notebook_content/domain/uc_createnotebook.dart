import 'package:adalem/features/notebook_content/domain/content_repo.dart';

class CreateNotebook {
  final ContentRepo _contentRepo;

  CreateNotebook({required ContentRepo contentRepo})
      : _contentRepo = contentRepo;

  Future<void> call(CreateNotebookParams params) async {
    final content = await _contentRepo.parseContent();
    final ids = _contentRepo.generateIds();

    await _contentRepo.batchCreateNotebookAndContent(
      params: params,
      content: content,
      notebookId: ids.notebookId,
      contentId: ids.contentId,
    );
  }
}

class CreateNotebookParams {
  final String owner;
  final String title;
  final String course;
  final String image;

  CreateNotebookParams({
    required this.owner,
    required this.title, 
    required this.course,
    required this.image,
  });
}