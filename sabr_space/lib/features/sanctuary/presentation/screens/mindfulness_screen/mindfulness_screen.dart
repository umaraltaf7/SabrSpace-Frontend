import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/providers/mood_update_progress_provider.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Nūr Mindfulness & Spiritual Sanctuary screen.
///
/// When opened with `?mood_update=1` (from profile mood meter), shows a control
/// to mark the “Visualize” task complete for the calmness meter.
class MindfulnessScreen extends ConsumerWidget {
  const MindfulnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromMoodUpdate =
        GoRouterState.of(context).uri.queryParameters['mood_update'] == '1';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Row(children: [ScreenBackButton()]),
                const Spacer(),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primaryGradient(context),
                    boxShadow: [
                      BoxShadow(
                        color: context.palette.primary.withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.spa, color: Colors.white, size: 36),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  'Nūr Mindfulness',
                  style: AppTypography.headlineLarge(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '& Spiritual Sanctuary',
                  style: AppTypography.bodyLarge(
                    context,
                  ).copyWith(color: context.palette.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.jumbo),
                // Quick access cards
                Row(
                  children: [
                    Expanded(
                      child: _quickCard(
                        context,
                        icon: Icons.air,
                        label: 'Breathe',
                        onTap: () => context.push('/breathe'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _quickCard(
                        context,
                        icon: Icons.auto_stories,
                        label: 'Ayahs',
                        onTap: () => context.push('/ayah-carousel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _quickCard(
                        context,
                        icon: Icons.local_fire_department,
                        label: 'Grief',
                        onTap: () => context.push('/grief-write'),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (fromMoodUpdate) ...[
                  FilledButton.icon(
                    onPressed: () async {
                      await ref
                          .read(moodUpdateProgressProvider.notifier)
                          .completeVisualize();
                      if (context.mounted) context.pop();
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Mark visualization complete'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                GradientButton(
                  text: 'Start Session',
                  onPressed: () => context.push('/breathe-session'),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: context.palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Column(
          children: [
            Icon(icon, color: context.palette.primary, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTypography.labelSmall(context)),
          ],
        ),
      ),
    );
  }
}
