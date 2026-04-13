import 'dart:math';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/quiz/domain/quiz_axis.dart';

enum Attribution { contentOnly, formatOnly, both }

//PEST ADAPTIVE STAIRCASE
class StaircaseAlgorithm {
  final NotebookContent content;
  final Random _random = Random();

  final AxisState _contentAxis;
  final AxisState _formatAxis;

  bool shouldEndSession = false;
  int _totalItemsThisSession = 0;
  int _totalCorrectThisSession = 0;
  int _sessionScoreXp = 0;
  double _accumulatedDifficulty = 0.0;

  final Set<int> _servedItemIds = {};
  final Set<int> _servedScenarioIds = {};

  // CLT-DERIVED COWAN'S 4±1 CHUNKS (EASY: 12 ITEMS, MEDIUM: 9 ITEMS, HARD: 6 ITEMS)
  static const Map<int, int> _sessionCaps = {1: 12, 2: 9, 3: 6};

  // FROM PREVIOUS AVE DIFFICULTY
  StaircaseAlgorithm({
    required this.content,
    double initialDifficulty = 1.0, 
  })  : _contentAxis = AxisState(name: 'content', difficulty: initialDifficulty),
        _formatAxis = AxisState(name: 'format', difficulty: initialDifficulty);

  // CONTENT DIFFICULTY (EASY: 1, MEDIUM: 2, HARD: 3)
  int get targetContent => _contentAxis.target;

  // FORMAT DIFFICULTY (MC: 1, SCENARIO: 2, IDENTIFICATION: 3)
  int get targetFormat => _formatAxis.target;
  int get itemsServedThisSession => _totalItemsThisSession;

  void recordResult(
    bool isCorrect, {
    required int contentLevel,
    required int formatLevel,
  }) {
    _accumulatedDifficulty += ((contentLevel + formatLevel) / 2.0);

    if (isCorrect) {
      _totalCorrectThisSession++;
      if (formatLevel == 1) {
        _sessionScoreXp += 10;
      } else if (formatLevel == 2) {
        _sessionScoreXp += 10;
      } else if (formatLevel == 3) {
        _sessionScoreXp += 30;
      }
    }

    final attribution = attributeError(contentLevel, formatLevel, isCorrect);

    bool contentOverload = false;
    bool formatOverload  = false;

    switch (attribution) {
      case Attribution.contentOnly:
        contentOverload = _contentAxis.recordResult(isCorrect, level: contentLevel);
        _formatAxis.totalPerLevel[formatLevel] = (_formatAxis.totalPerLevel[formatLevel] ?? 0) + 1;
        if (isCorrect) {
          _formatAxis.correctPerLevel[formatLevel] = (_formatAxis.correctPerLevel[formatLevel] ?? 0) + 1;
        }
        break;

      case Attribution.formatOnly:
        formatOverload = _formatAxis.recordResult(isCorrect, level: formatLevel);
        _contentAxis.totalPerLevel[contentLevel] = (_contentAxis.totalPerLevel[contentLevel] ?? 0) + 1;
        if (isCorrect) {
          _contentAxis.correctPerLevel[contentLevel] = (_contentAxis.correctPerLevel[contentLevel] ?? 0) + 1;
        }
        break;

      case Attribution.both:
        contentOverload = _contentAxis.recordResult(isCorrect, level: contentLevel);
        formatOverload  = _formatAxis.recordResult(isCorrect,  level: formatLevel);
        break;
    }

    _totalItemsThisSession++;

    // END SESSION EARLY (COGNITIVE OVERLOAD)
    if (contentOverload || formatOverload) {
      shouldEndSession = true;
    }

    // ITEM CAP
    final cap = _sessionCaps[targetContent] ?? 9;
    if (_totalItemsThisSession >= cap) {
      shouldEndSession = true;
    }
  }

  // QUIZ RESULT METRICS
  int get sessionScore => _sessionScoreXp;
  double get sessionAccuracy {
    if (_totalItemsThisSession == 0) return 0.0;
    return _totalCorrectThisSession / _totalItemsThisSession;
  }
  double get sessionAveDifficulty {
    if (_totalItemsThisSession == 0) return 1.0;
    return _accumulatedDifficulty / _totalItemsThisSession;
  }

  // UI SUMMARY SCREEN
  // Discrete gamified tier (1 through 9) representing the current difficulty level
  // int get calculatedQuizLevel {
  //   return ((targetContent - 1) * 3) + targetFormat;
  // }

  dynamic getNextQuestion() {
    final contentLevel = targetContent;
    final formatLevel  = targetFormat;
    if (formatLevel == 2 && content.scenarios.isEmpty) {
      return _getQuizItem(contentLevel);
    }
    if ((formatLevel == 1 || formatLevel == 3) && content.items.isEmpty) {
      return _getScenario(contentLevel);
    }
    return switch (formatLevel) {
      1 => _getQuizItem(contentLevel),
      2 => _getScenario(contentLevel),
      3 => _getQuizItem(contentLevel), 
      _ => _getQuizItem(contentLevel),
    };
  }

  void resetSession() {
    shouldEndSession = false;
    _totalItemsThisSession = 0;
    _totalCorrectThisSession = 0;
    _sessionScoreXp = 0;
    _accumulatedDifficulty = 0.0;
    _servedItemIds.clear();
    _servedScenarioIds.clear();
    _contentAxis.resetSession();
    _formatAxis.resetSession();
  }

  void resetFull() {
    resetSession();
    _contentAxis.resetFull();
    _formatAxis.resetFull();
  }
  
