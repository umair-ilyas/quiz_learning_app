import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/quiz_result.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult? result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No result data', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final r = result!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTrophySection(r),
              const SizedBox(height: 30),
              _buildScoreCard(r),
              const SizedBox(height: 20),
              _buildStatsRow(r),
              const SizedBox(height: 24),
              _buildCategoryInfo(r),
              const SizedBox(height: 32),
              _buildEncouragement(r),
              const SizedBox(height: 32),
              _buildBackButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrophySection(QuizResult r) {
    final emoji = r.accuracy >= 0.8
        ? '🏆'
        : r.accuracy >= 0.6
        ? '🥈'
        : r.accuracy >= 0.4
        ? '🥉'
        : '📚';

    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 80))
            .animate()
            .scale(
              begin: const Offset(0, 0),
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 300.ms),
        const SizedBox(height: 16),
        Text('Quiz Complete!', style: AppTextStyles.headlineLarge)
            .animate()
            .fadeIn(delay: 300.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, delay: 300.ms),
        const SizedBox(height: 6),
        Text(
          r.category.name,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildScoreCard(QuizResult r) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                    '${r.correctAnswers} / ${r.totalQuestions}',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  )
                  .animate(delay: 500.ms)
                  .fadeIn()
                  .scale(begin: const Offset(0.7, 0.7)),
              const SizedBox(height: 4),
              Text(
                'Correct Answers',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _gradeChip(r.grade),
                  const SizedBox(width: 12),
                  _scorePill(r.scoreEarned),
                ],
              ),
            ],
          ),
        )
        .animate(delay: 200.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _gradeChip(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.grade_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            'Grade $grade',
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _scorePill(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            '+$score pts',
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(QuizResult r) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.correct,
            label: 'Correct',
            value: '${r.correctAnswers}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.cancel_outlined,
            color: AppColors.incorrect,
            label: 'Wrong',
            value: '${r.incorrectAnswers}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.percent_rounded,
            color: AppColors.primary,
            label: 'Accuracy',
            value: '${(r.accuracy * 100).toInt()}%',
          ),
        ),
      ],
    ).animate(delay: 600.ms).fadeIn(duration: 400.ms);
  }

  Widget _statCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo(QuizResult r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight, width: 1),
      ),
      child: Row(
        children: [
          Text(r.category.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.category.name, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${r.totalQuestions} questions answered',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.correct.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Completed ✓',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.correct,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 700.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildEncouragement(QuizResult r) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(r.encouragement, style: AppTextStyles.titleMedium),
          ),
        ],
      ),
    ).animate(delay: 800.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home_rounded),
            label: const Text('Back to Home'),
          ),
        )
        .animate(delay: 900.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
