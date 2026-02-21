import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class OptionTile extends StatelessWidget {
  final String optionLabel;
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed; // true when answer has been submitted
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.optionLabel,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.isRevealed,
    this.onTap,
  });

  Color get _borderColor {
    if (!isRevealed) return AppColors.surfaceLight;
    if (isCorrect) return AppColors.correct;
    if (isSelected && !isCorrect) return AppColors.incorrect;
    return AppColors.surfaceLight;
  }

  Color get _bgColor {
    if (!isRevealed) {
      return isSelected
          ? AppColors.primary.withOpacity(0.15)
          : AppColors.cardBg;
    }
    if (isCorrect) return AppColors.correctBg;
    if (isSelected && !isCorrect) return AppColors.incorrectBg;
    return AppColors.cardBg;
  }

  Color get _labelBgColor {
    if (!isRevealed) {
      return isSelected ? AppColors.primary : AppColors.surfaceLight;
    }
    if (isCorrect) return AppColors.correct;
    if (isSelected && !isCorrect) return AppColors.incorrect;
    return AppColors.surfaceLight;
  }

  Widget? get _trailingIcon {
    if (!isRevealed) return null;
    if (isCorrect) {
      return const Icon(
        Icons.check_circle_rounded,
        color: AppColors.correct,
        size: 22,
      );
    }
    if (isSelected && !isCorrect) {
      return const Icon(
        Icons.cancel_rounded,
        color: AppColors.incorrect,
        size: 22,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 200))],
      child: GestureDetector(
        onTap: isRevealed ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor, width: 1.8),
          ),
          child: Row(
            children: [
              // Label bubble (A, B, C, D or T/F)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _labelBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    optionLabel,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  optionText,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isRevealed && isCorrect
                        ? AppColors.correct
                        : isRevealed && isSelected && !isCorrect
                        ? AppColors.incorrect
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (_trailingIcon != null) ...[
                const SizedBox(width: 8),
                _trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
