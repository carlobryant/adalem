import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/model_notebook.dart';
import 'package:flutter/foundation.dart';

class ExploreViewModel extends ChangeNotifier {
  final GetNotebooks _getNotebooks;

  ExploreViewModel({required GetNotebooks getNotebooks})
      : _getNotebooks = getNotebooks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotebookCardModel> _notebooks = [];
  List<NotebookCardModel> get notebooks => _notebooks;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotebooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _getNotebooks();
      _notebooks = results.map(NotebookCardModel.fromEntity).toList();
    } catch (e) {
      _errorMessage = "Failed to load notebooks. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}