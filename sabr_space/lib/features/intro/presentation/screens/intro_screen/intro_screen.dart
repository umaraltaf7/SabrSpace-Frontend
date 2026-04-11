import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/intro/presentation/widgets/sanctuary_logo.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Intro / Landing screen — branding, tagline, and "Begin Your Journey" CTA.
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _IP.darkBgBottom : _IP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_IP.darkBgTop, _IP.darkBgBottom]
                : const [_IP.lightBgTop, _IP.lightBgBottom],
          ),
        ),
        child: Stack(
          children: [
            // Ambient sparkle field
            Positioned.fill(
              child: CustomPaint(
                painter: _IntroStarFieldPainter(isDark: isDark),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // ── Logo with glowing orb ──
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Outer glow ring
                        Container(
                          width: 248,
                          height: 248,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: isDark
                                  ? [
                                      _IP.darkAccent.withOpacity(0.18),
                                      _IP.darkOrbTop.withOpacity(0.10),
                                      _IP.darkOrbBottom.withOpacity(0.04),
                                      Colors.transparent,
                                    ]
                                  : [
                                      _IP.lightAccent.withOpacity(0.20),
                                      _IP.lightOrbTop.withOpacity(0.12),
                                      _IP.lightOrbBottom.withOpacity(0.06),
                                      Colors.transparent,
                                    ],
                              stops: const [0.0, 0.35, 0.65, 1.0],
                            ),
                          ),
                        ),
                        // Inner glow
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? _IP.darkAccent.withOpacity(0.36)
                                    : _IP.lightAccent.withOpacity(0.30),
                                blurRadius: 44,
                                spreadRadius: 6,
                              ),
                              BoxShadow(
                                color: isDark
                                    ? _IP.darkAccentSoft.withOpacity(0.20)
                                    : _IP.lightAccentSoft.withOpacity(0.24),
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
                      color: isDark
                          ? _IP.darkTextPrimary
                          : _IP.lightAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Tagline ──
                  Text(
                    AppStrings.tagline,
                    style: AppTypography.bodyLarge(context).copyWith(
                      color: isDark
                          ? _IP.darkTextSecondary
                          : _IP.lightTextSecondary,
                    ),
                  ),

                  const Spacer(flex: 4),

                  // ── CTA button ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxxl),
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
                      color: isDark
                          ? _IP.darkTextSecondary.withOpacity(0.60)
                          : _IP.lightTextSecondary.withOpacity(0.66),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ambient star field — tiny dots and soft sparkles on the intro backdrop
// ─────────────────────────────────────────────────────────────────────────────

class _IntroStarFieldPainter extends CustomPainter {
  final bool isDark;
  _IntroStarFieldPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(77);
    final dotColor = isDark
        ? Colors.white.withOpacity(0.26)
        : _IP.lightBorder.withOpacity(0.22);
    final starColor = isDark
        ? Colors.white.withOpacity(0.58)
        : Colors.white.withOpacity(0.68);

    for (int i = 0; i < 28; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.3 + 0.3,
        Paint()..color = dotColor,
      );
    }

    for (int i = 0; i < 5; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.55;
      final r = rng.nextDouble() * 2.8 + 1.8;
      _drawSparkle(canvas, Offset(x, y), r, starColor);
    }
  }

  void _drawSparkle(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(
      c,
      r * 2.2,
      Paint()
        ..color = color.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + r * 0.15, c.dy - r * 0.15)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx + r * 0.15, c.dy + r * 0.15)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - r * 0.15, c.dy + r * 0.15)
      ..lineTo(c.dx - r, c.dy)
      ..lineTo(c.dx - r * 0.15, c.dy - r * 0.15)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _IntroStarFieldPainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _IP {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);
  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);
  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);
}
