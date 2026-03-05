import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:adalem/features/notebooks/domain/uc_createnotebook.dart';

abstract class NotebookRepo {
  Stream<List<Notebook>> fetchNotebooks();
  Future<void> createNotebook(CreateNotebookParams params);
}