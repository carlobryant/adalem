import 'package:adalem/features/auth/domain/auth_repo.dart';

class UpdateActivity {
  final AuthRepo _authRepo;
  
  UpdateActivity(this._authRepo);
  
  Future<void> call(
    String uid, 
    String dateKey, {
    bool isMaxReached = false,
    String? oldestDateKey,
    int created = 0, 
    int quiz = 0, 
    int flashcard = 0,
  }) async {
    return await _authRepo.updateActivity(
      uid, 
      dateKey,
      isMaxReached: isMaxReached,
      oldestDateKey: oldestDateKey,
      created: created, 
      quiz: quiz, 
      flashcard: flashcard,
    );
  }
}