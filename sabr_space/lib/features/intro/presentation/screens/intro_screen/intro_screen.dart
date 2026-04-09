import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/intro/presentation/widgets/sanctuary_logo.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Intro / Landing screen — branding, tagline, and "Begin Your Journey" CTA.
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

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
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ── Logo + lavender glow (intro only) ──
              SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 248,
                      height: 248,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            context.palette.primary.withValues(alpha: 0.22),
                            context.palette.primaryFixedDim.withValues(alpha: 0.14),
                            context.palette.primaryContainer.withValues(alpha: 0.06),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 0.65, 1.0],
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.palette.primaryContainer.withValues(
                              alpha: 0.5,
                            ),
                            blurRadius: 44,
                            spreadRadius: 6,
                          ),
                          BoxShadow(
                            color: context.palette.primaryFixed.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 24,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SanctuaryLogo(
                      size: 180,
                      showDropShadow: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.jumbo),

              // ── App name ──
              Text(
                AppStrings.appName,
                style: AppTypography.headlineLarge(context).copyWith(
                  color: context.palette.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Tagline ──
              Text(
                AppStrings.tagline,
                style: AppTypography.bodyLarge(context).copyWith(
                  color: context.palette.onSurfaceVariant,
                ),
              ),

              const Spacer(flex: 4),

              // ── CTA button ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                child: GradientButton(
                  text: AppStrings.beginJourney,
                  onPressed: () => context.go('/login'),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Footer ──
              Text(
                'Embrace patience. Find peace.',
                style: AppTypography.bodySmall(context).copyWith(
                  color: context.palette.outline,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
