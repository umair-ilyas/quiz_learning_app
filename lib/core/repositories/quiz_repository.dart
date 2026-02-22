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

  /// Save a category's progress to SharedPreferences.
  /// Also stores [bestScore] so repeated attempts only contribute improvements
  /// to the user's total score.
  Future<void> saveCategoryProgress({
    required int categoryIndex,
    required int questionsAttempted,
    required int questionsAnsweredCorrectly,
    required int bestScore,
  }) async {
    final raw = _prefs.getString(AppConstants.prefCategoryProgress) ?? '{}';
    final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
    map['$categoryIndex'] = {
      'attempted': questionsAttempted,
      'correct': questionsAnsweredCorrectly,
      'bestScore': bestScore,
    };
    await _prefs.setString(AppConstants.prefCategoryProgress, jsonEncode(map));
  }

  /// Returns the best score previously earned for this category (0 if never played).
  int getCategoryBestScore(int categoryIndex) {
    final raw = _prefs.getString(AppConstants.prefCategoryProgress) ?? '{}';
    final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
    final entry = map['$categoryIndex'];
    if (entry == null) return 0;
    return (entry as Map<String, dynamic>)['bestScore'] as int? ?? 0;
  }

  /// Returns how many distinct categories have been attempted at least once.
  int countCompletedCategories() {
    final raw = _prefs.getString(AppConstants.prefCategoryProgress) ?? '{}';
    final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
    return map.values
        .where(
          (v) => ((v as Map<String, dynamic>)['attempted'] as int? ?? 0) > 0,
        )
        .length;
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
        'bestScore': (v['bestScore'] as int?) ?? 0,
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
