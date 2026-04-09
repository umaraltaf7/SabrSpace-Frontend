import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Milestone Celebration screen — "MashaAllah, 100 days of calm."
class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({super.key});

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _celebrateController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _celebrateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _celebrateController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _celebrateController.dispose();
    super.dispose();
  }

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

                // ── Celebration badge ──
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppGradients.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: context.palette.secondaryFixedDim.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.emoji_events, size: 36, color: Colors.white),
                        const SizedBox(height: 4),
                        Text(
                          '100',
                          style: AppTypography.titleLarge(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                Text(
                  AppStrings.milestoneCongrats,
                  style: AppTypography.headlineMedium(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.milestoneSubtitle,
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: context.palette.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Quote ──
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: context.palette.surfaceContainerLowest,
                    borderRadius: AppSpacing.borderRadiusXl,
                  ),
                  child: Text(
                    AppStrings.milestoneQuote,
                    style: AppTypography.bodyMedium(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.palette.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(flex: 3),

                GradientButton(
                  text: 'Continue',
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

