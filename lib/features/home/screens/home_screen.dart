import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/home_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/user_header_widget.dart';
import '../widgets/category_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 20),
                    Obx(
                      () => UserHeaderWidget(user: userController.user.value),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionHeader(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              sliver: Obx(
                () => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final category = homeController.categories[index];
                    return CategoryCard(
                      category: category,
                      index: index,
                      onTap: () {
                        context.go(
                          '/countdown',
                          extra: {'category': category, 'categoryIndex': index},
                        );
                      },
                    );
                  }, childCount: homeController.categories.length),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back! 👋', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 2),
            Text('Quiz Hub', style: AppTextStyles.headlineLarge),
          ],
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quiz Categories', style: AppTextStyles.headlineSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '5 Topics',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
