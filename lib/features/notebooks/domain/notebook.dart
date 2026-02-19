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
}