import 'package:adalem/features/notebooks/domain/notebook.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class GetNotebooks {
  final NotebookRepo _notebookRepo;

  GetNotebooks(this._notebookRepo);

  Future<List<Notebook>> call() async {
    return await _notebookRepo.getNotebooks();
  }
}