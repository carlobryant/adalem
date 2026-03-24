import 'dart:async';
import 'dart:io';

import 'package:adalem/features/notebook_content/domain/content_entity.dart';

abstract class AIRepo {
  Future<NotebookContent> generateStudyMaterial(
    List<String> filetype, 
    String title,
    String? description,
  );
}

Future<T> withRetry<T>(
  Future<T> Function() fn, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int attempt = 0;
  Duration delay = initialDelay;

  while (true) {
    try {
      attempt++;
      return await fn();
    } catch (e) {
      final isRetryable = _isRetryable(e);
      if (attempt >= maxAttempts || !isRetryable) rethrow;
      await Future.delayed(delay);
      delay *= 2;
    }
  }
}

bool _isRetryable(Object e) {
  if (e is SocketException || e is TimeoutException) return true;
  final msg = e.toString().toLowerCase();
  return msg.contains("network") ||
         msg.contains("timeout") ||
         msg.contains("unavailable") ||
         msg.contains("503") ||
         msg.contains("500");
}