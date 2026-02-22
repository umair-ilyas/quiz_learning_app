import '../models/app_user.dart';
import '../constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final SharedPreferences _prefs;

  UserRepository({required SharedPreferences prefs}) : _prefs = prefs;

  Future<AppUser> getUser() async {
    final score = _prefs.getInt(AppConstants.prefUserScore) ?? 0;
    final quizzesTaken = _prefs.getInt(AppConstants.prefQuizzesTaken) ?? 0;

    return AppUser.dummy().copyWith(score: score, quizzesTaken: quizzesTaken);
  }

  /// Adds [delta] points on top of the current total.
  Future<void> addScore(int delta) async {
    if (delta <= 0) return;
    final current = _prefs.getInt(AppConstants.prefUserScore) ?? 0;
    await _prefs.setInt(AppConstants.prefUserScore, current + delta);
  }

  /// Overwrites the stored total score with an absolute value.
  Future<void> setUserScore(int total) async {
    await _prefs.setInt(AppConstants.prefUserScore, total);
  }

  /// Sets the number of unique categories completed (not total plays).
  Future<void> setQuizzesTaken(int count) async {
    await _prefs.setInt(AppConstants.prefQuizzesTaken, count);
  }

  Future<void> updateUserStats({
    required int additionalScore,
    bool incrementQuizzesTaken = true,
  }) async {
    final currentScore = _prefs.getInt(AppConstants.prefUserScore) ?? 0;
    final currentQuizzesTaken =
        _prefs.getInt(AppConstants.prefQuizzesTaken) ?? 0;

    await _prefs.setInt(
      AppConstants.prefUserScore,
      currentScore + additionalScore,
    );

    if (incrementQuizzesTaken) {
      await _prefs.setInt(
        AppConstants.prefQuizzesTaken,
        currentQuizzesTaken + 1,
      );
    }
  }

  Future<void> resetStats() async {
    await _prefs.remove(AppConstants.prefUserScore);
    await _prefs.remove(AppConstants.prefQuizzesTaken);
    await _prefs.remove(AppConstants.prefCategoryProgress);
  }
}
