import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class SyncFlashcards {
  final NotebookRepo _notebookRepo;

  const SyncFlashcards(this._notebookRepo);

  Future<void> call({
    required String notebookId,
    required String uid,
    required List<NotebookFlashcard> progress,
    required bool isEarly,
  }) async {
    await _notebookRepo.syncFlashcards(
      notebookId: notebookId,
      uid: uid,
      progress: progress,
      isEarly: isEarly,
    );
  }
}