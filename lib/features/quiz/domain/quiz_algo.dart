import 'dart:math';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/quiz/domain/quiz_axis.dart';

enum Attribution { contentOnly, formatOnly, both }

//2D Adaptive Staircase
//PEST (Parameter Estimation by Sequential Testing) Step Control and Attribution Layer
class StaircaseAlgorithm {
  final NotebookContent content;
  final Random _random = Random();

  final AxisState _contentAxis;
  final AxisState _formatAxis;

  bool shouldEndSession = false;
  
  // ── Session Tracking Counters ──
  int _totalItemsThisSession = 0;
  int _totalCorrectThisSession = 0;
  int _sessionScoreXp = 0;
  double _accumulatedDifficulty = 0.0;

  // CLT-derived session caps:
  // Hard content  → 6 items  (Cowan's 4±1 chunks)
  // Medium content → 9 items
  // Easy content   → 12 items
  static const Map<int, int> _sessionCaps = {1: 12, 2: 9, 3: 6};

  /// [initialDifficulty] is passed from the user's previous history 'aveDifficulty'.
  /// If the user is new and has no history, default it to 1.0.
  StaircaseAlgorithm({
    required this.content,
    double initialDifficulty = 1.0, 
  })  : _contentAxis = AxisState(name: 'content', difficulty: initialDifficulty),
        _formatAxis = AxisState(name: 'format', difficulty: initialDifficulty);

  // ── Public Getters ──────────────────────────────────────────

  /// Current content difficulty (1 = Easy, 2 = Medium, 3 = Hard)
  int get targetContent => _contentAxis.target;

  /// Current format difficulty (1 = MC, 2 = Scenario, 3 = Identification)
  int get targetFormat => _formatAxis.target;

  int get itemsServedThisSession => _totalItemsThisSession;

  // ── Core Methods ────────────────────────────────────────────

  /// Records the result of a completed item and updates both axes.
  void recordResult(
    bool isCorrect, {
    required int contentLevel,
    required int formatLevel,
  }) {
    // Track the difficulty of the specific question that was just answered
    _accumulatedDifficulty += ((contentLevel + formatLevel) / 2.0);

    if (isCorrect) {
      _totalCorrectThisSession++;
      
      // Award XP based on the format difficulty
      if (formatLevel == 1) {
        _sessionScoreXp += 10; // Multiple Choice
      } else if (formatLevel == 2) {
        _sessionScoreXp += 10; // Scenario
      } else if (formatLevel == 3) {
        _sessionScoreXp += 30; // Identification
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

    // Cognitive overload — end session early
    if (contentOverload || formatOverload) {
      shouldEndSession = true;
    }

    // CLT item cap for current content difficulty
    final cap = _sessionCaps[targetContent] ?? 9;
    if (_totalItemsThisSession >= cap) {
      shouldEndSession = true;
    }
  }

  // ── Final DB Sync Metrics ──────────────────────────────────

  /// Experience Points (XP) earned in this session. Replaces the old percentage score.
  int get sessionScore => _sessionScoreXp;

  /// The percentage of questions answered correctly (0.0 to 1.0).
  double get sessionAccuracy {
    if (_totalItemsThisSession == 0) return 0.0;
    return _totalCorrectThisSession / _totalItemsThisSession;
  }

  /// The average difficulty of all questions served in this session.
  /// Used to populate the DB field and "Warm Start" the next session.
  double get sessionAveDifficulty {
    if (_totalItemsThisSession == 0) return 1.0;
    return _accumulatedDifficulty / _totalItemsThisSession;
  }

  // 👇 ADD THIS BACK IN FOR THE UI SUMMARY SCREEN 👇
  /// Discrete gamified tier (1 through 9) representing the current difficulty level
  // int get calculatedQuizLevel {
  //   return ((targetContent - 1) * 3) + targetFormat;
  // }

  // ───────────────────────────────────────────────────────────

  dynamic getNextQuestion() {
    final contentLevel = targetContent;
    final formatLevel  = targetFormat;

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
    _contentAxis.resetSession();
    _formatAxis.resetSession();
  }

  void resetFull() {
    resetSession();
    _contentAxis.resetFull();
    _formatAxis.resetFull();
  }

  // Diagnostics and private item selectors remain unchanged...
  // (Included below just for completeness if you are copy-pasting)
  
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

    return pool[_random.nextInt(pool.length)];
  }

  Scenario _getScenario(int contentLevel) {
    List<Scenario> pool = content.scenarios
        .where((s) => s.difficulty == contentLevel)
        .toList();
    if (pool.isEmpty) pool = List.from(content.scenarios);

    return pool[_random.nextInt(pool.length)];
  }
}

Attribution attributeError(int contentLevel, int formatLevel, bool isCorrect) {
  if (isCorrect) return Attribution.both;

  // Format is the bottleneck — hard format, easy/medium content
  if (formatLevel == 3 && contentLevel == 1) return Attribution.formatOnly;
  if (formatLevel == 3 && contentLevel == 2) return Attribution.formatOnly;

  // Content is the bottleneck — hard content, easy format
  if (contentLevel == 3 && formatLevel == 1) return Attribution.contentOnly;
  if (contentLevel == 2 && formatLevel == 1) return Attribution.contentOnly;

  // Ambiguous — penalise both
  return Attribution.both;
}