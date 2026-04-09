import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Large, soft **golden** radial wash behind the whole burn scene (full screen).
///
/// Sits under [BurnGlowPainter], envelope, and particles so it reads as
/// background firelight—not the orange edge band.
class GoldenBurnAmbientPainter extends CustomPainter {
  GoldenBurnAmbientPainter({
    required this.intensity,
    required this.center,
  });

  /// 0..1 — overall strength (sync with burn timeline).
  final double intensity;

  /// Typically screen center or slightly above (envelope hero position).
  final Offset center;

  static const Color _goldA = Color(0xFFFFB300);
  static const Color _goldB = Color(0xFFFFD54F);
  static const Color _amberDeep = Color(0xFFFF8F00);

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0.01) return;

    final a = intensity.clamp(0.0, 1.0);
    final r = math.min(size.width, size.height) * 0.62;

    // Wide warm halo
    final halo = Paint()
      ..shader = ui.Gradient.radial(
        center,
        r,
        [
          _goldB.withValues(alpha: 0.22 * a),
          _goldA.withValues(alpha: 0.14 * a),
          _amberDeep.withValues(alpha: 0.06 * a),
          Colors.transparent,
        ],
        const [0.0, 0.35, 0.65, 1.0],
      );
    canvas.drawCircle(center, r, halo);

    // Tighter bright core (subtle “ember” behind envelope)
    final core = Paint()
      ..shader = ui.Gradient.radial(
        center,
        r * 0.38,
        [
          const Color(0xFFFFF8E1).withValues(alpha: 0.18 * a),
          _goldB.withValues(alpha: 0.12 * a),
          Colors.transparent,
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(center, r * 0.38, core);
  }

  @override
  bool shouldRepaint(covariant GoldenBurnAmbientPainter oldDelegate) =>
      oldDelegate.intensity != intensity || oldDelegate.center != center;
}

/// Paints a soft amber/orange glow band along the current burn edge.
///
/// The glow tracks [burnProgress] (0 = bottom, 1 = top) and fades with
/// [intensity]. It also draws a subtle ambient background glow that
/// illuminates the dark background with warm firelight.
class BurnGlowPainter extends CustomPainter {
  BurnGlowPainter({
    required this.burnProgress,
    required this.intensity,
    required this.envelopeRect,
  });

  /// 0..1 — where the burn edge is.
  final double burnProgress;

  /// 0..1 — overall glow strength.
  final double intensity;

  /// Envelope bounds in local coordinates.
  final Rect envelopeRect;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0.01 || envelopeRect.isEmpty) return;

    final edgeY =
        envelopeRect.bottom - (burnProgress * envelopeRect.height);
    final centerX = envelopeRect.center.dx;
    final halfW = envelopeRect.width * 0.55;

    // ── Ambient background glow ──────────────────────────────
    final ambientPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(centerX, edgeY),
        envelopeRect.width * 0.8,
        [
          const Color(0xFFFF6B35).withValues(alpha: intensity * 0.12),
          const Color(0xFFFF6B35).withValues(alpha: 0),
        ],
      );
    canvas.drawCircle(
      Offset(centerX, edgeY),
      envelopeRect.width * 0.8,
      ambientPaint,
    );

    // ── Edge glow line ───────────────────────────────────────
    final glowPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(centerX - halfW, edgeY),
        Offset(centerX + halfW, edgeY),
        [
          const Color(0xFFFF4500).withValues(alpha: 0),
          const Color(0xFFFF6B35).withValues(alpha: intensity * 0.7),
          const Color(0xFFFFD60A).withValues(alpha: intensity * 0.9),
          const Color(0xFFFF6B35).withValues(alpha: intensity * 0.7),
          const Color(0xFFFF4500).withValues(alpha: 0),
        ],
        [0.0, 0.15, 0.5, 0.85, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..strokeWidth = 6 + intensity * 6
      ..style = PaintingStyle.stroke;

    // Slight wave distortion for organic feel
    final path = Path();
    const segments = 20;
    final rng = math.Random(42); // deterministic seed for consistency
    for (var i = 0; i <= segments; i++) {
      final frac = i / segments;
      final x = (centerX - halfW) + frac * halfW * 2;
      final yOffset =
          math.sin(frac * math.pi * 3 + burnProgress * 8) * 3.0 +
              (rng.nextDouble() - 0.5) * 2;
      if (i == 0) {
        path.moveTo(x, edgeY + yOffset);
      } else {
        path.lineTo(x, edgeY + yOffset);
      }
    }
    canvas.drawPath(path, glowPaint);

    // ── Bright core at center of edge ────────────────────────
    final corePaint = Paint()
      ..color = const Color(0xFFFFE8A0).withValues(alpha: intensity * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(
      Offset(centerX, edgeY),
      18 + intensity * 8,
      corePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BurnGlowPainter oldDelegate) =>
      oldDelegate.burnProgress != burnProgress ||
      oldDelegate.intensity != intensity;
}
