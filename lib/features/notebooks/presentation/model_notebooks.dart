import 'package:adalem/features/notebooks/domain/notebook_entity.dart';
import 'package:intl/intl.dart';

class NotebookModel {
  final String id;
  final String owner;
  final List<String> uid;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String course;
  final String image;
  final String path;

  const NotebookModel({
    required this.id,
    required this.owner,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.course,
    required this.image,
    required this.path,
  });

  factory NotebookModel.fromEntity(Notebook notebook) {
    return NotebookModel(
      id: notebook.id,
      owner: notebook.owner,
      uid: notebook.uid,
      createdAt: DateFormat("MMM d, yyyy-HH:mm").format(notebook.createdAt),
      updatedAt: DateFormat("MMM d, yyyy-HH:mm").format(notebook.updatedAt),
      title: notebook.title,
      course: notebook.course,
      image: notebook.image,
      path: notebook.path,
    );
  }

  factory NotebookModel.empty() {
    return const NotebookModel(
      id: '',
      owner: '',
      uid: [],
      createdAt: '',
      updatedAt: '',
      title: '',
      course: '',
      image: '',
      path: '',
    );
  }
}