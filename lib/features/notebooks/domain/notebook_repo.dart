import 'package:adalem/features/notebooks/domain/notebook.dart';

abstract class NotebookRepo {
  Future<void> createNotebook({
    required String owner,
    required List<String> uid,
    required String title,
    required String course,
    required String image,
    required String path,
  });

  Stream<List<Notebook>> fetchNotebooks();
}