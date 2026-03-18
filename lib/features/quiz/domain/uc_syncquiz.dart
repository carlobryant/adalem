import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class SyncQuizHistory {
  final NotebookRepo _notebookRepo;

  const SyncQuizHistory(this._notebookRepo);

  Future<void> call({
    required String notebookId,
    required String uid,
    required int quizLevel,
    required double score,
    required double mastery,
  }) async {
    final history = NotebookHistory(
      id: "", 
      notebookId: notebookId,
      uid: uid,
      quizLevel: quizLevel,
      score: score,
      mastery: mastery,
      createdAt: DateTime.now(),
    );

    await _notebookRepo.syncQuizHistory(
      notebookId: notebookId,
      uid: uid,
      history: history,
    );
  }
}