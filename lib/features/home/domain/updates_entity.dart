class Updates {
  final String id;
  final List<Update> updates;

  const Updates({
    required this.id,
    required this.updates,
  });
}

class Update {
  final String title;
  final String description;
  final List<String> excluded;
  final DateTime createdAt;
  final String? photoURL;
  final String? path;

  const Update({
    required this.title,
    required this.description,
    required this.excluded,
    required this.createdAt,
    this.photoURL,
    this.path,
  });
}