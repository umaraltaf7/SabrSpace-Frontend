import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Grief Burner – Post-burn completion screen with Ayah reveal.
class GriefCompletionScreen extends StatelessWidget {
  const GriefCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _CP.darkBgBottom : _CP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_CP.darkBgTop, _CP.darkBgBottom]
                : const [_CP.lightBgTop, _CP.lightBgBottom],
          ),
        ),
        child: Stack(
          children: [
            // Subtle sparkle field behind content
            Positioned.fill(
              child: CustomPaint(
                painter: _CelestialFieldPainter(isDark: isDark),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ScreenBackButton(
                          iconColor: isDark
                              ? _CP.darkAccent
                              : _CP.lightAccent,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(flex: 2),

                    // ── Peace orb with glow ──
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark
                              ? const [
                                  _CP.darkOrbTop,
                                  _CP.darkOrbBottom,
                                ]
                              : const [
                                  _CP.lightOrbTop,
                                  _CP.lightOrbBottom,
                                ],
                        ),
                        border: Border.all(
                          color: isDark
                              ? _CP.darkAccentSoft.withOpacity(0.62)
                              : Colors.white.withOpacity(0.84),
                          width: 2.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? _CP.darkAccent.withOpacity(0.50)
                                : _CP.lightAccent.withOpacity(0.36),
                            blurRadius: 32,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: isDark
                                ? _CP.darkAccentSoft.withOpacity(0.32)
                                : _CP.lightAccentSoft.withOpacity(0.34),
                            blurRadius: 56,
                            spreadRadius: 18,
                          ),
                          if (isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                        ],
                      ),
                      child: const Icon(
                        Icons.spa,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // ── Ayah card (frosted glass) ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.xl,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  _CP.darkSurfaceElevated
                                      .withOpacity(0.85),
                                  _CP.darkSurface.withOpacity(0.70),
                                ]
                              : [
                                  _CP.lightSurfaceSoft.withOpacity(0.72),
                                  _CP.lightSurface.withOpacity(0.80),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark
                              ? _CP.darkBorder.withOpacity(0.38)
                              : _CP.lightBorder.withOpacity(0.72),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? _CP.darkShadow.withOpacity(0.42)
                                : _CP.lightShadow.withOpacity(0.28),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            AppStrings.postBurnArabic,
                            style: AppTypography.arabicVerse(context)
                                .copyWith(
                              color: isDark
                                  ? Colors.white
                                  : _CP.lightAccent,
                              shadows: isDark
                                  ? [
                                      Shadow(
                                        color: _CP.darkAccentSoft
                                            .withOpacity(0.36),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            AppStrings.postBurnEnglish,
                            style: AppTypography.bodyLarge(context)
                                .copyWith(
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? _CP.darkTextSecondary
                                  : _CP.lightTextSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            AppStrings.postBurnReference,
                            style: AppTypography.labelSmall(context)
                                .copyWith(
                              color: isDark
                                  ? _CP.darkTextSecondary
                                      .withOpacity(0.60)
                                  : _CP.lightTextSecondary
                                      .withOpacity(0.60),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ── Return button ──
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? const [
                                    _CP.darkAccent,
                                    _CP.darkAccentSoft,
                                  ]
                                : const [
                                    _CP.lightAccent,
                                    _CP.lightOrbTop,
                                  ],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _CP.darkAccent.withOpacity(0.40)
                                  : _CP.lightAccent.withOpacity(0.36),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: isDark
                                  ? _CP.darkAccentSoft.withOpacity(0.22)
                                  : _CP.lightAccentSoft
                                      .withOpacity(0.28),
                              blurRadius: 40,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusFull,
                            ),
                          ),
                          child: Text(
                            'Return to Home',
                            style: AppTypography.labelLarge(context)
                                .copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Celestial sparkle field — scattered stars and soft glowing dots
// ─────────────────────────────────────────────────────────────────────────────

class _CelestialFieldPainter extends CustomPainter {
  final bool isDark;
  _CelestialFieldPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(77);

    final starColor = isDark
        ? Colors.white.withOpacity(0.70)
        : Colors.white.withOpacity(0.80);
    final warmColor = isDark
        ? const Color(0xFFF8DEAA).withOpacity(0.80)
        : const Color(0xFFF9EACB).withOpacity(0.75);

    // Sparkle stars
    for (int i = 0; i < 5; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.55;
      final r = rng.nextDouble() * 2.5 + 2.0;
      final color = i % 3 == 0 ? warmColor : starColor;
      _drawSparkle(canvas, Offset(x, y), r, color);
    }

    // Tiny dot stars
    final dotColor = isDark
        ? Colors.white.withOpacity(0.36)
        : _CP.lightBorder.withOpacity(0.30);

    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.70;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.2 + 0.3,
        Paint()..color = dotColor,
      );
    }
  }

  void _drawSparkle(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(
      c,
      r * 2.5,
      Paint()
        ..color = color.withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
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
  bool shouldRepaint(covariant _CelestialFieldPainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _CP {
  // ── Light mode ──
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);

  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);

  static const Color lightBorder = Color(0xFFBC95D8);

  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  static const Color lightShadow = Color(0xFF6F39AF);

  // ── Dark mode ──
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);

  static const Color darkShadow = Color(0xFF0C0515);
}

