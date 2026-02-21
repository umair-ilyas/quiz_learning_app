class QuizCategory {
  final int id;
  final String name;
  final String emoji;
  final String? questionType; // 'multiple', 'boolean', or null for mixed
  final String color; // hex string for UI
  int questionsAnsweredCorrectly;
  int questionsAttempted;
  static const int totalQuestions = 10;

  QuizCategory({
    required this.id,
    required this.name,
    required this.emoji,
    this.questionType,
    required this.color,
    this.questionsAnsweredCorrectly = 0,
    this.questionsAttempted = 0,
  });

  double get progress =>
      questionsAttempted == 0 ? 0.0 : questionsAttempted / totalQuestions;

  bool get isCompleted => questionsAttempted >= totalQuestions;

  String get apiUrl {
    final base =
        'https://opentdb.com/api.php?amount=$totalQuestions&category=$id&difficulty=easy';
    if (questionType != null) return '$base&type=$questionType';
    return base;
  }

  QuizCategory copyWith({
    int? questionsAnsweredCorrectly,
    int? questionsAttempted,
  }) {
    return QuizCategory(
      id: id,
      name: name,
      emoji: emoji,
      questionType: questionType,
      color: color,
      questionsAnsweredCorrectly:
          questionsAnsweredCorrectly ?? this.questionsAnsweredCorrectly,
      questionsAttempted: questionsAttempted ?? this.questionsAttempted,
    );
  }

  static List<QuizCategory> defaultCategories() => [
    QuizCategory(
      id: 9,
      name: 'General Knowledge',
      emoji: '🌍',
      questionType: 'multiple',
      color: '#6C63FF',
    ),
    QuizCategory(
      id: 17,
      name: 'Science & Nature',
      emoji: '🔬',
      questionType: 'multiple',
      color: '#00BCD4',
    ),
    QuizCategory(
      id: 19,
      name: 'Mathematics',
      emoji: '📐',
      questionType: 'multiple',
      color: '#FF9800',
    ),
    QuizCategory(
      id: 10,
      name: 'Books & English',
      emoji: '📚',
      questionType: 'multiple',
      color: '#E91E63',
    ),
    QuizCategory(
      id: 9,
      name: 'True or False',
      emoji: '✔️',
      questionType: 'boolean',
      color: '#4CAF50',
    ),
  ];
}
