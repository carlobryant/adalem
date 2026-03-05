import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';

class GetContent {
  final ContentRepo _contentRepo;

  GetContent(this._contentRepo);

  Future<NotebookContent?> call(String notebookId) async {
    return await _contentRepo.fetchContent(notebookId);
  }
}