import 'package:adalem/features/notebooks/domain/notebook_entity.dart';

abstract class NotebookRepo {
  Stream<List<Notebook>> fetchNotebooks();
}