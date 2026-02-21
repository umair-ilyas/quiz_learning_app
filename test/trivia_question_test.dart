import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning_app/core/models/trivia_question.dart';

void main() {
  group('TriviaQuestion.fromJson', () {
    test('parses a multiple choice question correctly', () {
      final json = {
        'type': 'multiple',
        'category': 'General Knowledge',
        'difficulty': 'easy',
        'question': 'What color is the sky?',
        'correct_answer': 'Blue',
        'incorrect_answers': ['Red', 'Green', 'Yellow'],
      };

      final q = TriviaQuestion.fromJson(json);

      expect(q.type, QuestionType.multiple);
      expect(q.category, 'General Knowledge');
      expect(q.difficulty, 'easy');
      expect(q.question, 'What color is the sky?');
      expect(q.correctAnswer, 'Blue');
      expect(q.incorrectAnswers, ['Red', 'Green', 'Yellow']);
      // allAnswers should contain all 4 (shuffled)
      expect(q.allAnswers.length, 4);
      expect(q.allAnswers, containsAll(['Blue', 'Red', 'Green', 'Yellow']));
    });

    test('parses a true/false question correctly', () {
      final json = {
        'type': 'boolean',
        'category': 'Science',
        'difficulty': 'easy',
        'question': 'The sun is a star.',
        'correct_answer': 'True',
        'incorrect_answers': ['False'],
      };

      final q = TriviaQuestion.fromJson(json);

      expect(q.type, QuestionType.boolean);
      expect(q.question, 'The sun is a star.');
      expect(q.correctAnswer, 'True');
      // True/False always shows True first, False second
      expect(q.allAnswers, ['True', 'False']);
    });

    test('decodes HTML entities in question text', () {
      final json = {
        'type': 'multiple',
        'category': 'Entertainment',
        'difficulty': 'easy',
        'question': 'Which movie won the &quot;Best Picture&quot; Oscar?',
        'correct_answer': 'Green Book',
        'incorrect_answers': ['A Star Is Born', 'Roma', 'Black Panther'],
      };

      final q = TriviaQuestion.fromJson(json);

      expect(q.question, contains('"Best Picture"'));
      expect(q.question, isNot(contains('&quot;')));
    });

    test('isCorrect returns true for matching answer', () {
      final json = {
        'type': 'multiple',
        'category': 'General Knowledge',
        'difficulty': 'easy',
        'question': 'What is 2 + 2?',
        'correct_answer': '4',
        'incorrect_answers': ['3', '5', '6'],
      };

      final q = TriviaQuestion.fromJson(json);

      expect(q.isCorrect('4'), isTrue);
      expect(q.isCorrect('3'), isFalse);
    });

    test('handles missing fields gracefully', () {
      final json = <String, dynamic>{};

      final q = TriviaQuestion.fromJson(json);

      expect(q.type, QuestionType.multiple);
      expect(q.question, '');
      expect(q.correctAnswer, '');
      expect(q.incorrectAnswers, isEmpty);
    });
  });
}
