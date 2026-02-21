import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TimerProgressBar extends StatelessWidget {
  final int remainingSeconds;
  final double progress; // 1.0 → 0.0
  final int totalSeconds;

  const TimerProgressBar({
    super.key,
    required this.remainingSeconds,
    required this.progress,
    required this.totalSeconds,
  });

  Color get _timerColor {
    if (progress > 0.5) return AppColors.timerActive;
    if (progress > 0.25) return AppColors.timerWarning;
    return AppColors.timerDanger;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.timer_rounded, color: _timerColor, size: 18),
            const SizedBox(width: 8),
            Text(
              '${remainingSeconds}s',
              style: AppTextStyles.labelLarge.copyWith(color: _timerColor),
            ),
            const Spacer(),
            Text('Time left', style: AppTextStyles.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: progress, end: progress),
            duration: const Duration(milliseconds: 900),
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                backgroundColor: AppColors.progressBg,
                valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
                minHeight: 8,
              );
            },
          ),
        ),
      ],
    );
  }
}
