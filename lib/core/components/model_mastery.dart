enum MasteryLevel {
  level1(id: 1, minXp: 0, label: "Novice", asset: "assets/ic_mastery1.png"),
  level2(id: 2, minXp: 100, label: "Advanced Beginner", asset: "assets/ic_mastery2.png"),
  level3(id: 3, minXp: 600, label: "Competent", asset: "assets/ic_mastery3.png"),
  level4(id: 4, minXp: 1400, label: "Proficient", asset: "assets/ic_mastery4.png"),
  level5(id: 5, minXp: 2400, maxXp: 12400, label: "Expert", asset: "assets/ic_mastery5.png");

  final int id;
  final int minXp;
  final int? maxXp;
  final String label;
  final String asset;

  const MasteryLevel({
    required this.id,
    required this.minXp, this.maxXp,
    required this.label,
    required this.asset,
  });

  static MasteryLevel fromXp(int totalXp) {
    for (final level in MasteryLevel.values.reversed) {
      if (totalXp >= level.minXp) {
        return level;
      }
    }
    return MasteryLevel.level1;
  }
}