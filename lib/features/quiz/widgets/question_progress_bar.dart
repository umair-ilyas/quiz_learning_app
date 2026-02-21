import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class QuestionProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const QuestionProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  double get progress =>
      totalQuestions == 0 ? 0.0 : (currentQuestion - 1) / totalQuestions;

  @override
  Widget build(BuildContext context) {
    final percent = ((currentQuestion - 1) / totalQuestions * 100).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Question ', style: AppTextStyles.bodySmall),
                Text(
                  '$currentQuestion',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(' / $totalQuestions', style: AppTextStyles.bodySmall),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$percent%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.progressBg,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
