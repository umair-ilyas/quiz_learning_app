class AppConstants {
  AppConstants._();

  // API
  static const String triviaBaseUrl = 'https://opentdb.com';
  static const String triviaApiPath = '/api.php';

  // Quiz defaults
  static const int questionsPerQuiz = 10;
  static const int questionTimerSeconds = 60;
  static const int countdownSeconds = 3;
  static const int feedbackDelayMs = 1000;

  // User
  static const String defaultAvatarUrl =
      'https://api.dicebear.com/7.x/adventurer/png?seed=Alex&backgroundColor=b6e3f4';

  // Shared preferences keys
  static const String prefUserScore = 'user_score';
  static const String prefQuizzesTaken = 'quizzes_taken';
  static const String prefCategoryProgress = 'category_progress';
}
