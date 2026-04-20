import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/data/model_datasource.dart';
import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class NotebookRepositoryImpl implements NotebookRepo {
  final FirestoreDataSource _dataSource;

  NotebookRepositoryImpl({required FirestoreDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<List<NotebookDataModel>> fetchNotebooks(String uid) {
    return _dataSource.fetchNotebooks(uid).map((list) =>
        list.map((map) => NotebookDataModel.fromMap(map)).toList());
  }

  @override
  Future<int> getNotebookCount(String uid) {
    return _dataSource.getNotebookCount(uid);
  }

  @override
  Future<void> shareNotebooks(List<String> notebookIds, List<String> targetUserIds){
    return _dataSource.shareNotebooks(notebookIds, targetUserIds);
  }

    @override
  Future<void> syncFlashcards({
    required String notebookId,
    required String uid,
    required List<NotebookFlashcard> progress,
    required bool isEarly,
    required int newStreak,
    required String newStreakAt,
  }) {
    return _dataSource.syncFlashcards(
      notebookId: notebookId,
      uid: uid,
      progress: progress,
      isEarly: isEarly,
      newStreak: newStreak,
      newStreakAt: newStreakAt,
    );
  }

  @override
  Future<void> syncQuizHistory({
    required String notebookId,
    required String uid,
    required NotebookHistory history,
    required int newStreak,
    required String newStreakAt,
  }) {
    return _dataSource.syncQuizHistory(
      notebookId: notebookId,
      uid: uid,
      history: history,
      newStreak: newStreak,
      newStreakAt: newStreakAt,
    );
  }
}