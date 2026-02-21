import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routing/app_router.dart';
import '../core/constants/app_theme.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/home/controllers/user_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Register global controllers
    Get.put(UserController(), permanent: true);
    Get.put(HomeController(), permanent: true);

    return MaterialApp.router(
      title: 'Quiz Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
