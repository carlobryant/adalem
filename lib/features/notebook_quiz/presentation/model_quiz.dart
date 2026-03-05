import 'package:adalem/features/notebook_content/domain/content_entity.dart';

enum QuizMode { identification, multipleChoice, flashcard }

class QuizItemModel {
  final QuizItem quizItem;
  final QuizMode mode;
  final List<String>? generatedOptions;

  final String userTypedAnswer;
  final String? selectedOption;
  final bool isRevealed;

  QuizItemModel({
    required this.quizItem,
    required this.mode,
    this.generatedOptions,
    this.userTypedAnswer = '',
    this.selectedOption,
    this.isRevealed = false,
  });

  bool get isAnswered {
    switch (mode) {
      case QuizMode.identification:
        return userTypedAnswer.trim().isNotEmpty;
      case QuizMode.multipleChoice:
        return selectedOption != null;
      case QuizMode.flashcard:
        return isRevealed;
    }
  }

  bool get isIdentificationCorrect =>
      userTypedAnswer.trim().toLowerCase() == quizItem.answer.toLowerCase();

  bool get isMultipleChoiceCorrect => 
      selectedOption == quizItem.answer;

  QuizItemModel copyWith({
    String? userTypedAnswer,
    String? selectedOption,
    bool? isRevealed,
  }) {
    return QuizItemModel(
      quizItem: quizItem,
      mode: mode,
      generatedOptions: generatedOptions,
      userTypedAnswer: userTypedAnswer ?? this.userTypedAnswer,
      selectedOption: selectedOption ?? this.selectedOption,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  QuizItemModel clearAnswer() {
    return QuizItemModel(
      quizItem: quizItem,
      mode: mode,
      generatedOptions: generatedOptions,
      userTypedAnswer: '',
      selectedOption: null,
      isRevealed: false,
    );
  }

  QuizItemModel revealFlashcard() {
    return QuizItemModel(
      quizItem: quizItem,
      mode: mode,
      generatedOptions: generatedOptions,
      userTypedAnswer: userTypedAnswer,
      selectedOption: selectedOption,
      isRevealed: true,
    );
  }
}