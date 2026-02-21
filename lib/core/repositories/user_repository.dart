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
