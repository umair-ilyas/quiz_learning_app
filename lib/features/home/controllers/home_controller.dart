import 'package:get/get.dart';
import '../../../core/models/quiz_category.dart';
import '../../../core/repositories/quiz_repository.dart';
import '../../../app/di/injection.dart';

class HomeController extends GetxController {
  final QuizRepository _quizRepository = sl<QuizRepository>();

  final RxList<QuizCategory> categories = <QuizCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = _quizRepository.getCategoriesWithProgress();
  }

  void updateCategoryProgress({
    required int categoryIndex,
    required int questionsAttempted,
    required int questionsAnsweredCorrectly,
  }) {
    if (categoryIndex < 0 || categoryIndex >= categories.length) return;

    final updated = categories[categoryIndex].copyWith(
      questionsAttempted: questionsAttempted,
      questionsAnsweredCorrectly: questionsAnsweredCorrectly,
    );
    categories[categoryIndex] = updated;
    categories.refresh();

    // Persist
    _quizRepository.saveCategoryProgress(
      categoryIndex: categoryIndex,
      questionsAttempted: questionsAttempted,
      questionsAnsweredCorrectly: questionsAnsweredCorrectly,
    );
  }
}