  Map<String, dynamic> get diagnostics => {
    'contentDifficulty': _contentAxis.difficulty,
    'formatDifficulty':  _formatAxis.difficulty,
    'targetContent':     targetContent,
    'targetFormat':      targetFormat,
    'contentStep':       _contentAxis.step,
    'formatStep':        _formatAxis.step,
    'itemsThisSession':  _totalItemsThisSession,
    'shouldEndSession':  shouldEndSession,
    'contentAccuracy': {
      for (int l = 1; l <= 3; l++) l: _contentAxis.accuracyForLevel(l),
    },
    'formatAccuracy': {
      for (int l = 1; l <= 3; l++) l: _formatAxis.accuracyForLevel(l),
    },
  };

  QuizItem _getQuizItem(int contentLevel) {
    List<QuizItem> pool = content.items
        .where((item) => item.difficulty == contentLevel)
        .toList();

    if (pool.isEmpty) pool = List.from(content.items);
     final unseenPool = pool.where((item) => !_servedItemIds.contains(item.id)).toList();
    final finalPool = unseenPool.isNotEmpty ? unseenPool : pool;
    if (unseenPool.isEmpty) {
      _servedItemIds.removeAll(pool.map((item) => item.id));
    }

    final item = finalPool[_random.nextInt(finalPool.length)];
    _servedItemIds.add(item.id);

      if (targetFormat == 3) {
        return QuizItem(
          id: item.id,
          text: '${item.text}?:Give the full answer in ${_identificationHint(item.answer)}',
          answer: item.answer,
          difficulty: item.difficulty,
        );
      }

      return item;
  }

  Scenario _getScenario(int contentLevel) {
    List<Scenario> pool = content.scenarios
        .where((s) => s.difficulty == contentLevel)
        .toList();

    if (pool.isEmpty) pool = List.from(content.scenarios);
    final indexedPool = pool.asMap().entries.toList();
    final unseenPool = indexedPool
        .where((entry) => !_servedScenarioIds.contains(entry.key))
        .toList();

    final finalPool = unseenPool.isNotEmpty ? unseenPool : indexedPool;
    if (unseenPool.isEmpty) {
      _servedScenarioIds.removeAll(indexedPool.map((e) => e.key));
    }

    final entry = finalPool[_random.nextInt(finalPool.length)];
    _servedScenarioIds.add(entry.key);

    final targetScenario = entry.value;
    final shuffledOptions = List<String>.from(targetScenario.options)..shuffle(_random);
    return Scenario(
      text: targetScenario.text,
      options: shuffledOptions,
      answer: targetScenario.answer,
      difficulty: targetScenario.difficulty,
    );
  }
}

Attribution attributeError(int contentLevel, int formatLevel, bool isCorrect) {
  if (isCorrect) return Attribution.both;

  // FORMAT TOO HARD
  if (formatLevel == 3 && contentLevel == 1) return Attribution.formatOnly;
  if (formatLevel == 3 && contentLevel == 2) return Attribution.formatOnly;

  // CONTENT TOO HARD
  if (contentLevel == 3 && formatLevel == 1) return Attribution.contentOnly;
  if (contentLevel == 2 && formatLevel == 1) return Attribution.contentOnly;

  // BOTH AXES
  return Attribution.both;
}

String _identificationHint(String answer) {
  final trimmed = answer.trim();
  final abbrEnd   = RegExp(r'^(.+)\s+\(([A-Z0-9\-\/\.]+)\)\s*$');
  final abbrStart = RegExp(r'^\(([A-Z0-9\-\/\.]+)\)\s+(.+)$');

  if (abbrStart.hasMatch(trimmed)) {
    final textPart = abbrStart.firstMatch(trimmed)!.group(2)!;
    final format = _caseFormat(textPart);
    return "'(ABBREVIATION) $format'";
  }
  if (abbrEnd.hasMatch(trimmed)) {
    final textPart = abbrEnd.firstMatch(trimmed)!.group(1)!;
    final format = _caseFormat(textPart);
    return "'$format (ABBREVIATION)'";
  }
  if (trimmed == trimmed.toUpperCase() && trimmed.contains(RegExp(r'[A-Z]'))) {
    return "'UPPERCASE FORMAT'";
  }
  if (trimmed == trimmed.toLowerCase() && trimmed.contains(RegExp(r'[a-z]'))) {
    return "'lowercase format'";
  }
  return "'${_caseFormat(trimmed)}'";
}

String _caseFormat(String text) {
  final words = text.trim().split(RegExp(r'\s+'));
  if (words.isEmpty) return "Title Case Format";

  const minorWords = {'a', 'an', 'the', 'and', 'but', 'or', 'for',
      'nor', 'on', 'at', 'to', 'by', 'in', 'of', 'up', 'as'};
  int capitalizedMajor = 0;
  int totalMajor = 0;

  for (int i = 0; i < words.length; i++) {
    final word = words[i];
    if (word.isEmpty) continue;
    final isMinor = minorWords.contains(word.toLowerCase());
    final isMajor = !isMinor || i == 0 || i == words.length - 1;
    if (isMajor) {
      totalMajor++;
      if (word[0] == word[0].toUpperCase() && word[0].contains(RegExp(r'[A-Z]'))) {
        capitalizedMajor++;
      }
    }
  }
  if (capitalizedMajor == 1 && words[0][0].contains(RegExp(r'[A-Z]'))) {
    return "Sentence case format";
  }
  if (totalMajor > 0 && capitalizedMajor == totalMajor) {
    return "Title Case Format";
  }
  return "Title Case Format";
}