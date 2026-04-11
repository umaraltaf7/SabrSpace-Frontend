import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Mood support hub — reflection, practice, and connection cards.
///
/// Opened from [SupportiveAyahVersesScreen] via "Need further support?".
class MoodFurtherSupportScreen extends StatelessWidget {
  const MoodFurtherSupportScreen({super.key});

  static const double _cardRadius = 26;
  static const double _maxContentWidth = 520;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontal = _horizontalPadding(media.size.width);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SoftSupportBackground(),
          SafeArea(
            child: Column(
              children: [
                // ── Top bar (pinned at top) ──
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal, AppSpacing.md, horizontal, 0,
                  ),
                  child: Row(
                    children: [
                      const ScreenBackButton(),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          AppStrings.moodFurtherSupportTitle,
                          style: AppTypography.headlineSmall(context).copyWith(
                            color: context.palette.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Scrollable cards (centered vertically) ──
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxW = math.min(
                        constraints.maxWidth - 2 * horizontal,
                        _maxContentWidth,
                      );
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          AppSpacing.lg,
                          horizontal,
                          AppSpacing.xxl + media.padding.bottom,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - AppSpacing.lg - AppSpacing.xxl - media.padding.bottom,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxW),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                          _SupportActionCard(
                            radius: _cardRadius,
                            category: AppStrings.supportCategoryReflection,
                            title: AppStrings.supportCardQuotesTitle,
                            subtitle: AppStrings.supportCardQuotesSubtitle,
                            icon: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.18),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '\u201D',
                                style: AppTypography.headlineMedium(context).copyWith(
                                  color: Colors.white,
                                  height: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            onTap: () => context.push('/ayah-carousel'),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _SupportActionCard(
                            radius: _cardRadius,
                            category: AppStrings.supportCategoryPractice,
                            title: AppStrings.supportCardBreatheTitle,
                            subtitle: AppStrings.supportCardBreatheSubtitle,
                            bottomHint: Icon(
                              Icons.chevron_right_rounded,
                              size: 22,
                              color: Colors.white.withOpacity(0.50),
                            ),
                            leadingIcon: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.18),
                              ),
                              child: const Icon(
                                Icons.spa_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            onTap: () => context.push('/breathe'),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _SupportActionCard(
                            radius: _cardRadius,
                            category: AppStrings.supportCategoryConnection,
                            title: AppStrings.supportCardCallTitle,
                            subtitle: AppStrings.supportCardCallSubtitle,
                            trailingAccent: Icon(
                              Icons.favorite_border_rounded,
                              size: 22,
                              color: Colors.white.withOpacity(0.55),
                            ),
                            leadingIcon: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.18),
                              ),
                              child: const Icon(
                                Icons.phone_in_talk_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppStrings.supportCallFriendHint,
                                    style: AppTypography.bodyMedium(context).copyWith(
                                      color: context.palette.onPrimary,
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: context.palette.primary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.xxxl),
                          _SupportFooterLine(),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            AppStrings.supportHubFooter,
                            style: AppTypography.bodyMedium(context).copyWith(
                              color: context.palette.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                                const SizedBox(height: AppSpacing.xl),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _horizontalPadding(double width) {
    if (width >= 900) return 48;
    if (width >= 600) return AppSpacing.xxl * 1.25;
    return AppSpacing.xxl;
  }
}

class _SoftSupportBackground extends StatelessWidget {
  const _SoftSupportBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  _PanicPalette.darkBackgroundTop,
                  _PanicPalette.darkBackgroundMid,
                  _PanicPalette.darkBackgroundBottom,
                ]
              : const [
                  _PanicPalette.lightBackgroundTop,
                  _PanicPalette.lightBackgroundMid,
                  _PanicPalette.lightBackgroundBottom,
                ],
          stops: const [0.0, 0.48, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _orb(240, context.palette.primaryFixed.withValues(alpha: 0.28)),
          ),
          Positioned(
            top: 180,
            left: -100,
            child: _orb(260, context.palette.primaryFixedDim.withValues(alpha: 0.16)),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: _orb(200, context.palette.primaryFixed.withValues(alpha: 0.20)),
          ),
          Positioned(
            bottom: 120,
            left: -50,
            child: _orb(180, context.palette.primaryFixedDim.withValues(alpha: 0.14)),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({
    required this.radius,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.leadingIcon,
    this.bottomHint,
    this.trailingAccent,
  });

  final double radius;
  final String category;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? icon;
  final Widget? leadingIcon;
  final Widget? bottomHint;
  final Widget? trailingAccent;

  @override
  Widget build(BuildContext context) {
    final textColumn = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: AppTypography.labelSmall(context).copyWith(
              color: const Color(0xFFE0C8F0),
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.titleMedium(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.bodyMedium(context).copyWith(
              color: Colors.white.withOpacity(0.85),
              height: 1.45,
            ),
          ),
          if (bottomHint != null) ...[
            const SizedBox(height: AppSpacing.md),
            bottomHint!,
          ],
        ],
      ),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [
                      _PanicPalette.darkCardTop,
                      _PanicPalette.darkCardBottom,
                    ]
                  : const [
                      _PanicPalette.lightCardTop,
                      _PanicPalette.lightCardBottom,
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? _PanicPalette.darkShadow.withOpacity(0.56)
                    : _PanicPalette.lightShadow.withOpacity(0.30),
                blurRadius: 28,
                offset: const Offset(0, 10),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textColumn,
                      const SizedBox(width: AppSpacing.md),
                      icon!,
                    ],
                  )
                else if (leadingIcon != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leadingIcon!,
                      const SizedBox(width: AppSpacing.lg),
                      textColumn,
                      if (trailingAccent != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: trailingAccent!,
                        ),
                      ],
                    ],
                  )
                else
                  Row(children: [textColumn]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportFooterLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: context.palette.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.palette.secondaryFixedDim,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: context.palette.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _PanicPalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundMid = Color(0xFFF7EEFF);
  static const Color lightBackgroundBottom = Color(0xFFF1E4FB);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundMid = Color(0xFF40204F);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);
  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);
  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
}
