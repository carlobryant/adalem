class InfoCardModel {
  final String title;
  final String details;
  final String description;
  final String image;
  final bool atEnd;

  const InfoCardModel({
    required this.title,
    required this.details,
    required this.description,
    required this.image,
    this.atEnd = false,
  });

  static List<InfoCardModel> get all => const [
    InfoCardModel(
      title: "Clear the Clutter",
      details: "Manage Extraneous Load",
      description: "Wasted mental effort on messy notes slows you down. Convert your study materials into structured study tools to focus on studying.",
      image: "ic_notfound",
    ),
    InfoCardModel(
      title: "Productive Brainpower",
      details: "Maximize Germane Load",
      description: "Shift your energy toward the mental effort that actually builds knowledge. Say goodbye to passive reading and hello to active mastery.",
      image: "ic_loader",
    ),
    InfoCardModel(
      title: "Test to Remember",
      details: "Retrieval Practice",
      description: "Simply rereading doesn't work, generate self-testing flashcards and adaptive quizzes that force your brain to actively recall.",
      image: "ic_adalem",
    ),
    InfoCardModel(
      title: "Perfect Timing",
      details: "Spaced Repetition",
      description: "SM-2 algorithm flashcards resurface based on your performance patterns. With these intervals, you lock them into your long-term retention.",
      image: "ic_adalem",
    ),
  ];
}