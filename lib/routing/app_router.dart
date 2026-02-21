import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/screens/home_screen.dart';
import '../features/countdown/screens/countdown_screen.dart';
import '../features/quiz/screens/quiz_screen.dart';
import '../features/result/screens/result_screen.dart';
import '../core/models/quiz_category.dart';
import '../core/models/quiz_result.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/countdown',
      name: 'countdown',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final category = extra?['category'] as QuizCategory?;
        final categoryIndex = extra?['categoryIndex'] as int? ?? -1;
        return CountdownScreen(
          category: category,
          categoryIndex: categoryIndex,
        );
      },
    ),
    GoRoute(
      path: '/quiz',
      name: 'quiz',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final category = extra?['category'] as QuizCategory?;
        final categoryIndex = extra?['categoryIndex'] as int? ?? -1;
        return QuizScreen(category: category, categoryIndex: categoryIndex);
      },
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
        final result = state.extra as QuizResult?;
        return ResultScreen(result: result);
      },
    ),
  ],
  redirect: (context, state) {
    // Default redirect handled by initialLocation
    return null;
  },
);
