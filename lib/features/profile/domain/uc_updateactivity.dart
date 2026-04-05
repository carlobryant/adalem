import 'package:adalem/features/auth/domain/auth_repo.dart';

class UpdateActivity {
  final AuthRepo _authRepo;
  
  UpdateActivity(this._authRepo);
  
  Future<void> call(
    String uid, {
    int created = 0, 
    int quiz = 0, 
    int flashcard = 0,
  }) async {
    final dateKey = DateTime.now().toIso8601String().split('T').first; 
    return await _authRepo.updateActivity(
      uid, 
      dateKey, 
      created: created, 
      quiz: quiz, 
      flashcard: flashcard,
    );
  }
}