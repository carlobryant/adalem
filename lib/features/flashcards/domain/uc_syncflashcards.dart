import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class SyncFlashcards {
  final NotebookRepo _notebookRepo;

  const SyncFlashcards(this._notebookRepo);

  Future<void> call({
    required String notebookId,
    required String uid,
    required NotebookUser currentUser,
    required List<NotebookFlashcard> progress,
    required bool isEarly,
  }) async {
    final newStreak = currentUser.calculateNewStreak();
    final newStreakAt = currentUser.timestampToStreakAt();
    await _notebookRepo.syncFlashcards(
      notebookId: notebookId,
      uid: uid,
      progress: progress,
      isEarly: isEarly,
      newStreak: newStreak,
      newStreakAt: newStreakAt,
    );
  }
}