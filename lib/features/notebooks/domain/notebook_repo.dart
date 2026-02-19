import 'package:adalem/features/notebooks/domain/notebook.dart';

abstract class NotebookRepo {
  Future<List<Notebook>> getNotebooks();
}