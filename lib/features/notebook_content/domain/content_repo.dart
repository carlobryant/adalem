import 'package:adalem/features/notebook_content/domain/content_entity.dart';

abstract class ContentRepo {
  Future<NotebookContent?> fetchContent(String notebookId);
}