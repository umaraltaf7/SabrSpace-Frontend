import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// Circular panic CTA: dark disc, gold warning mark, white “PANIC”, warm radial glow.
class PanicButton extends StatelessWidget {
  const PanicButton({
    super.key,
    required this.onPressed,
    this.diameter = 120,
  });

  final VoidCallback onPressed;
  final double diameter;

  static const Color _buttonFill = Color(0xFF2C2C3E);
  static const Color _triangleGold = Color(0xFFFFD60A);
  static const Color _glowGold = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    final glowPad = diameter * 0.42;
    return SizedBox(
      width: diameter + glowPad * 2,
      height: diameter + glowPad * 2,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Soft golden bloom behind the disc
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _glowGold.withValues(alpha: 0.42),
                      _glowGold.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                    stops: const [0.35, 0.65, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Extra diffuse shadow ring
          Container(
            width: diameter + 24,
            height: diameter + 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _glowGold.withValues(alpha: 0.38),
                  blurRadius: 36,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: const Color(0xFFFF8F00).withValues(alpha: 0.22),
                  blurRadius: 52,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          Material(
            color: _buttonFill,
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 0.45),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              splashColor: _glowGold.withValues(alpha: 0.15),
              highlightColor: _glowGold.withValues(alpha: 0.08),
              child: SizedBox(
                width: diameter,
                height: diameter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 46,
                      height: 42,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          CustomPaint(
                            size: const Size(46, 42),
                            painter: _WarningTrianglePainter(color: _triangleGold),
                          ),
                          Transform.translate(
                            offset: const Offset(0, 3),
                            child: Text(
                              '!',
                              style: AppTypography.headlineSmall(context).copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                height: 1,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.panicLabel,
                      style: AppTypography.labelMedium(context).copyWith(
                        color: Colors.white,
                        letterSpacing: 3.2,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningTrianglePainter extends CustomPainter {
  _WarningTrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _WarningTrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
