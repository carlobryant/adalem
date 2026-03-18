import 'dart:math';

class AxisState {
  final String name;

  double difficulty;
  double step;

  final double minDifficulty;
  final double maxDifficulty;
  final double minStep;
  final double maxStep;
  final double initialStep;

  int _consecutiveCorrect = 0;
  int _consecutiveIncorrect = 0;
  int _lastDirection = 0; // 1 = Up, -1 = Down, 0 = Initial

  // Accuracy tracking per level
  final Map<int, int> correctPerLevel = {1: 0, 2: 0, 3: 0};
  final Map<int, int> totalPerLevel   = {1: 0, 2: 0, 3: 0};

  AxisState({
    required this.name,
    this.difficulty = 1.0,
    this.step = 0.5,
    this.minDifficulty = 1.0,
    this.maxDifficulty = 3.0,
    this.minStep = 0.1,
    this.maxStep = 1.0,
    this.initialStep = 0.5,
  });

  int get target => difficulty.round().clamp(
        minDifficulty.toInt(),
        maxDifficulty.toInt(),
      );

  /// Updates this axis based on a correct/incorrect signal.
  /// Returns true if 3 consecutive incorrect (overload signal).
  bool recordResult(bool isCorrect, {int? level}) {
    if (level != null) {
      totalPerLevel[level] = (totalPerLevel[level] ?? 0) + 1;
      if (isCorrect) {
        correctPerLevel[level] = (correctPerLevel[level] ?? 0) + 1;
      }
    }

    if (isCorrect) {
      _consecutiveCorrect++;
      _consecutiveIncorrect = 0;

      // PEST: halve step on direction reversal
      if (_lastDirection == -1) {
        step = max(minStep, step / 2);
      }

      // PEST: double step on 3 consecutive correct (fast traversal)
      if (_consecutiveCorrect >= 3) {
        step = min(maxStep, step * 2);
        _consecutiveCorrect = 0;
      }

      _lastDirection = 1;
      difficulty = (difficulty + step).clamp(minDifficulty, maxDifficulty);
      return false;

    } else {
      _consecutiveIncorrect++;
      _consecutiveCorrect = 0;

      // PEST: halve step on direction reversal
      if (_lastDirection == 1) {
        step = max(minStep, step / 2);
      }

      _lastDirection = -1;
      difficulty = (difficulty - step).clamp(minDifficulty, maxDifficulty);

      return _consecutiveIncorrect >= 3;
    }
  }

  /// Per-level accuracy (0.0–1.0). Returns 1.0 if no data yet.
  double accuracyForLevel(int level) {
    final total = totalPerLevel[level] ?? 0;
    if (total == 0) return 1.0;
    return (correctPerLevel[level] ?? 0) / total;
  }

  /// Resets session-scoped counters while preserving learned difficulty.
  void resetSession() {
    _consecutiveCorrect = 0;
    _consecutiveIncorrect = 0;
  }

  /// Full reset including learned difficulty.
  void resetFull() {
    resetSession();
    difficulty = 1.0;
    step = initialStep;
  }
}