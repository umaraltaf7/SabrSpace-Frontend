import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/features/sanctuary/presentation/widgets/burn_glow_painter.dart';
import 'package:sabr_space/features/sanctuary/presentation/widgets/fire_particle_system.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENVELOPE ILLUSTRATION — vector CustomPaint (reusable stand-alone)
// ─────────────────────────────────────────────────────────────────────────────

/// Centered paper-style envelope (vector). Use as static preview or inside
/// [BurningEnvelopeAnimation].
class EnvelopeIllustration extends StatelessWidget {
  const EnvelopeIllustration({
    super.key,
    this.maxWidth = 220,
  });

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = math.min(maxWidth, constraints.maxWidth * 0.72);
        final h = w / 1.35;
        final p = context.palette;
        return SizedBox(
          width: w,
          height: h,
          child: CustomPaint(
            painter: _EnvelopePainter(
              paper: p.cream,
              onSurface: p.onSurface,
              tertiary: p.tertiary,
              primary: p.primary,
            ),
          ),
        );
      },
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  const _EnvelopePainter({
    required this.paper,
    required this.onSurface,
    required this.tertiary,
    required this.primary,
  });

  final Color paper;
  final Color onSurface;
  final Color tertiary;
  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, h * 0.22, w, h * 0.78),
      const Radius.circular(6),
    );

    final paperPaint = Paint()
      ..color = paper
      ..style = PaintingStyle.fill;
    final shadow = Paint()
      ..color = onSurface.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final stroke = Paint()
      ..color = tertiary.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final sealStroke = Paint()
      ..color = tertiary.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(body.shift(const Offset(0, 3)), shadow);
    canvas.drawRRect(body, paperPaint);
    canvas.drawRRect(body, stroke);

    // Top flap
    final flapPath = Path()
      ..moveTo(0, h * 0.22)
      ..lineTo(w * 0.5, h * 0.52)
      ..lineTo(w, h * 0.22)
      ..close();
    canvas.drawPath(
      flapPath,
      Paint()
        ..color = paper.withValues(alpha: 0.92)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(flapPath, stroke);

    // Inner fold line
    final innerFold = Path()
      ..moveTo(0, h * 0.22)
      ..lineTo(w * 0.5, h * 0.42)
      ..lineTo(w, h * 0.22);
    canvas.drawPath(
      innerFold,
      Paint()
        ..color = tertiary.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Wax seal
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.38),
      w * 0.065,
      Paint()..color = primary.withValues(alpha: 0.25),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.38),
      w * 0.065,
      sealStroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// BURNING ENVELOPE ANIMATION — the full burn sequence
// ─────────────────────────────────────────────────────────────────────────────

/// Full burn sequence: shake → dissolve with organic shader edge → fire
/// particles → glow → fade out.
///
/// Starts automatically on first frame. Call [onCompleted] when done.
class BurningEnvelopeAnimation extends StatefulWidget {
  const BurningEnvelopeAnimation({
    super.key,
    required this.onCompleted,
    this.duration = const Duration(milliseconds: 3200),
  });

  final VoidCallback onCompleted;
  final Duration duration;

  @override
  State<BurningEnvelopeAnimation> createState() =>
      _BurningEnvelopeAnimationState();
}

