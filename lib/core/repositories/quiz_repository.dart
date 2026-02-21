import 'dart:convert';
import '../constants/app_constants.dart';
import '../models/quiz_category.dart';
import '../models/trivia_question.dart';
import '../network/trivia_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizRepository {
  final TriviaApiService _apiService;
  final SharedPreferences _prefs;

  QuizRepository({
    required TriviaApiService apiService,
    required SharedPreferences prefs,
  }) : _apiService = apiService,
       _prefs = prefs;

  Future<List<TriviaQuestion>> fetchQuestions({
    required int categoryId,
    String? questionType,
    int amount = AppConstants.questionsPerQuiz,
  }) {
    return _apiService.fetchQuestions(
      categoryId: categoryId,
      amount: amount,
      questionType: questionType,
    );
  }

  /// Save a category's progress to SharedPreferences
  Future<void> saveCategoryProgress({
    required int categoryIndex,
    required int questionsAttempted,
    required int questionsAnsweredCorrectly,
  }) async {
    final raw = _prefs.getString(AppConstants.prefCategoryProgress) ?? '{}';
    final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
    map['$categoryIndex'] = {
      'attempted': questionsAttempted,
      'correct': questionsAnsweredCorrectly,
    };
    await _prefs.setString(AppConstants.prefCategoryProgress, jsonEncode(map));
  }

  /// Load saved progress for all categories
  Map<int, Map<String, int>> loadCategoryProgress() {
    final raw = _prefs.getString(AppConstants.prefCategoryProgress) ?? '{}';
    final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((key, value) {
      final v = value as Map<String, dynamic>;
      return MapEntry(int.parse(key), {
        'attempted': (v['attempted'] as int?) ?? 0,
        'correct': (v['correct'] as int?) ?? 0,
      });
    });
  }

  /// Build categories with persisted progress
  List<QuizCategory> getCategoriesWithProgress() {
    final categories = QuizCategory.defaultCategories();
    final progress = loadCategoryProgress();
    for (int i = 0; i < categories.length; i++) {
      final saved = progress[i];
      if (saved != null) {
        categories[i] = categories[i].copyWith(
          questionsAttempted: saved['attempted'] ?? 0,
          questionsAnsweredCorrectly: saved['correct'] ?? 0,
        );
      }
    }
    return categories;
  }
}
