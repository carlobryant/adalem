import 'package:adalem/features/home/domain/updates_entity.dart';

abstract class UpdatesRepo {
  Stream<Updates> fetchUpdates({required String email});
}