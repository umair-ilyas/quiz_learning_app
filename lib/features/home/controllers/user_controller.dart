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

  Future<void> addScore(int points) async {
    await _userRepository.updateUserStats(additionalScore: points);
    user.value = user.value.copyWith(score: user.value.score + points);
  }

  Future<void> incrementQuizzesTaken() async {
    await _userRepository.updateUserStats(
      additionalScore: 0,
      incrementQuizzesTaken: true,
    );
    user.value = user.value.copyWith(quizzesTaken: user.value.quizzesTaken + 1);
  }
}