class _BurningEnvelopeAnimationState extends State<BurningEnvelopeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Timeline constants (fractions of total duration)
  static const double _shakeEnd = 0.12;
  static const double _burnStart = 0.10;
  static const double _burnEnd = 0.92;
  static const double _glowEnd = 0.88;
  static const double _fireStart = 0.10;
  static const double _fireEnd = 0.90;

  // Envelope sizing
  static const double _envelopeMaxW = 280.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Map a value from [inStart..inEnd] to [0..1], clamped.
  double _remap(double value, double inStart, double inEnd) {
    return ((value - inStart) / (inEnd - inStart)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = math.min(_envelopeMaxW, constraints.maxWidth * 0.85);
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;

            // ── Shake (horizontal tremor, decaying) ──
            final shakeT = _remap(t, 0, _shakeEnd);
            final shakeDecay = shakeT < 1.0 ? (1.0 - shakeT) : 0.0;
            final shakeX = math.sin(t * math.pi * 22) * 8.0 * shakeDecay;

            // ── Burn progress (curved, organic) ──
            final burnRaw = _remap(t, _burnStart, _burnEnd);
            final burn = Curves.easeInOutCubic.transform(burnRaw);

            // ── Envelope opacity (fade as it burns) ──
            final fadeRaw = _remap(t, _burnStart, _burnEnd);
            final opacity =
                (1.0 - Curves.easeIn.transform(fadeRaw * 0.95)).clamp(0.0, 1.0);

            // ── Scale (shrinks slightly) ──
            final scale = 1.0 - burn * 0.18;

            // ── Burn edge wipe (bottom→top, soft organic edge) ──
            final wipeStart = 0.14;
            final wipeRaw = _remap(t, wipeStart, 0.90);
            final wipe = Curves.easeIn.transform(wipeRaw);

            // ── Fire intensity ──
            double fireIntensity;
            if (t < _fireStart) {
              fireIntensity = 0;
            } else if (t < _fireStart + 0.06) {
              fireIntensity =
                  Curves.easeOut.transform(_remap(t, _fireStart, _fireStart + 0.06));
            } else if (t < _fireEnd - 0.12) {
              fireIntensity = 1.0;
            } else if (t < _fireEnd) {
              fireIntensity =
                  1.0 - Curves.easeIn.transform(_remap(t, _fireEnd - 0.12, _fireEnd));
            } else {
              fireIntensity = 0;
            }

            // ── Glow intensity ──
            double glowIntensity;
            if (t < _burnStart) {
              glowIntensity = 0;
            } else if (t < _burnStart + 0.08) {
              glowIntensity =
                  Curves.easeOut.transform(_remap(t, _burnStart, _burnStart + 0.08));
            } else if (t < _glowEnd - 0.10) {
              glowIntensity = 1.0;
            } else if (t < _glowEnd) {
              glowIntensity =
                  1.0 - Curves.easeIn.transform(_remap(t, _glowEnd - 0.10, _glowEnd));
            } else {
              glowIntensity = 0;
            }

            // ── Golden background wash (behind orange edge + envelope) ──
            double goldenBackgroundIntensity;
            if (t < 0.06) {
              goldenBackgroundIntensity =
                  Curves.easeOut.transform(t / 0.06);
            } else if (t < 0.78) {
              goldenBackgroundIntensity = 1.0;
            } else {
              goldenBackgroundIntensity =
                  1.0 - Curves.easeIn.transform((t - 0.78) / 0.22);
            }
            goldenBackgroundIntensity *=
                (0.55 + 0.45 * glowIntensity.clamp(0.0, 1.0));

            // Envelope rect estimation (for particles/glow) in Stack coords
            // We approximate from the center of the layout.
            final envW = maxW;
            final envH = maxW / 1.35;
            final envLeft = (constraints.maxWidth - envW) / 2;
            final envTop = (constraints.maxHeight - envH) / 2;
            final localEnvRect =
                Rect.fromLTWH(envLeft, envTop, envW, envH);

            final goldenCenter = Offset(
              constraints.maxWidth * 0.5,
              constraints.maxHeight * 0.42,
            );

            return Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                // Layer 0: Full-screen golden ambient (behind all burn FX)
                if (goldenBackgroundIntensity > 0.01)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: GoldenBurnAmbientPainter(
                          intensity: goldenBackgroundIntensity,
                          center: goldenCenter,
                        ),
                      ),
                    ),
                  ),

                // Layer 1: Orange edge glow + small radial (tracks burn line)
                if (glowIntensity > 0.01)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BurnGlowPainter(
                        burnProgress: burn,
                        intensity: glowIntensity,
                        envelopeRect: localEnvRect,
                      ),
                    ),
                  ),

                // Layer 2: Envelope with ShaderMask burn dissolve
                Center(
                  child: Transform.translate(
                    offset: Offset(shakeX, 0),
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.center,
                        child: ShaderMask(
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (rect) {
                            if (wipe <= 0.001) {
                              return const LinearGradient(
                                colors: [Colors.white, Colors.white],
                                stops: [0, 1],
                              ).createShader(rect);
                            }
                            // Wider, softer gradient edge (8–12% band)
                            final edge = wipe.clamp(0.001, 1.0);
                            final bandWidth = 0.10; // 10% soft transition
                            final edgeMid =
                                (edge + bandWidth * 0.3).clamp(0.0, 1.0);
                            final edgeEnd =
                                (edge + bandWidth).clamp(0.0, 1.0);
                            // Ensure stops are strictly increasing
                            final s1 = edge;
                            final s2 = edgeMid > s1
                                ? edgeMid
                                : (s1 + 0.001).clamp(0.0, 1.0);
                            final s3 = edgeEnd > s2
                                ? edgeEnd
                                : (s2 + 0.001).clamp(0.0, 1.0);
                            return LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: const [
                                Colors.transparent,
                                Colors.transparent,
                                Color(0x40FFFFFF), // soft semi-transparent edge
                                Colors.white,
                                Colors.white,
                              ],
                              stops: [0, s1, s2, s3, 1.0],
                            ).createShader(rect);
                          },
                          child: SizedBox(
                            width: envW,
                            height: envH,
                            child: const EnvelopeIllustration(
                              maxWidth: _envelopeMaxW,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Layer 3: Fire particle system
                if (fireIntensity > 0.01)
                  Positioned.fill(
                    child: FireParticleSystem(
                      burnProgress: burn,
                      intensity: fireIntensity,
                      envelopeRect: localEnvRect,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
