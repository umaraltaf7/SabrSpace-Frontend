import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _MSP.darkBgBottom : _MSP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_MSP.darkBgTop, _MSP.darkBgBottom]
                : const [_MSP.lightBgTop, _MSP.lightBgBottom],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _CelebrationSparklesPainter(isDark: isDark),
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
                              ? _MSP.darkAccent
                              : _MSP.lightAccent,
                        ),
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
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? const [
                                    _MSP.darkOrbTop,
                                    _MSP.darkOrbBottom,
                                  ]
                                : const [
                                    _MSP.lightOrbTop,
                                    _MSP.lightOrbBottom,
                                  ],
                          ),
                          border: Border.all(
                            color: isDark
                                ? _MSP.darkAccentSoft.withOpacity(0.62)
                                : Colors.white.withOpacity(0.84),
                            width: 2.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _MSP.darkGold.withOpacity(0.40)
                                  : _MSP.lightGold.withOpacity(0.36),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                            BoxShadow(
                              color: isDark
                                  ? _MSP.darkAccent.withOpacity(0.30)
                                  : _MSP.lightAccent.withOpacity(0.24),
                              blurRadius: 56,
                              spreadRadius: 16,
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
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 36,
                              color: _MSP.lightGold,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '100',
                              style: AppTypography.titleLarge(context)
                                  .copyWith(
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
                      style: AppTypography.headlineMedium(context)
                          .copyWith(
                        color: isDark
                            ? _MSP.darkTextPrimary
                            : _MSP.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.milestoneSubtitle,
                      style:
                          AppTypography.bodyMedium(context).copyWith(
                        color: isDark
                            ? _MSP.darkTextSecondary
                            : _MSP.lightTextSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // ── Quote card ──
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  _MSP.darkSurfaceElevated
                                      .withOpacity(0.85),
                                  _MSP.darkSurface.withOpacity(0.70),
                                ]
                              : [
                                  _MSP.lightSurfaceSoft
                                      .withOpacity(0.72),
                                  _MSP.lightSurface.withOpacity(0.80),
                                ],
                        ),
                        borderRadius: AppSpacing.borderRadiusXl,
                        border: Border.all(
                          color: isDark
                              ? _MSP.darkBorder.withOpacity(0.38)
                              : _MSP.lightBorder.withOpacity(0.72),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? _MSP.darkShadow.withOpacity(0.42)
                                : _MSP.lightShadow.withOpacity(0.28),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Text(
                        AppStrings.milestoneQuote,
                        style: AppTypography.bodyMedium(context)
                            .copyWith(
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? _MSP.darkTextSecondary
                              : _MSP.lightTextSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ── Continue button ──
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
                                    _MSP.darkAccent,
                                    _MSP.darkAccentSoft,
                                  ]
                                : const [
                                    _MSP.lightAccent,
                                    _MSP.lightOrbTop,
                                  ],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _MSP.darkAccent.withOpacity(0.40)
                                  : _MSP.lightAccent.withOpacity(0.36),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: isDark
                                  ? _MSP.darkAccentSoft
                                      .withOpacity(0.22)
                                  : _MSP.lightAccentSoft
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
                              borderRadius:
                                  AppSpacing.borderRadiusFull,
                            ),
                          ),
                          child: Text(
                            'Continue',
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
// Celebration sparkles — gold + purple sparkles scattered behind content
// ─────────────────────────────────────────────────────────────────────────────

class _CelebrationSparklesPainter extends CustomPainter {
  final bool isDark;
  _CelebrationSparklesPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(99);
    final gold = isDark
        ? const Color(0xFFF8DEAA).withOpacity(0.90)
        : const Color(0xFFF2D28A).withOpacity(0.85);
    final starColor = isDark
        ? Colors.white.withOpacity(0.72)
        : Colors.white.withOpacity(0.80);

    for (int i = 0; i < 7; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.60;
      final r = rng.nextDouble() * 3.0 + 2.0;
      final color = i % 2 == 0 ? gold : starColor;
      _drawSparkle(canvas, Offset(x, y), r, color);
    }

    final dotColor = isDark
        ? Colors.white.withOpacity(0.30)
        : _MSP.lightBorder.withOpacity(0.26);
    for (int i = 0; i < 20; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.75;
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
        ..color = color.withOpacity(0.22)
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
  bool shouldRepaint(covariant _CelebrationSparklesPainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _MSP {
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

