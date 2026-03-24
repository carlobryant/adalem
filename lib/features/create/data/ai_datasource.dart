import 'dart:convert';

import 'package:adalem/features/create/data/model_datasource.dart';
import 'package:adalem/features/create/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/data/model_datasource.dart';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:firebase_ai/firebase_ai.dart';

abstract class AIDataSource {
  Future<NotebookContent> generateStudyMaterial(
    List<String> filetype, 
    String title,
    String? description,
    );
}

class AIDataSourceImpl implements AIDataSource {
  final GenerativeModel modelAI;

  AIDataSourceImpl({required this.modelAI});

  @override
  Future<NotebookContent> generateStudyMaterial(
    List<String> filetype, 
    String title,
    String? description,
  ) async {
    try {
      final promptModel = PromptDataModel(filetype: filetype, title: title, description: description);
      final response = await modelAI.generateContent([
        Content.text(promptModel.build())
      ]);
      
      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception("Unexpected error, received empty response.");
      }

      final cleanJsonString = responseText
          .replaceAll(RegExp(r'```json\n?'), '')
          .replaceAll(RegExp(r'```\n?'), '')
          .trim();

      final map = json.decode(cleanJsonString) as Map<String, dynamic>;
      return NotebookContentDataModel.fromMap({'id': '', ...map});

    } catch (e) {
      if (e is FirebaseAIException) {
          if (e.message == "quota-exceeded") throw AIQuotaExceededException;
          if (e.message == "model-not-found") throw AIUnknownException;
          throw AIUnknownException;
      }
      if (e is FormatException) throw AIInvalidResponseException();
      rethrow;
    }
  }
}