import 'package:cloud_firestore/cloud_firestore.dart';

class Notebook {
  final String id;
  final String owner;
  final List<String> uid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String course;
  final String image;
  final String path;

  const Notebook({
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

  factory Notebook.fromMap(Map<String, dynamic> map) {
    return Notebook(
      id: map['id'] as String,
      owner: map['owner'] as String? ?? '',
      uid: List<String>.from(map['uid'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      title: map['title'] as String? ?? '',
      course: map['course'] as String? ?? '',
      image: map['image'] as String? ?? '',
      path: map['path'] as String? ?? '',
    );
  }
}