import 'package:adalem/features/home/data/repo_impl.dart';
import 'package:adalem/features/home/domain/updates_entity.dart';

class GetUpdates {
  final UpdatesRepo _repository;
  GetUpdates(this._repository);

  Stream<Updates> call({required String email}) {
    return _repository.fetchUpdates(email: email);
  }
}