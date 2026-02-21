import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/quiz_category.dart';

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  Color get _cardColor {
    final hex = category.color.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: index * 80),
          duration: 350.ms,
        ),
        SlideEffect(
          delay: Duration(milliseconds: index * 80),
          duration: 350.ms,
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ),
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _cardColor.withOpacity(0.25), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _cardColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildEmojiBadge(),
              const SizedBox(width: 16),
              Expanded(child: _buildInfo()),
              const SizedBox(width: 12),
              _buildProgressCircle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiBadge() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _cardColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(category.emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          style: AppTextStyles.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              '${(category.progress * 100).toInt()}% completed',
              style: AppTextStyles.bodySmall.copyWith(
                color: category.isCompleted
                    ? AppColors.correct
                    : AppColors.textHint,
              ),
            ),
            if (category.isCompleted) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.correct,
                size: 14,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: category.progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.progressBg,
            valueColor: AlwaysStoppedAnimation<Color>(_cardColor),
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${category.questionsAttempted} / ${QuizCategory.totalQuestions} questions',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProgressCircle() {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: category.progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.progressBg,
            valueColor: AlwaysStoppedAnimation<Color>(_cardColor),
            strokeWidth: 4,
          ),
          Center(
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: _cardColor,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
