import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

enum QuestionType { multiple, boolean }

class TriviaQuestion {
  final QuestionType type;
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  late final List<String> allAnswers;

  static final _unescape = HtmlUnescape();

  TriviaQuestion({
    required this.type,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  }) {
    // Shuffle answers once on creation
    final answers = [...incorrectAnswers, correctAnswer];
    if (type == QuestionType.boolean) {
      // True/False: always show True first, False second
      allAnswers = ['True', 'False'];
    } else {
      answers.shuffle(Random());
      allAnswers = answers;
    }
  }

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'multiple';
    return TriviaQuestion(
      type: typeStr == 'boolean' ? QuestionType.boolean : QuestionType.multiple,
      category: _unescape.convert(json['category'] as String? ?? ''),
      difficulty: json['difficulty'] as String? ?? 'easy',
      question: _unescape.convert(json['question'] as String? ?? ''),
      correctAnswer: _unescape.convert(json['correct_answer'] as String? ?? ''),
      incorrectAnswers:
          (json['incorrect_answers'] as List<dynamic>?)
              ?.map((e) => _unescape.convert(e as String))
              .toList() ??
          [],
    );
  }

  bool isCorrect(String answer) => answer == correctAnswer;
}
