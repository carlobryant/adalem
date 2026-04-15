import 'package:adalem/features/home/data/firestore_datasource.dart';
import 'package:adalem/features/home/domain/updates_entity.dart';

abstract class UpdatesRepo {
  Stream<Updates> fetchUpdates({required String email});
}

class UpdatesRepositoryImpl implements UpdatesRepo {
  final FirestoreUpdatesDataSource _dataSource;

  UpdatesRepositoryImpl({required FirestoreUpdatesDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<Updates> fetchUpdates({required String email}) {
    return _dataSource.fetchUpdates(email: email);
  }
}