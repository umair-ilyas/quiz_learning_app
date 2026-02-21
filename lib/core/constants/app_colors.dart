import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A43D4);
  static const Color accent = Color(0xFFFF6584);

  // Background
  static const Color background = Color(0xFF0F0E1A);
  static const Color surface = Color(0xFF1C1B2E);
  static const Color surfaceLight = Color(0xFF252440);
  static const Color cardBg = Color(0xFF1E1D31);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0AFCA);
  static const Color textHint = Color(0xFF6B6A8D);

  // Feedback
  static const Color correct = Color(0xFF4CAF50);
  static const Color incorrect = Color(0xFFF44336);
  static const Color correctBg = Color(0x204CAF50);
  static const Color incorrectBg = Color(0x20F44336);

  // Timer
  static const Color timerActive = Color(0xFF6C63FF);
  static const Color timerWarning = Color(0xFFFFB347);
  static const Color timerDanger = Color(0xFFF44336);

  // Progress
  static const Color progressBg = Color(0xFF252440);
  static const Color progressFill = Color(0xFF6C63FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1D31), Color(0xFF252440)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient countdownGradient = LinearGradient(
    colors: [Color(0xFF0F0E1A), Color(0xFF1C1B2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
