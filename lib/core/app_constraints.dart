class Constraint {
  static const int maxCreate = 10;
  static const int maxShare = 10;
  static const int maxUploadMB = 15;
  static const int maxActivity = 56;

  static const int mcItemPts = 10;
  static const int flashcardPts = 30;
  static const int indentificationPts = 30;

  static const int minPromptItems = 36;
  static const int minPromptScenario = 18;
  static const int maxPromptSummary = 3000;

  static const List<String> allowedExts = ["png", "jpg", "txt", "md", "pdf", "docx", "pptx", "mp3", "mp4"];
  static const String sdg4 = "Ensure inclusive and equitable quality education and promote lifelong learning opportunities for all.";
  static const String noticeAI = "Notice: Files and information provided are processed under Google services per the Gemini Apps Privacy Notice. By creating this notebook, you confirm you have understood the privacy implications and the scope of data usage defined therein.";
}