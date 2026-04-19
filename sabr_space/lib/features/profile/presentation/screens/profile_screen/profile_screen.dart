import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/providers/mood_update_progress_provider.dart';
import 'package:sabr_space/core/providers/theme_mode_provider.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// Profile hub: mood meter, streaks, personalization — same route as `/profile`.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: isDark
          ? _SelfPalette.darkBackgroundBottom
          : _SelfPalette.lightBackgroundBottom,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _SelfPalette.darkBackgroundTop,
                    _SelfPalette.darkBackgroundBottom,
                  ]
                : const [
                    _SelfPalette.lightBackgroundTop,
                    _SelfPalette.lightBackgroundBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SelfHeader(isDark: isDark),
                const SizedBox(height: AppSpacing.lg),
                _SelfHeroCard(isDark: isDark),
                const SizedBox(height: AppSpacing.lg),
                _MoodMeterCard(isDark: isDark),
                const SizedBox(height: AppSpacing.lg),
                _StreaksCard(),
                const SizedBox(height: AppSpacing.lg),
                _PersonalizeCard(
                  isDark: isDark,
                  themeMode: themeMode,
                  onThemeChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(mode),
                ),
                const SizedBox(height: AppSpacing.lg),
                _ProfileMoreMenu(isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelfHeader extends StatelessWidget {
  const _SelfHeader({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Self',
          style: AppTypography.headlineMedium(context).copyWith(
            color: isDark
                ? _SelfPalette.darkTextPrimary
                : _SelfPalette.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '✨',
          style: AppTypography.titleLarge(
            context,
          ).copyWith(color: _SelfPalette.gold),
        ),
      ],
    );
  }
}

class _ProfileMoreMenu extends StatelessWidget {
  const _ProfileMoreMenu({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? Colors.white.withOpacity(0.08)
        : _SelfPalette.lightBorder.withOpacity(0.35);

    return Container(
      width: double.infinity,
      decoration: _SelfDecorations.cardDecoration(isDark: isDark),
      child: Column(
        children: [
          _MoreMenuRow(
            isDark: isDark,
            icon: Icons.diamond_outlined,
            label: 'Upgrade to Premium',
            onTap: () => context.push('/premium'),
          ),
          Divider(height: 1, color: dividerColor),
          _MoreMenuRow(
            isDark: isDark,
            icon: Icons.help_outline_rounded,
            label: 'Support',
            onTap: () => context.push('/support'),
          ),
          Divider(height: 1, color: dividerColor),
          _MoreMenuRow(
            isDark: isDark,
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            destructive: true,
            onTap: () => context.go('/'),
          ),
        ],
      ),
    );
  }
}

class _MoreMenuRow extends StatelessWidget {
  const _MoreMenuRow({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final bool isDark;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final accent = destructive
        ? const Color(0xFFD35A6E)
        : (isDark ? _SelfPalette.darkAccentSoft : _SelfPalette.lightAccent);
    final textColor = destructive
        ? accent
        : (isDark
              ? _SelfPalette.darkTextPrimary
              : _SelfPalette.lightTextPrimary);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: accent),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.titleMedium(
                  context,
                ).copyWith(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark
                  ? _SelfPalette.darkTextSecondary.withOpacity(0.75)
                  : _SelfPalette.lightTextSecondary.withOpacity(0.75),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfHeroCard extends StatelessWidget {
  const _SelfHeroCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _SelfDecorations.cardDecoration(isDark: isDark, hero: true),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [
                        _SelfPalette.darkOrbTop,
                        _SelfPalette.darkOrbBottom,
                      ]
                    : const [
                        _SelfPalette.lightOrbTop,
                        _SelfPalette.lightOrbBottom,
                      ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.62 : 0.82),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salam, Aisha',
                  style: AppTypography.titleLarge(context).copyWith(
                    color: isDark
                        ? _SelfPalette.darkTextPrimary
                        : _SelfPalette.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'How are you feeling today?',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: isDark
                        ? _SelfPalette.darkTextSecondary
                        : _SelfPalette.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodMeterCard extends ConsumerWidget {
  const _MoodMeterCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meterBackground = isDark
        ? _SelfPalette.darkSurface.withOpacity(0.6)
        : _SelfPalette.lightSurfaceSoft.withOpacity(0.7);

    final progressAsync = ref.watch(moodUpdateProgressProvider);
    final meterState = progressAsync.value;
    final fraction = meterState?.displayCalmnessFraction ?? 0.0;
    final headline = _calmnessHeadline(fraction);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _SelfDecorations.cardDecoration(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            isDark: isDark,
            icon: Icons.favorite_outline_rounded,
            title: 'Mood Meter',
            actionLabel: 'Update',
            onTap: () => context.push('/mood-update'),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            headline,
            style: AppTypography.titleMedium(context).copyWith(
              color: isDark
                  ? _SelfPalette.darkTextPrimary
                  : _SelfPalette.lightTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progressAsync.isLoading ? null : fraction.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: meterBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? _SelfPalette.darkAccentSoft : _SelfPalette.lightAccent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _tasksSubtitle(meterState),
            style: AppTypography.bodySmall(context).copyWith(
              color: isDark
                  ? _SelfPalette.darkTextSecondary
                  : _SelfPalette.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

String _calmnessHeadline(double fraction) {
  if (fraction <= 0) return 'Begin your calm practice';
  if (fraction < 1 / 3) return 'A gentle start';
  if (fraction < 2 / 3) return 'Finding steadiness';
  if (fraction < 1) return 'Almost centered';
  return 'Centered and calm';
}

String _tasksSubtitle(MoodMeterState? state) {
  if (state == null) return 'Loading your calm meter…';
  if (state.creditedToday) {
    return 'All practices complete — your meter is full for today.';
  }
  final n = state.tasks.completedCount;
  if (n == 0) {
    return 'Complete journal, visualization, or breathing to fill the meter.';
  }
  if (n < 3) {
    return '$n of 3 calm practices done — keep going.';
  }
  return 'All practices complete — your meter is full.';
}

class _StreaksCard extends ConsumerWidget {
  const _StreaksCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streakDays =
        ref.watch(moodUpdateProgressProvider).value?.dailyStreakDays ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _SelfDecorations.cardDecoration(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            isDark: isDark,
            icon: Icons.local_fire_department_rounded,
            title: 'Streaks',
            actionLabel: 'View',
            onTap: () => context.push('/streak'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StreakStat(
                  isDark: isDark,
                  value: '$streakDays',
                  label: 'Mood days',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StreakStat(
                  isDark: isDark,
                  value: '8',
                  label: 'Journal',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StreakStat(isDark: isDark, value: '5', label: 'Dhikr'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonalizeCard extends StatelessWidget {
  const _PersonalizeCard({
    required this.isDark,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final bool isDark;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _SelfDecorations.cardDecoration(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            isDark: isDark,
            icon: Icons.tune_rounded,
            title: 'Personalize',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _ThemeChip(
                label: 'Light',
                isDark: isDark,
                selected: themeMode == ThemeMode.light,
                onTap: () => onThemeChanged(ThemeMode.light),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ThemeChip(
                label: 'Dark',
                isDark: isDark,
                selected: themeMode == ThemeMode.dark,
                onTap: () => onThemeChanged(ThemeMode.dark),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _QuickRouteChip(
                isDark: isDark,
                icon: Icons.book_outlined,
                label: 'Journal',
                onTap: () => context.push('/journal'),
              ),
              _QuickRouteChip(
                isDark: isDark,
                icon: Icons.library_music_outlined,
                label: 'Audio',
                onTap: () => context.push('/audio-library'),
              ),
              _QuickRouteChip(
                isDark: isDark,
                icon: Icons.star_outline_rounded,
                label: 'Milestones',
                onTap: () => context.push('/milestone'),
              ),
              _QuickRouteChip(
                isDark: isDark,
                icon: Icons.help_outline_rounded,
                label: 'Support',
                onTap: () => context.push('/support'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.isDark,
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark
              ? _SelfPalette.darkAccentSoft
              : _SelfPalette.lightAccent,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTypography.titleMedium(context).copyWith(
            color: isDark
                ? _SelfPalette.darkTextPrimary
                : _SelfPalette.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (actionLabel != null && onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionLabel!,
              style: AppTypography.labelMedium(context).copyWith(
                color: isDark
                    ? _SelfPalette.darkTextSecondary
                    : _SelfPalette.lightTextSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.isDark,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool isDark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = isDark ? _SelfPalette.darkAccent : _SelfPalette.lightAccent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? active.withOpacity(isDark ? 0.36 : 0.14)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? active.withOpacity(0.75)
                : (isDark
                      ? _SelfPalette.darkBorder.withOpacity(0.42)
                      : _SelfPalette.lightBorder.withOpacity(0.72)),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium(context).copyWith(
            color: isDark
                ? _SelfPalette.darkTextPrimary
                : _SelfPalette.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _QuickRouteChip extends StatelessWidget {
  const _QuickRouteChip({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _SelfPalette.darkSurfaceElevated,
                    _SelfPalette.darkSurface,
                  ]
                : const [
                    _SelfPalette.lightSurfaceSoft,
                    _SelfPalette.lightSurface,
                  ],
          ),
          border: Border.all(
            color: isDark
                ? _SelfPalette.darkBorder.withOpacity(0.34)
                : _SelfPalette.lightBorder.withOpacity(0.54),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark
                  ? _SelfPalette.darkTextPrimary
                  : _SelfPalette.lightTextPrimary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium(context).copyWith(
                color: isDark
                    ? _SelfPalette.darkTextPrimary
                    : _SelfPalette.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  const _StreakStat({
    required this.isDark,
    required this.value,
    required this.label,
  });

  final bool isDark;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? _SelfPalette.darkSurfaceElevated.withOpacity(0.60)
            : _SelfPalette.lightSurfaceSoft.withOpacity(0.65),
        border: Border.all(
          color: isDark
              ? _SelfPalette.darkBorder.withOpacity(0.24)
              : _SelfPalette.lightBorder.withOpacity(0.48),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headlineSmall(context).copyWith(
              color: isDark
                  ? _SelfPalette.darkTextPrimary
                  : _SelfPalette.lightTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$label days',
            style: AppTypography.bodySmall(context).copyWith(
              color: isDark
                  ? _SelfPalette.darkTextSecondary
                  : _SelfPalette.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelfDecorations {
  static BoxDecoration cardDecoration({
    required bool isDark,
    bool hero = false,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(hero ? 26 : 22),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? (hero
                  ? const [
                      _SelfPalette.darkHeroTop,
                      _SelfPalette.darkHeroBottom,
                    ]
                  : const [
                      _SelfPalette.darkSurfaceElevated,
                      _SelfPalette.darkSurface,
                    ])
            : (hero
                  ? const [
                      _SelfPalette.lightHeroTop,
                      _SelfPalette.lightHeroBottom,
                    ]
                  : const [
                      _SelfPalette.lightSurface,
                      _SelfPalette.lightSurfaceSoft,
                    ]),
      ),
      border: Border.all(
        color: isDark
            ? _SelfPalette.darkBorder.withOpacity(hero ? 0.55 : 0.36)
            : _SelfPalette.lightBorder.withOpacity(hero ? 0.84 : 0.60),
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? _SelfPalette.darkShadow.withOpacity(hero ? 0.62 : 0.48)
              : _SelfPalette.lightShadow.withOpacity(hero ? 0.26 : 0.20),
          blurRadius: hero ? 24 : 16,
          offset: Offset(0, hero ? 10 : 6),
        ),
      ],
    );
  }
}

class _SelfPalette {
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

  static const Color lightHeroTop = Color(0xFF8A5BB3);
  static const Color lightHeroBottom = Color(0xFF5E3590);
  static const Color darkHeroTop = Color(0xFF5A2F79);
  static const Color darkHeroBottom = Color(0xFF763E9D);

  static const Color lightOrbTop = Color(0xFFCAA1E5);
  static const Color lightOrbBottom = Color(0xFF7543A7);
  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);

  static const Color lightShadow = Color(0xFF8D5BB6);
  static const Color darkShadow = Color(0xFF0C0515);
  static const Color gold = Color(0xFFF2D28A);
}
