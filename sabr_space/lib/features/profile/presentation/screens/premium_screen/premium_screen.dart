import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Upgrade to Premium paywall screen.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ── Top bar ──
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Row(
                    children: [
                      const ScreenBackButton(),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.goldGradient,
                          boxShadow: [
                            BoxShadow(
                              color: context.palette.secondaryFixedDim.withValues(alpha: 0.3),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.diamond, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        AppStrings.upgradeToPremium,
                        style: AppTypography.headlineMedium(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AppStrings.experienceSpiritualDepth,
                        style: AppTypography.titleMedium(context).copyWith(
                          color: context.palette.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Text(
                          AppStrings.premiumDescription,
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: context.palette.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Plans ──
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Column(
                    children: [
                      _planCard(
                        context,
                        title: AppStrings.monthlyPlan,
                        price: '\$4.99/mo',
                        description: AppStrings.monthlyDesc,
                        isPopular: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _planCard(
                        context,
                        title: AppStrings.yearlyPlan,
                        price: '\$39.99/yr',
                        description: AppStrings.yearlyDesc,
                        isPopular: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Benefits ──
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exclusive Benefits',
                        style: AppTypography.titleMedium(context),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _benefitItem(
                        context,
                        Icons.all_inclusive,
                        'Unlimited Dhikr & Breathing Sessions',
                        'Never break your focus with uncapped sessions.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _benefitItem(
                        context,
                        Icons.auto_stories,
                        'Exclusive Quotes & Ayahs',
                        'Daily hand-picked wisdom for your journey.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _benefitItem(
                        context,
                        Icons.emoji_events,
                        'Milestone Celebrations & Streak Boosts',
                        'Motivation designed to help you stay consistent.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Footer quote ──
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.jumbo),
                  child: Text(
                    '"Allah does not burden a soul beyond that it can bear."',
                    style: AppTypography.bodySmall(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.palette.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required String title,
    required String price,
    required String description,
    required bool isPopular,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isPopular ? null : context.palette.surfaceContainerLowest,
          gradient:
              isPopular ? AppGradients.primaryGradient(context) : null,
          borderRadius: AppSpacing.borderRadiusXl,
          boxShadow: [
            BoxShadow(
              color: (isPopular ? context.palette.primary : context.palette.onSurface)
                  .withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium(context).copyWith(
                    color: isPopular ? Colors.white : context.palette.onSurface,
                  ),
                ),
                const Spacer(),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                    child: Text(
                      'BEST VALUE',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 9,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              price,
              style: AppTypography.headlineSmall(context).copyWith(
                color: isPopular ? Colors.white : context.palette.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTypography.bodySmall(context).copyWith(
                color: isPopular
                    ? Colors.white.withValues(alpha: 0.8)
                    : context.palette.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.palette.primaryFixed.withValues(alpha: 0.3),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Icon(icon, color: context.palette.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleSmall(context)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall(context).copyWith(
                  color: context.palette.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

