import 'package:get/get.dart';
import '../../../core/models/app_user.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../app/di/injection.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = sl<UserRepository>();

  final Rx<AppUser> user = AppUser.dummy().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      final loaded = await _userRepository.getUser();
      user.value = loaded;
    } catch (_) {
      user.value = AppUser.dummy();
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds [delta] points to the user's score (only call with a positive improvement delta).
  Future<void> addScore(int delta) async {
    if (delta <= 0) return;
    await _userRepository.addScore(delta);
    user.value = user.value.copyWith(score: user.value.score + delta);
  }

  /// Syncs quizzesTaken to the number of unique categories completed.
  /// This replaces the old incrementQuizzesTaken() so replaying the same quiz
  /// does not inflate the count.
  Future<void> syncQuizzesTaken(int completedCount) async {
    await _userRepository.setQuizzesTaken(completedCount);
    user.value = user.value.copyWith(quizzesTaken: completedCount);
  }
}
