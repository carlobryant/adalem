import 'package:adalem/features/home/domain/updates_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreUpdatesDataSource {
  Stream<Updates> fetchUpdates({required String email});
}

class UpdatesDataSourceImpl implements FirestoreUpdatesDataSource {
  final FirebaseFirestore _firestore;

  UpdatesDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Updates> fetchUpdates({required String email}) {
    return _firestore
        .collection('updates')
        .doc('adalem')
        .snapshots()
        .map((doc) {
          final data = doc.data() ?? {};
          final rawUpdates = data['updates'] as List<dynamic>? ?? [];

          final updates = rawUpdates
              .map((item) {
                final map = item as Map<String, dynamic>;
                return Update(
                  title: map['title'] as String? ?? "",
                  description: map['description'] as String? ?? "",
                  path: map['path'] as String?,
                  excluded: List<String>.from(map['excluded'] as List<dynamic>? ?? []),
                  createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                  photoURL: map['photoURL'] as String?,
                );
              })
              .where((update) =>
                !update.excluded.contains('all') &&
                !update.excluded.contains(email)
              )
              .toList();

          return Updates(
            id: doc.id,
            updates: updates,
          );
        });
  }
}