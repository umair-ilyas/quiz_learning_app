import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/app_user.dart';

class UserHeaderWidget extends StatelessWidget {
  final AppUser user;

  const UserHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(child: _buildUserInfo()),
              _buildScoreBadge(),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: 'user_avatar',
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.avatarUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppColors.primaryDark,
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.primaryDark,
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: AppTextStyles.headlineMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(
              Icons.military_tech_rounded,
              color: Colors.amber,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              user.rank,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '${user.score}',
            style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
          ),
          Text(
            'Score',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = user.totalQuizzes == 0
        ? 0.0
        : user.quizzesTaken / user.totalQuizzes;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz Progress',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Text(
              '${user.quizzesTaken} / ${user.totalQuizzes}',
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clampedProgress,
            backgroundColor: Colors.white.withOpacity(0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
