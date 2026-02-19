import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class CreateNotebook {
  final NotebookRepo _notebookRepo;

  CreateNotebook(this._notebookRepo);

  Future<void> call({
    required String owner,
    required List<String> uid,
    required String title,
    required String course,
    required String image,
    required String path,
  }) async {
    await _notebookRepo.createNotebook(
      owner: owner,
      uid: uid,
      title: title,
      course: course,
      image: image,
      path: path,
    );
  }
}