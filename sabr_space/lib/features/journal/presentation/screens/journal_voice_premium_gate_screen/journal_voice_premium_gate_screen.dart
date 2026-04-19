import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Shown when the user taps the journal voice (mic) control — explains premium gating.
class JournalVoicePremiumGateScreen extends StatelessWidget {
  const JournalVoicePremiumGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: palette.surfaceContainerLow,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.etherealGradientStart,
              palette.etherealGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ScreenBackButton(
                    iconColor: isDark ? palette.breatheAccent : palette.primary,
                    backgroundColor: palette.surface.withValues(alpha: 0.88),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: palette.outlineVariant.withValues(alpha: 0.45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.primary.withValues(
                          alpha: isDark ? 0.14 : 0.10,
                        ),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.primaryContainer.withValues(
                            alpha: 0.45,
                          ),
                          border: Border.all(
                            color: palette.primary.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.mic_none_rounded,
                              size: 32,
                              color: palette.primary,
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                size: 22,
                                color: palette.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        AppStrings.voiceJournalPremiumTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: palette.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AppStrings.voiceJournalPremiumDescription,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: palette.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () => context.push('/premium'),
                          style: FilledButton.styleFrom(
                            backgroundColor: palette.primary,
                            foregroundColor: palette.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Text(
                            AppStrings.upgradeForFullAccess,
                            style: AppTypography.labelLarge(context).copyWith(
                              color: palette.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          AppStrings.maybeLater,
                          style: AppTypography.labelLarge(context).copyWith(
                            color: palette.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
