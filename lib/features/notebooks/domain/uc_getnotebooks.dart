import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class GetNotebooks {
  final NotebookRepo _repository;
  GetNotebooks(this._repository);

  Stream<List<Notebook>> call(String uid) {
    return _repository.fetchNotebooks(uid);
  }
}