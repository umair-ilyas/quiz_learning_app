import 'quiz_category.dart';

class QuizResult {
  final QuizCategory category;
  final int totalQuestions;
  final int correctAnswers;
  final int timeTakenSeconds;

  const QuizResult({
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTakenSeconds,
  });

  int get incorrectAnswers => totalQuestions - correctAnswers;

  double get accuracy =>
      totalQuestions == 0 ? 0.0 : correctAnswers / totalQuestions;

  int get scoreEarned => correctAnswers * 10;

  String get grade {
    if (accuracy >= 0.9) return 'A+';
    if (accuracy >= 0.8) return 'A';
    if (accuracy >= 0.7) return 'B';
    if (accuracy >= 0.6) return 'C';
    if (accuracy >= 0.5) return 'D';
    return 'F';
  }

  String get encouragement {
    if (accuracy >= 0.8) return 'Excellent work! 🎉';
    if (accuracy >= 0.6) return 'Good job! Keep going! 👍';
    if (accuracy >= 0.4) return 'Nice try! Practice more! 💪';
    return 'Keep practicing! You\'ll get it! 📚';
  }
}
