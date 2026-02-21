import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/countdown_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/quiz_category.dart';

class CountdownScreen extends StatefulWidget {
  final QuizCategory? category;
  final int categoryIndex;

  const CountdownScreen({
    super.key,
    required this.category,
    required this.categoryIndex,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late CountdownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CountdownController());

    // Watch isDone using ever() so we have access to BuildContext
    ever(_controller.isDone, (bool done) {
      if (done && widget.category != null && mounted) {
        context.go(
          '/quiz',
          extra: {
            'category': widget.category!,
            'categoryIndex': widget.categoryIndex,
          },
        );
      }
    });
  }

  @override
  void dispose() {
    Get.delete<CountdownController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.countdownGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.category != null) ...[
                  Text(
                    widget.category!.emoji,
                    style: const TextStyle(fontSize: 60),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 12),
                  Text(
                    widget.category!.name,
                    style: AppTextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '10 Questions · Easy',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 60),
                ],
                Text(
                  'Get Ready!',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 24),
                Obx(() => _buildCountdownNumber()),
                const SizedBox(height: 40),
                Obx(
                  () => Text(
                    _controller.isGo.value
                        ? 'GO!'
                        : 'Starting in ${_controller.currentCount.value}...',
                    style: AppTextStyles.bodyMedium,
                  ).animate(key: ValueKey(_controller.currentCount.value)).fadeIn(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownNumber() {
    if (_controller.isGo.value) {
      return Text(
            'GO!',
            style: AppTextStyles.countdownNumber.copyWith(
              color: AppColors.correct,
              fontSize: 90,
            ),
          )
          .animate(key: const ValueKey('go'))
          .scale(
            begin: const Offset(0.5, 0.5),
            curve: Curves.elasticOut,
            duration: 500.ms,
          )
          .fadeIn(duration: 200.ms);
    }

    return Text(
          '${_controller.currentCount.value}',
          style: AppTextStyles.countdownNumber,
        )
        .animate(key: ValueKey(_controller.currentCount.value))
        .scale(
          begin: const Offset(1.4, 1.4),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 250.ms);
  }
}
