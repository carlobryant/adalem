import 'package:adalem/features/create/data/ai_datasource.dart';
import 'package:adalem/features/create/domain/ai_repo.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';

class AIRepositoryImpl implements AIRepo {
  final AIDataSource _dataSource;

  AIRepositoryImpl({required AIDataSource dataSource}) 
      : _dataSource = dataSource;

  @override
Future<NotebookContent> generateStudyMaterial(
  List<String> filetype,
  String title,
  String? description,
) async {
  try {
      return await withRetry(
        () => _dataSource.generateStudyMaterial(filetype, title, description),
        maxAttempts: 3,
        initialDelay: const Duration(seconds: 1),
      );
      
    } on FormatException {
      throw const AIInvalidResponseException(); 
    } catch (e) {
      final msg = e.toString().toLowerCase();
      
      if (msg.contains('quota') || msg.contains('429') || msg.contains('exhausted')) {
        throw const AIQuotaExceededException();
      }
      
      if (msg.contains('network') || msg.contains('socket') || msg.contains('timeout')) {
        throw const AINetworkException();
      }
      
      throw AIUnknownException(msg); 
    }
  }
}

sealed class AIException implements Exception {
  final String message;
  const AIException(this.message);
}

class AIQuotaExceededException extends AIException {
  const AIQuotaExceededException() 
      : super("You have reached your daily AI limit. Please try again tomorrow.");
}

class AINetworkException extends AIException {
  const AINetworkException() 
      : super("Network error. Please check your connection and try again.");
}

class AIInvalidResponseException extends AIException {
  const AIInvalidResponseException() 
      : super("The AI generated an invalid format. Please try again.");
}

class AIUnknownException extends AIException {
  const AIUnknownException(String details) 
      : super("An unexpected error occurred: $details");
}