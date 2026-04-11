import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Breathe session completion screen.
class BreatheCompletionScreen extends StatelessWidget {
  const BreatheCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _BreatheCompletionPalette.darkBackgroundTop,
                    _BreatheCompletionPalette.darkBackgroundBottom,
                  ]
                : const [
                    _BreatheCompletionPalette.lightBackgroundTop,
                    _BreatheCompletionPalette.lightBackgroundBottom,
                  ],
          ),
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

                Container(
                  width: 250,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [
                              _BreatheCompletionPalette.darkCardTop,
                              _BreatheCompletionPalette.darkCardBottom,
                            ]
                          : const [
                              _BreatheCompletionPalette.lightCardTop,
                              _BreatheCompletionPalette.lightCardBottom,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? _BreatheCompletionPalette.darkShadow
                                    : _BreatheCompletionPalette.lightShadow)
                                .withValues(alpha: 0.42),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _CompletionDecorPainter(isDark: isDark),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 106,
                            height: 106,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: isDark ? 0.16 : 0.24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.55),
                                width: 1.8,
                              ),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                Text(
                  AppStrings.sessionComplete,
                  style: AppTypography.headlineLarge(context).copyWith(
                    color: isDark
                        ? _BreatheCompletionPalette.darkTextPrimary
                        : _BreatheCompletionPalette.lightTextPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'You completed 33 dhikr.\nMay your heart find tranquility.',
                  style: AppTypography.bodyLarge(context).copyWith(
                    color: isDark
                        ? _BreatheCompletionPalette.darkTextSecondary
                        : _BreatheCompletionPalette.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Stats row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statChip(context, 'Duration', '2:34'),
                    const SizedBox(width: AppSpacing.xxl),
                    _statChip(context, 'Dhikr', '33'),
                  ],
                ),

                const Spacer(flex: 3),

                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => context.go('/home'),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.lg,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? const [
                                    _BreatheCompletionPalette.darkSurfaceElevated,
                                    _BreatheCompletionPalette.darkSurface,
                                  ]
                                : const [
                                    _BreatheCompletionPalette.lightSurface,
                                    _BreatheCompletionPalette.lightSurfaceSoft,
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? _BreatheCompletionPalette.darkBorder.withValues(alpha: 0.45)
                                : _BreatheCompletionPalette.lightBorder.withValues(alpha: 0.55),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _BreatheCompletionPalette.darkShadow.withValues(alpha: 0.40)
                                  : _BreatheCompletionPalette.lightShadow.withValues(alpha: 0.24),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Return to Home',
                              style: AppTypography.titleSmall(context).copyWith(
                                color: isDark
                                    ? _BreatheCompletionPalette.darkTextPrimary
                                    : _BreatheCompletionPalette.lightTextPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: isDark
                                  ? _BreatheCompletionPalette.darkTextSecondary
                                  : _BreatheCompletionPalette.lightTextSecondary,
                              size: 20,
                            ),
                          ],
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
      ),
    );
  }

  Widget _statChip(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? _BreatheCompletionPalette.darkSurface
            : _BreatheCompletionPalette.lightSurface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: isDark
              ? _BreatheCompletionPalette.darkBorder.withValues(alpha: 0.45)
              : _BreatheCompletionPalette.lightBorder.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.headlineSmall(context).copyWith(
            color: isDark
                ? _BreatheCompletionPalette.darkAccentSoft
                : _BreatheCompletionPalette.lightAccent,
          )),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelSmall(context).copyWith(
              color: isDark
                  ? _BreatheCompletionPalette.darkTextSecondary
                  : _BreatheCompletionPalette.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionDecorPainter extends CustomPainter {
  _CompletionDecorPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final star = Paint()..color = Colors.white.withValues(alpha: isDark ? 0.58 : 0.74);
    for (final p in <Offset>[
      Offset(size.width * 0.14, size.height * 0.14),
      Offset(size.width * 0.26, size.height * 0.20),
      Offset(size.width * 0.82, size.height * 0.18),
      Offset(size.width * 0.72, size.height * 0.10),
      Offset(size.width * 0.20, size.height * 0.76),
      Offset(size.width * 0.82, size.height * 0.78),
    ]) {
      canvas.drawCircle(p, 1.4, star);
    }

    final wind = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.24 : 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.34)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.22,
        size.width * 0.60,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.42,
        size.width * 0.92,
        size.height * 0.34,
      );
    canvas.drawPath(path, wind);
  }

  @override
  bool shouldRepaint(covariant _CompletionDecorPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _BreatheCompletionPalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFF1E4FB);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);

  static const Color lightSurface = Color(0xFFECE1FA);
  static const Color lightSurfaceSoft = Color(0xFFF3E9FF);
  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
}

