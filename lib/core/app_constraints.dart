enum Constraint {
  maxCreate(value: 10),
  maxShare(value: 10),

  mcItemPts(value: 10),
  flashcardPts(value: 30),
  identificationPts(value: 30);

  final int value;

  const Constraint({
    required this.value,
  });
}