import 'dart:math';
import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:adalem/features/quiz/domain/quiz_axis.dart';

enum Attribution { contentOnly, formatOnly, both }

//2D Adaptive Staircase
//PEST (Parameter Estimation by Sequential Testing) Step Control and Attribution Layer
class StaircaseAlgorithm {
  final NotebookContent content;
  final Random _random = Random();

  final AxisState _contentAxis = AxisState(name: 'content');
  final AxisState _formatAxis  = AxisState(name: 'format');

  bool shouldEndSession = false;
  int _totalItemsThisSession = 0;
  int _totalCorrectThisSession = 0;

  // CLT-derived session caps:
  // Hard content  → 6 items  (Cowan's 4±1 chunks)
  // Medium content → 9 items
  // Easy content   → 12 items
  static const Map<int, int> _sessionCaps = {1: 12, 2: 9, 3: 6};

  StaircaseAlgorithm({required this.content});

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
    if (isCorrect) _totalCorrectThisSession++;
    final attribution = attributeError(contentLevel, formatLevel, isCorrect);

    bool contentOverload = false;
    bool formatOverload  = false;

    switch (attribution) {
      case Attribution.contentOnly:
        contentOverload = _contentAxis.recordResult(isCorrect, level: contentLevel);
        // Track format exposure without moving the axis
        _formatAxis.totalPerLevel[formatLevel] =
            (_formatAxis.totalPerLevel[formatLevel] ?? 0) + 1;
        if (isCorrect) {
          _formatAxis.correctPerLevel[formatLevel] =
              (_formatAxis.correctPerLevel[formatLevel] ?? 0) + 1;
        }

      case Attribution.formatOnly:
        formatOverload = _formatAxis.recordResult(isCorrect, level: formatLevel);
        // Track content exposure without moving the axis
        _contentAxis.totalPerLevel[contentLevel] =
            (_contentAxis.totalPerLevel[contentLevel] ?? 0) + 1;
        if (isCorrect) {
          _contentAxis.correctPerLevel[contentLevel] =
              (_contentAxis.correctPerLevel[contentLevel] ?? 0) + 1;
        }

      case Attribution.both:
        contentOverload = _contentAxis.recordResult(isCorrect, level: contentLevel);
        formatOverload  = _formatAxis.recordResult(isCorrect,  level: formatLevel);
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

  // ── Final Gamified Metrics ──────────────────────────────────

  /// Raw percentage score (0.0 to 1.0)
  double get sessionScore {
    if (_totalItemsThisSession == 0) return 0.0;
    return _totalCorrectThisSession / _totalItemsThisSession;
  }

  /// Continuous mastery percentage based on 2D adaptive grid (0.0 to 1.0)
  double get calculatedMastery {
    final combinedDifficulty = _contentAxis.difficulty + _formatAxis.difficulty;
    return (combinedDifficulty - 2.0) / 4.0;
  }

  /// Discrete gamified tier (1 through 9)
  int get calculatedQuizLevel {
    return ((targetContent - 1) * 3) + targetFormat;
  }

  /// Returns the next [QuizItem] or [Scenario] entity based on current
  /// 2D difficulty coordinates. The caller (ViewModel or use case) is
  /// responsible for wrapping this in a presentation model.
  dynamic getNextQuestion() {
    final contentLevel = targetContent;
    final formatLevel  = targetFormat;

    return switch (formatLevel) {
      1 => _getQuizItem(contentLevel),
      2 => _getScenario(contentLevel),
      3 => _getQuizItem(contentLevel), // identification uses same pool
      _ => _getQuizItem(contentLevel),
    };
  }

  /// Resets session-scoped state. Call at the start of each new quiz session.
  /// Preserves learned difficulty so the next session continues where it left off.
  void resetSession() {
    shouldEndSession = false;
    _totalItemsThisSession = 0;
    _contentAxis.resetSession();
    _formatAxis.resetSession();
  }

  /// Full reset including learned difficulty. Use only for a fresh start.
  void resetFull() {
    shouldEndSession = false;
    _totalItemsThisSession = 0;
    _contentAxis.resetFull();
    _formatAxis.resetFull();
  }

  // ── Diagnostics ─────────────────────────────────────────────

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

  // ── Private Item Selectors ───────────────────────────────────

  /// Returns a [QuizItem] entity matching the target content difficulty.
  /// Falls back to the full pool if no items match.
  QuizItem _getQuizItem(int contentLevel) {
    List<QuizItem> pool = content.items
        .where((item) => item.difficulty == contentLevel)
        .toList();
    if (pool.isEmpty) pool = List.from(content.items);

    return pool[_random.nextInt(pool.length)];
  }

  /// Returns a [Scenario] entity matching the target content difficulty.
  /// Falls back to the full pool if no scenarios match.
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