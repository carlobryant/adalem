import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class GetNotebookCount {
  final NotebookRepo _repository;

  GetNotebookCount(this._repository);

  Future<int> call(String uid) {
    return _repository.getNotebookCount(uid);
  }
}