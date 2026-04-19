import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Shown when the user taps **Update** on the profile mood meter — pick how to reset or express mood.
class MoodUpdateOptionsScreen extends StatelessWidget {
  const MoodUpdateOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? _Palette.darkBackgroundBottom
          : _Palette.lightBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _Palette.darkBackgroundTop,
                    _Palette.darkBackgroundBottom,
                  ]
                : const [
                    _Palette.lightBackgroundTop,
                    _Palette.lightBackgroundBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ScreenBackButton(
                      iconColor: isDark
                          ? _Palette.darkTextPrimary
                          : _Palette.lightTextPrimary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Update your mood',
                        style: AppTypography.titleLarge(context).copyWith(
                          color: isDark
                              ? _Palette.darkTextPrimary
                              : _Palette.lightTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.xxl + AppSpacing.sm,
                  ),
                  child: Text(
                    'Choose a path that feels right right now.',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: isDark
                          ? _Palette.darkTextSecondary
                          : _Palette.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _OptionCard(
                  isDark: isDark,
                  icon: Icons.auto_stories_rounded,
                  title: 'Fill journal',
                  subtitle:
                      'Name your feelings and let them breathe on the page.',
                  onTap: () => context.push('/journal/mood'),
                ),
                const SizedBox(height: AppSpacing.md),
                _OptionCard(
                  isDark: isDark,
                  icon: Icons.self_improvement_rounded,
                  title: 'Visualize',
                  subtitle:
                      'Settle the mind with a short guided visualization.',
                  onTap: () => context.push('/mindfulness?mood_update=1'),
                ),
                const SizedBox(height: AppSpacing.md),
                _OptionCard(
                  isDark: isDark,
                  icon: Icons.air_rounded,
                  title: 'Breathing',
                  subtitle: 'Follow a gentle breath to soften the moment.',
                  onTap: () => context.push('/breathe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [_Palette.darkSurfaceElevated, _Palette.darkSurface]
                  : const [_Palette.lightSurface, _Palette.lightSurfaceSoft],
            ),
            border: Border.all(
              color: isDark
                  ? _Palette.darkBorder.withValues(alpha: 0.36)
                  : _Palette.lightBorder.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? _Palette.darkShadow.withValues(alpha: 0.45)
                    : _Palette.lightShadow.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? _Palette.darkAccent.withValues(alpha: 0.35)
                        : _Palette.lightAccent.withValues(alpha: 0.14),
                  ),
                  child: Icon(
                    icon,
                    color: isDark
                        ? _Palette.darkAccentSoft
                        : _Palette.lightAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleMedium(context).copyWith(
                          color: isDark
                              ? _Palette.darkTextPrimary
                              : _Palette.lightTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: isDark
                              ? _Palette.darkTextSecondary
                              : _Palette.lightTextSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? _Palette.darkTextSecondary.withValues(alpha: 0.75)
                      : _Palette.lightTextSecondary.withValues(alpha: 0.75),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Palette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFF8F1FD);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE4D0F3);
  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightShadow = Color(0xFF8D5BB6);
  static const Color darkShadow = Color(0xFF0C0515);
}
