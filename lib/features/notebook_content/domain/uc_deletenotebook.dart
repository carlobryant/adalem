import 'package:adalem/features/notebook_content/domain/content_repo.dart';

class DeleteNotebook {
  final ContentRepo _contentRepo;
  DeleteNotebook(this._contentRepo);

  Future<void> call({
    required String notebookId,
    required String contentId,
    required String userId,
  }) {
    return _contentRepo.deleteOrLeaveNotebook(
      notebookId: notebookId,
      contentId: contentId,
      userId: userId,
    );
  }
}