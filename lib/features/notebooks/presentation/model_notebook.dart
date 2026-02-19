import 'package:adalem/features/notebooks/domain/notebook.dart';
import 'package:intl/intl.dart';

class NotebookCardModel {
  final String id;
  final String owner;
  final List<String> uid;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String course;
  final String image;
  final String path;

  const NotebookCardModel({
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

  factory NotebookCardModel.fromEntity(Notebook notebook) {
    return NotebookCardModel(
      id: notebook.id,
      owner: notebook.owner,
      uid: notebook.uid,
      createdAt: DateFormat('MMM d, yyyy').format(notebook.createdAt),
      updatedAt: DateFormat('MMM d, yyyy').format(notebook.createdAt),
      title: notebook.title,
      course: notebook.course,
      image: notebook.image,
      path: notebook.path,
    );
  }

  factory NotebookCardModel.empty() {
  return const NotebookCardModel(
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