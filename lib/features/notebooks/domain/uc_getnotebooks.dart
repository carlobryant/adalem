import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class GetNotebooks {
  final NotebookRepo _notebookRepo;

  GetNotebooks(this._notebookRepo);

   Stream<List<Notebook>> call() {
    return _notebookRepo.fetchNotebooks();
  }
}