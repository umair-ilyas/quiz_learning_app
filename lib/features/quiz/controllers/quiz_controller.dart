import 'dart:async';
import 'package:get/get.dart';
import '../../../routing/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/quiz_category.dart';
import '../../../core/models/quiz_result.dart';
import '../../../core/models/trivia_question.dart';
import '../../../core/network/trivia_api_service.dart';
import '../../../core/repositories/quiz_repository.dart';
import '../../../app/di/injection.dart';
import '../../home/controllers/user_controller.dart';
import '../../home/controllers/home_controller.dart';

enum QuizState { loading, active, feedback, finished, error }

class QuizController extends GetxController {
  final QuizRepository _quizRepository = sl<QuizRepository>();

  // Category context
  QuizCategory? category;
  int categoryIndex = -1;

  // Quiz state
  final Rx<QuizState> quizState = QuizState.loading.obs;
  final RxList<TriviaQuestion> questions = <TriviaQuestion>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxString selectedAnswer = ''.obs;
  final RxInt correctCount = 0.obs;
  final RxString errorMessage = ''.obs;

  // Timer
  final RxInt remainingSeconds = AppConstants.questionTimerSeconds.obs;
  final RxDouble timerProgress = 1.0.obs;
  Timer? _timer;

  // Computed
  TriviaQuestion? get currentQuestion =>
      questions.isNotEmpty && currentIndex.value < questions.length
      ? questions[currentIndex.value]
      : null;

  bool get isLastQuestion => currentIndex.value == questions.length - 1;

  int get questionNumber => currentIndex.value + 1;
  int get totalQuestions => questions.length;

  String get progressText => '$questionNumber / $totalQuestions';
  double get questionProgress =>
      totalQuestions == 0 ? 0.0 : currentIndex.value / totalQuestions;

  Future<void> loadQuiz({
    required QuizCategory cat,
    required int catIndex,
  }) async {
    category = cat;
    categoryIndex = catIndex;
    quizState.value = QuizState.loading;

    try {
      final fetched = await _quizRepository.fetchQuestions(
        categoryId: cat.id,
        questionType: cat.questionType,
      );
      questions.value = fetched;
      currentIndex.value = 0;
      correctCount.value = 0;
      selectedAnswer.value = '';
      quizState.value = QuizState.active;
      _startTimer();
    } on TriviaApiException catch (e) {
      errorMessage.value = e.message;
      quizState.value = QuizState.error;
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      quizState.value = QuizState.error;
    }
  }

  void selectAnswer(String answer) {
    if (quizState.value != QuizState.active) return;

    _stopTimer();
    selectedAnswer.value = answer;
    quizState.value = QuizState.feedback;

    final q = currentQuestion;
    if (q != null && q.isCorrect(answer)) {
      correctCount.value++;
    }

    // Move to next after 1 second delay
    Future.delayed(
      const Duration(milliseconds: AppConstants.feedbackDelayMs),
      _advance,
    );
  }

  void _advance() {
    if (isLastQuestion) {
      _finishQuiz();
    } else {
      currentIndex.value++;
      selectedAnswer.value = '';
      quizState.value = QuizState.active;
      _startTimer();
    }
  }

  void _startTimer() {
    _stopTimer();
    remainingSeconds.value = AppConstants.questionTimerSeconds;
    timerProgress.value = 1.0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 1) {
        // Time's up - auto-advance
        _stopTimer();
        selectedAnswer.value = '';
        quizState.value = QuizState.feedback;
        Future.delayed(
          const Duration(milliseconds: AppConstants.feedbackDelayMs),
          _advance,
        );
      } else {
        remainingSeconds.value--;
        timerProgress.value =
            remainingSeconds.value / AppConstants.questionTimerSeconds;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _finishQuiz() {
    quizState.value = QuizState.finished;
    _stopTimer();

    final result = QuizResult(
      category: category!,
      totalQuestions: totalQuestions,
      correctAnswers: correctCount.value,
      timeTakenSeconds: 0,
    );

    final userController = Get.find<UserController>();
    final homeController = Get.find<HomeController>();

    // --- Score: only add the improvement over the previous best attempt ---
    final previousBest = _quizRepository.getCategoryBestScore(categoryIndex);
    final scoreDelta = result.scoreEarned - previousBest;

    // Always save category progress (overwrites with latest attempt + best score).
    // Use max(previousBest, current) so best score never goes backward.
    final newBest = result.scoreEarned > previousBest
        ? result.scoreEarned
        : previousBest;

    homeController.updateCategoryProgress(
      categoryIndex: categoryIndex,
      questionsAttempted: totalQuestions,
      questionsAnsweredCorrectly: correctCount.value,
      bestScore: newBest,
    );

    // Add to total score only if this attempt beat the previous best.
    userController.addScore(scoreDelta);

    // --- quizzesTaken: count distinct categories completed, not total plays ---
    final completedCount = _quizRepository.countCompletedCategories();
    userController.syncQuizzesTaken(completedCount);

    // Navigate to result
    appRouter.go('/result', extra: result);
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}
