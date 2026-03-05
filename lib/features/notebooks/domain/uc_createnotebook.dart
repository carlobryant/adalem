import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class CreateNotebook {
  final NotebookRepo _notebookRepo;
  CreateNotebook(this._notebookRepo);

  // Future<void> call({
  //   required String owner,
  //   required List<String> uid,
  //   required String title,
  //   required String course,
  //   required String image,
  //   required String path,
  // }) async {
  //   await _notebookRepo.createNotebook(
  //     owner: owner,
  //     uid: uid,
  //     title: title,
  //     course: course,
  //     image: image,
  //     path: path,
  //   );
  // }

  Future<void> call(CreateNotebookParams params) async {
    await _notebookRepo.createNotebook(params);
  }
}

class CreateNotebookParams {
  final String owner;
  final String title;
  final String course;
  final String image;

  CreateNotebookParams({
    required this.owner,
    required this.title, 
    required this.course,
    required this.image,
  });
}