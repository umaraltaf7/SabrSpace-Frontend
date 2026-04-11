import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Upgrade to Premium paywall screen.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _PP.darkBgBottom : _PP.lightBgBottom,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_PP.darkBgTop, _PP.darkBgBottom]
                : const [_PP.lightBgTop, _PP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ── Top bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl),
                  child: Row(
                    children: [
                      ScreenBackButton(
                        iconColor:
                            isDark ? _PP.darkAccent : _PP.lightAccent,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? const [
                                    _PP.darkOrbTop,
                                    _PP.darkOrbBottom,
                                  ]
                                : const [
                                    _PP.lightOrbTop,
                                    _PP.lightOrbBottom,
                                  ],
                          ),
                          border: Border.all(
                            color: isDark
                                ? _PP.darkAccentSoft.withOpacity(0.60)
                                : Colors.white.withOpacity(0.80),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _PP.darkAccent.withOpacity(0.36)
                                  : _PP.lightAccent.withOpacity(0.30),
                              blurRadius: 28,
                              spreadRadius: 6,
                            ),
                            BoxShadow(
                              color: isDark
                                  ? _PP.darkGold.withOpacity(0.18)
                                  : _PP.lightGold.withOpacity(0.22),
                              blurRadius: 42,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.diamond,
                          color: _PP.lightGold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        AppStrings.upgradeToPremium,
                        style: AppTypography.headlineMedium(context)
                            .copyWith(
                          color: isDark
                              ? _PP.darkTextPrimary
                              : _PP.lightTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AppStrings.experienceSpiritualDepth,
                        style: AppTypography.titleMedium(context)
                            .copyWith(
                          color: isDark
                              ? _PP.darkTextSecondary
                              : _PP.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl),
                        child: Text(
                          AppStrings.premiumDescription,
                          style: AppTypography.bodyMedium(context)
                              .copyWith(
                            color: isDark
                                ? _PP.darkTextSecondary.withOpacity(0.72)
                                : _PP.lightTextSecondary
                                    .withOpacity(0.80),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl),
                  child: Column(
                    children: [
                      _planCard(
                        context,
                        isDark: isDark,
                        title: AppStrings.monthlyPlan,
                        price: '\$4.99/mo',
                        description: AppStrings.monthlyDesc,
                        isPopular: false,
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _planCard(
                        context,
                        isDark: isDark,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exclusive Benefits',
                        style:
                            AppTypography.titleMedium(context).copyWith(
                          color: isDark
                              ? _PP.darkTextPrimary
                              : _PP.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _benefitItem(
                        context,
                        isDark: isDark,
                        icon: Icons.all_inclusive,
                        title: 'Unlimited Dhikr & Breathing Sessions',
                        subtitle:
                            'Never break your focus with uncapped sessions.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _benefitItem(
                        context,
                        isDark: isDark,
                        icon: Icons.auto_stories,
                        title: 'Exclusive Quotes & Ayahs',
                        subtitle:
                            'Daily hand-picked wisdom for your journey.',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _benefitItem(
                        context,
                        isDark: isDark,
                        icon: Icons.emoji_events,
                        title: 'Milestone Celebrations & Streak Boosts',
                        subtitle:
                            'Motivation designed to help you stay consistent.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Separator ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.jumbo),
                  child: Container(
                    height: 1.2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                Colors.transparent,
                                _PP.darkAccent.withOpacity(0.38),
                                Colors.transparent,
                              ]
                            : [
                                Colors.transparent,
                                _PP.lightAccent.withOpacity(0.34),
                                Colors.transparent,
                              ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Footer quote ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.jumbo),
                  child: Text(
                    '"Allah does not burden a soul beyond that it can bear."',
                    style:
                        AppTypography.bodySmall(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? _PP.darkTextSecondary.withOpacity(0.68)
                          : _PP.lightTextSecondary.withOpacity(0.74),
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
    required bool isDark,
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
          gradient: isPopular
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [_PP.darkOrbTop, _PP.darkOrbBottom]
                      : const [_PP.lightOrbTop, _PP.lightOrbBottom],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          _PP.darkSurfaceElevated.withOpacity(0.80),
                          _PP.darkSurface.withOpacity(0.70),
                        ]
                      : [
                          _PP.lightSurfaceSoft.withOpacity(0.62),
                          _PP.lightSurface.withOpacity(0.74),
                        ],
                ),
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(
            color: isPopular
                ? (isDark
                    ? _PP.darkAccentSoft.withOpacity(0.52)
                    : Colors.white.withOpacity(0.70))
                : (isDark
                    ? _PP.darkBorder.withOpacity(0.30)
                    : _PP.lightBorder.withOpacity(0.58)),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isPopular
                  ? (isDark
                      ? _PP.darkAccent.withOpacity(0.32)
                      : _PP.lightAccent.withOpacity(0.28))
                  : (isDark
                      ? _PP.darkShadow.withOpacity(0.36)
                      : _PP.lightShadow.withOpacity(0.18)),
              blurRadius: 22,
              offset: const Offset(0, 6),
            ),
            if (isPopular)
              BoxShadow(
                color: isDark
                    ? _PP.darkAccentSoft.withOpacity(0.18)
                    : _PP.lightAccentSoft.withOpacity(0.20),
                blurRadius: 40,
                spreadRadius: 6,
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
                  style:
                      AppTypography.titleMedium(context).copyWith(
                    color: isPopular
                        ? Colors.white
                        : (isDark
                            ? _PP.darkTextPrimary
                            : _PP.lightTextPrimary),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: AppSpacing.borderRadiusFull,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.30),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      'BEST VALUE',
                      style: AppTypography.labelSmall(context)
                          .copyWith(
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
              style:
                  AppTypography.headlineSmall(context).copyWith(
                color: isPopular
                    ? Colors.white
                    : (isDark ? _PP.darkAccent : _PP.lightAccent),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTypography.bodySmall(context).copyWith(
                color: isPopular
                    ? Colors.white.withOpacity(0.82)
                    : (isDark
                        ? _PP.darkTextSecondary
                        : _PP.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      _PP.darkSurfaceElevated.withOpacity(0.86),
                      _PP.darkSurface.withOpacity(0.74),
                    ]
                  : [
                      _PP.lightSurfaceSoft.withOpacity(0.72),
                      _PP.lightSurface.withOpacity(0.80),
                    ],
            ),
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: isDark
                  ? _PP.darkBorder.withOpacity(0.24)
                  : _PP.lightBorder.withOpacity(0.46),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isDark ? _PP.darkAccent : _PP.lightAccent,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    AppTypography.titleSmall(context).copyWith(
                  color: isDark
                      ? _PP.darkTextPrimary
                      : _PP.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style:
                    AppTypography.bodySmall(context).copyWith(
                  color: isDark
                      ? _PP.darkTextSecondary
                      : _PP.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _PP {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);
  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);
  static const Color lightGold = Color(0xFFF2D28A);
  static const Color lightShadow = Color(0xFF6F39AF);

  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);
  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);
  static const Color darkBorder = Color(0xFFCC98E7);
  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);
  static const Color darkGold = Color(0xFFF2D28A);
  static const Color darkShadow = Color(0xFF0C0515);
}

