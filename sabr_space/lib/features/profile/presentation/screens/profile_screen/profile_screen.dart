import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/providers/theme_mode_provider.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Profile screen with user stats, streak, and preferences.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final text = context.text;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ── Top bar ──
                Row(
                  children: [
                    const ScreenBackButton(),
                    Expanded(
                      child: Text(
                        AppStrings.profile,
                        style: text.titleLarge?.copyWith(
                          color: palette.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Avatar + name ──
                CircleAvatar(
                  radius: 44,
                  backgroundColor: palette.primaryFixedDim,
                  child: Text(
                    'T',
                    style: text.headlineLarge?.copyWith(
                      color: palette.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.profileName, style: text.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  AppStrings.soulInTraining,
                  style: text.bodySmall?.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Mode preference + stats ──
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: palette.surfaceContainerLowest,
                    borderRadius: AppSpacing.borderRadiusXl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.modePreference,
                        style: text.labelMedium?.copyWith(
                          letterSpacing: 1.2,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(context, 'Total Time', AppStrings.totalTime),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _statCard(context, 'Verses Read', AppStrings.versesRead),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Appearance (theme) ──
                Container(
                  width: double.infinity,
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: palette.surfaceContainerLowest,
                    borderRadius: AppSpacing.borderRadiusXl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appearance,
                        style: text.labelMedium?.copyWith(
                          letterSpacing: 1.2,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text(AppStrings.themeLight),
                            icon: Icon(Icons.light_mode_outlined, size: 18),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text(AppStrings.themeDark),
                            icon: Icon(Icons.dark_mode_outlined, size: 18),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text(AppStrings.themeSystem),
                            icon: Icon(Icons.settings_suggest_outlined, size: 18),
                          ),
                        ],
                        selected: {themeMode},
                        onSelectionChanged: (Set<ThemeMode> next) {
                          ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(next.first);
                        },
                        showSelectedIcon: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Spiritual growth ──
                Container(
                  width: double.infinity,
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primaryGradient(context),
                    borderRadius: AppSpacing.borderRadiusXl,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.spiritualGrowth,
                        style: text.titleMedium?.copyWith(
                          color: palette.onPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AppStrings.topCommunity,
                        style: text.bodyMedium?.copyWith(
                          color: palette.onPrimary.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Settings items ──
                _settingsItem(
                  context,
                  icon: Icons.diamond_outlined,
                  label: 'Upgrade to Premium',
                  onTap: () => context.push('/premium'),
                ),
                _settingsItem(
                  context,
                  icon: Icons.help_outline,
                  label: 'Support',
                  onTap: () => context.push('/support'),
                ),
                _settingsItem(
                  context,
                  icon: Icons.star_border,
                  label: 'Milestones',
                  onTap: () => context.push('/milestone'),
                ),
                _settingsItem(
                  context,
                  icon: Icons.logout,
                  label: 'Sign Out',
                  color: palette.error,
                  onTap: () => context.go('/'),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Footer info ──
                Text(
                  'Member since September 2023 · v2.4.0 Sabr Space',
                  style: text.bodySmall?.copyWith(
                    color: palette.outline,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, String value) {
    final palette = context.palette;
    final text = context.text;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: text.headlineSmall?.copyWith(
              color: palette.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: text.labelSmall),
        ],
      ),
    );
  }

  Widget _settingsItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final palette = context.palette;
    final text = context.text;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color ?? palette.onSurfaceVariant),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                label,
                style: text.bodyLarge?.copyWith(
                  color: color ?? palette.onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 20, color: palette.outlineVariant),
          ],
        ),
      ),
    );
  }
}
