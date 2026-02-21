import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/option_tile.dart';
import '../widgets/timer_progress_bar.dart';
import '../widgets/question_progress_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/quiz_category.dart';
import '../../../core/models/trivia_question.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/controllers/user_controller.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory? category;
  final int categoryIndex;

  const QuizScreen({
    super.key,
    required this.category,
    required this.categoryIndex,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizController _controller;

  @override
  void initState() {
    super.initState();
    // Ensure global controllers are available
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController());
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }
    _controller = Get.put(QuizController());
    if (widget.category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.loadQuiz(
          cat: widget.category!,
          catIndex: widget.categoryIndex,
        );
      });
    }
  }

  @override
  void dispose() {
    Get.delete<QuizController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back during quiz
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: Obx(() => _buildBody())),
      ),
    );
  }

  Widget _buildBody() {
    switch (_controller.quizState.value) {
      case QuizState.loading:
        return _buildLoading();
      case QuizState.error:
        return _buildError();
      case QuizState.active:
      case QuizState.feedback:
        return _buildQuestion();
      case QuizState.finished:
        return _buildLoading(); // brief while navigating
    }
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 20),
          Text(
            'Loading questions...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.incorrect,
              size: 64,
            ),
            const SizedBox(height: 20),
            Text('Oops!', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 8),
            Text(
              _controller.errorMessage.value,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                if (widget.category != null) {
                  _controller.loadQuiz(
                    cat: widget.category!,
                    catIndex: widget.categoryIndex,
                  );
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final question = _controller.currentQuestion;
    if (question == null) return _buildLoading();

    final isRevealed = _controller.quizState.value == QuizState.feedback;

    return Column(
      children: [
        // Top: Progress + header
        _buildTopBar(),

        // Middle: Question + options (scrollable)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildTypeBadge(question),
                const SizedBox(height: 16),
                _buildQuestionCard(question),
                const SizedBox(height: 24),
                _buildFeedbackLabel(isRevealed),
                _buildOptions(question, isRevealed),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Bottom: Timer
        _buildTimerSection(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceLight, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (_controller.category != null)
                Text(
                  _controller.category!.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _controller.category?.name ?? 'Quiz',
                  style: AppTextStyles.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          QuestionProgressBar(
            currentQuestion: _controller.questionNumber,
            totalQuestions: _controller.totalQuestions,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(TriviaQuestion question) {
    final isBoolean = question.type == QuestionType.boolean;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isBoolean
            ? AppColors.correct.withOpacity(0.12)
            : AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isBoolean ? '✔ True or False' : '📝 Multiple Choice',
        style: AppTextStyles.labelMedium.copyWith(
          color: isBoolean ? AppColors.correct : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(TriviaQuestion question) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            question.question,
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 18,
              height: 1.5,
            ),
          ),
        )
        .animate(key: ValueKey('card_${_controller.currentIndex.value}'))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildFeedbackLabel(bool isRevealed) {
    if (!isRevealed) return const SizedBox.shrink();

    final isCorrect =
        _controller.currentQuestion?.isCorrect(
          _controller.selectedAnswer.value,
        ) ??
        false;
    final isTimeout = _controller.selectedAnswer.value.isEmpty;

    String label;
    Color color;
    IconData icon;

    if (isTimeout) {
      label = "Time's Up! ⏱";
      color = AppColors.timerWarning;
      icon = Icons.timer_off_rounded;
    } else if (isCorrect) {
      label = 'Correct! 🎉';
      color = AppColors.correct;
      icon = Icons.check_circle_rounded;
    } else {
      label = 'Incorrect ❌';
      color = AppColors.incorrect;
      icon = Icons.cancel_rounded;
    }

    return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.titleMedium.copyWith(color: color),
              ),
            ],
          ),
        )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 200.ms);
  }

  Widget _buildOptions(TriviaQuestion question, bool isRevealed) {
    final labels = question.type == QuestionType.boolean
        ? ['T', 'F']
        : ['A', 'B', 'C', 'D'];

    return Column(
          children: List.generate(question.allAnswers.length, (i) {
            final answer = question.allAnswers[i];
            final label = i < labels.length ? labels[i] : '${i + 1}';
            final isSelected = _controller.selectedAnswer.value == answer;
            final isCorrect = question.isCorrect(answer);

            return OptionTile(
              key: ValueKey('option_${_controller.currentIndex.value}_$i'),
              optionLabel: label,
              optionText: answer,
              isSelected: isSelected,
              isCorrect: isCorrect,
              isRevealed: isRevealed,
              onTap: () => _controller.selectAnswer(answer),
            );
          }),
        )
        .animate(key: ValueKey('opts_${_controller.currentIndex.value}'))
        .fadeIn(delay: 150.ms, duration: 300.ms)
        .slideY(
          begin: 0.1,
          end: 0,
          delay: 150.ms,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceLight, width: 1),
        ),
      ),
      child: Obx(
        () => TimerProgressBar(
          remainingSeconds: _controller.remainingSeconds.value,
          progress: _controller.timerProgress.value,
          totalSeconds: AppConstants.questionTimerSeconds,
        ),
      ),
    );
  }
}
