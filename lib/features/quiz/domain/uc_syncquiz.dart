import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class SyncQuizHistory {
  final NotebookRepo _notebookRepo;

  const SyncQuizHistory(this._notebookRepo);

  Future<void> call({
    required String notebookId,
    required String uid,
    required int score,
    required double aveDifficulty,
    required double accuracy,
  }) async {
    final history = NotebookHistory(
      id: "", 
      notebookId: notebookId,
      uid: uid,
      score: score,
      aveDifficulty: aveDifficulty,
      accuracy: accuracy,
      createdAt: DateTime.now(),
    );

    await _notebookRepo.syncQuizHistory(
      notebookId: notebookId,
      uid: uid,
      history: history,
    );
  }
}