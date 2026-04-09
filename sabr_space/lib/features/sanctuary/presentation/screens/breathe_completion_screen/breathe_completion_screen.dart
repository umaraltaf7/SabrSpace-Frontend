import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Breathe session completion screen.
class BreatheCompletionScreen extends StatelessWidget {
  const BreatheCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                  ],
                ),
                const Spacer(flex: 2),

                // ── Checkmark ──
                Container(
                  width: 100,
                  height: 100,
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
                  child: const Icon(Icons.check, color: Colors.white, size: 48),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                Text(
                  AppStrings.sessionComplete,
                  style: AppTypography.headlineLarge(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'You completed 33 dhikr.\nMay your heart find tranquility.',
                  style: AppTypography.bodyLarge(context).copyWith(
                    color: context.palette.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Stats row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statChip(context, 'Duration', '2:34'),
                    const SizedBox(width: AppSpacing.xxl),
                    _statChip(context, 'Dhikr', '33'),
                  ],
                ),

                const Spacer(flex: 3),

                GradientButton(
                  text: 'Return to Home',
                  onPressed: () => context.go('/home'),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.palette.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.headlineSmall(context).copyWith(
            color: context.palette.primary,
          )),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSmall(context)),
        ],
      ),
    );
  }
}

