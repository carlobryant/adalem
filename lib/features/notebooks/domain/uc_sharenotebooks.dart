import 'package:adalem/features/notebooks/domain/notebook_repo.dart';

class ShareNotebooks {
  final NotebookRepo _notebookRepo;

  const ShareNotebooks(this._notebookRepo);

  Future<void> call({
    required List<String> notebookIds,
    required List<String> targetUserIds,
  }) async {
    await _notebookRepo.shareNotebooks(notebookIds, targetUserIds);
  }
}