import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/home/presentation/widgets/panic_button.dart';

/// Home dashboard screen: greeting, Quranic quote card, panic button,
/// Daily Paths horizontal list.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Top bar ──
              _buildTopBar(context),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Greeting ──
              Text(
                AppStrings.assalamuAlaykum,
                textDirection: TextDirection.rtl,
                style: AppTypography.headlineLarge(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Wednesday, April 2',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: context.palette.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Quranic quote card ──
              _buildQuoteCard(context),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Panic button ──
              Center(
                child: PanicButton(
                  onPressed: () => context.push('/mood-check'),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Daily Paths ──
              Text(
                AppStrings.dailyPaths,
                style: AppTypography.titleMedium(context),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildDailyPaths(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.appName,
          style: AppTypography.titleMedium(context).copyWith(
            color: context.palette.primary,
          ),
        ),
        Row(
          children: [
            // Streak badge → streak detail
            GestureDetector(
              onTap: () => context.go('/streak'),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.palette.secondaryContainer,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 14, color: context.palette.onSecondaryContainer),
                    const SizedBox(width: 4),
                    Text(
                      '7 DAY STREAK',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: context.palette.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Profile avatar
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: context.palette.primaryFixedDim,
                child:
                    Icon(Icons.person, size: 18, color: context.palette.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient(context),
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: context.palette.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppStrings.quranArabicHome,
            style: AppTypography.arabicVerse(context).copyWith(
              color: Colors.white,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.quranEnglishHome,
            style: AppTypography.bodyMedium(context).copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.quranSubtitleHome,
            style: AppTypography.bodySmall(context).copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.play_circle_outline,
                    color: Colors.white.withValues(alpha: 0.8)),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_border,
                    color: Colors.white.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPaths(BuildContext context) {
    final paths = [
      _PathItem(Icons.air, 'Breathe', context.palette.primaryContainer, '/breathe'),
      _PathItem(Icons.local_fire_department, 'Grief', context.palette.error.withValues(alpha: 0.7), '/grief-write'),
      _PathItem(Icons.auto_stories, 'Ayahs', context.palette.secondary, '/ayah-carousel'),
      _PathItem(Icons.self_improvement, 'Dhikr', context.palette.tertiary, '/dhikr'),
      _PathItem(
        Icons.library_music_outlined,
        AppStrings.audioLibrary,
        context.palette.inversePrimary,
        '/audio-library',
      ),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: paths.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = paths[index];
          return GestureDetector(
            onTap: () => context.push(item.route),
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.palette.surfaceContainerLow,
                borderRadius: AppSpacing.borderRadiusXl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: item.color, size: 28),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.label,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: context.palette.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PathItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _PathItem(this.icon, this.label, this.color, this.route);
}
