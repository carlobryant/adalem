import 'package:adalem/features/notebook_content/domain/content_entity.dart';

class ScenarioModel {
  final Scenario scenario;
  final String? selectedOption;
  final bool isSubmitted;

  ScenarioModel({
    required this.scenario,
    this.selectedOption,
    this.isSubmitted = false,
  });

  bool get isCorrect => selectedOption == scenario.answer;

  ScenarioModel copyWith({String? selectedOption, bool? isSubmitted}) {
    return ScenarioModel(
      scenario: scenario,
      selectedOption: selectedOption ?? this.selectedOption,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  ScenarioModel clearSelection() {
    return ScenarioModel(
      scenario: scenario,
      selectedOption: null,
      isSubmitted: isSubmitted, 
    );
  }
}