import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Grief Burner – Post-burn completion screen with Ayah reveal.
class GriefCompletionScreen extends StatelessWidget {
  const GriefCompletionScreen({super.key});

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

                // ── Peace icon ──
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.palette.primaryFixed.withValues(alpha: 0.3),
                  ),
                  child: Icon(Icons.spa, size: 40, color: context.palette.primary),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Arabic verse ──
                Text(
                  AppStrings.postBurnArabic,
                  style: AppTypography.arabicVerse(context).copyWith(
                    color: context.palette.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── English translation ──
                Text(
                  AppStrings.postBurnEnglish,
                  style: AppTypography.bodyLarge(context).copyWith(
                    fontStyle: FontStyle.italic,
                    color: context.palette.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.postBurnReference,
                  style: AppTypography.labelSmall(context),
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
}

