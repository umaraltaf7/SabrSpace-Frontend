import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A single fire or smoke particle.
class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double life; // 0.0 → 1.0 (1 = just born, 0 = dead)
  double decay; // how fast life drains per second
  double size;
  Color color;
  bool isSmoke;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.decay,
    required this.size,
    required this.color,
    this.isSmoke = false,
  });
}

/// Lightweight fire + smoke particle system rendered via [CustomPainter].
///
/// Particles emit from a horizontal band that tracks the burn-edge progress.
/// Fire particles move upward quickly with orange/yellow/red tones.
/// Smoke particles are gray, larger, slower, and trail behind fire.
class FireParticleSystem extends StatefulWidget {
  const FireParticleSystem({
    super.key,
    required this.burnProgress,
    required this.intensity,
    required this.envelopeRect,
  });

  /// 0..1 — where the burn edge is (0 = bottom, 1 = top).
  final double burnProgress;

  /// 0..1 — overall intensity (ramps in/out at start/end of animation).
  final double intensity;

  /// The rect of the envelope in local coordinates (for positioning particles).
  final Rect envelopeRect;

  @override
  State<FireParticleSystem> createState() => _FireParticleSystemState();
}

class _FireParticleSystemState extends State<FireParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ticker;
  final List<_Particle> _particles = [];
  final math.Random _rng = math.Random();

  static const int _maxFire = 80;
  static const int _maxSmoke = 30;

  double _lastTime = 0;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _ticker.addListener(_tick);
  }

  @override
  void dispose() {
    _ticker.removeListener(_tick);
    _ticker.dispose();
    super.dispose();
  }

  void _tick() {
    final now = _ticker.lastElapsedDuration?.inMicroseconds ?? 0;
    final dt = _lastTime == 0 ? 0.016 : (now / 1e6 - _lastTime);
    _lastTime = now / 1e6;

    if (dt <= 0 || dt > 0.1) return; // skip bad frames

    _updateParticles(dt);
    _emitParticles(dt);
    // CustomPainter will repaint because we mark needs paint via setState
    if (mounted) setState(() {});
  }

  void _updateParticles(double dt) {
    for (var i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= p.decay * dt;
      if (p.life <= 0) {
        _particles.removeAt(i);
        continue;
      }
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      // Slight horizontal wobble
      p.vx += (_rng.nextDouble() - 0.5) * 120 * dt;
      // Dampen horizontal velocity
      p.vx *= 0.97;
    }
  }

  void _emitParticles(double dt) {
    if (widget.intensity <= 0.01) return;

    final rect = widget.envelopeRect;
    if (rect.isEmpty) return;

    // Burn edge Y position (in local coords, bottom=rect.bottom, top=rect.top)
    final edgeY =
        rect.bottom - (widget.burnProgress * rect.height);

    // Fire particles
    final fireCount = _particles.where((p) => !p.isSmoke).length;
    final fireRate = (widget.intensity * 55 * dt).ceil(); // ~55/sec at full
    for (var i = 0; i < fireRate && fireCount + i < _maxFire; i++) {
      final px = rect.left + _rng.nextDouble() * rect.width;
      final py = edgeY + (_rng.nextDouble() - 0.5) * 14;
      _particles.add(_Particle(
        x: px,
        y: py,
        vx: (_rng.nextDouble() - 0.5) * 40,
        vy: -(60 + _rng.nextDouble() * 100), // upward
        life: 1.0,
        decay: 1.2 + _rng.nextDouble() * 0.8, // ~0.5-0.8s lifespan
        size: 2.5 + _rng.nextDouble() * 4.5,
        color: _fireColor(),
      ));
    }

    // Smoke particles (fewer, slower, gray)
    final smokeCount = _particles.where((p) => p.isSmoke).length;
    final smokeRate = (widget.intensity * 12 * dt).ceil();
    for (var i = 0; i < smokeRate && smokeCount + i < _maxSmoke; i++) {
      final px = rect.left + _rng.nextDouble() * rect.width;
      final py = edgeY + (_rng.nextDouble() - 0.3) * 20;
      _particles.add(_Particle(
        x: px,
        y: py,
        vx: (_rng.nextDouble() - 0.5) * 20,
        vy: -(25 + _rng.nextDouble() * 40), // slower upward
        life: 1.0,
        decay: 0.6 + _rng.nextDouble() * 0.4, // longer lifespan
        size: 6 + _rng.nextDouble() * 8,
        color: _smokeColor(),
        isSmoke: true,
      ));
    }
  }

  Color _fireColor() {
    final t = _rng.nextDouble();
    if (t < 0.35) {
      return const Color(0xFFFFD60A); // bright yellow
    } else if (t < 0.7) {
      return const Color(0xFFFF6B35); // orange
    } else {
      return const Color(0xFFFF4500); // red-orange
    }
  }

  Color _smokeColor() {
    final g = 60 + _rng.nextInt(40); // 60-100 gray
    return Color.fromARGB(180, g, g, g);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _FireParticlePainter(
          particles: _particles,
          intensity: widget.intensity,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FireParticlePainter extends CustomPainter {
  _FireParticlePainter({
    required this.particles,
    required this.intensity,
  });

  final List<_Particle> particles;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final opacity = (p.life * (p.isSmoke ? 0.35 : 0.85) * intensity)
          .clamp(0.0, 1.0);
      if (opacity < 0.01) continue;

      final currentSize = p.size * (0.3 + p.life * 0.7);
      final color = p.color.withValues(alpha: opacity);

      if (p.isSmoke) {
        // Smoke: soft blurred circle
        final paint = Paint()
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(p.x, p.y), currentSize, paint);
      } else {
        // Fire: radial gradient dot with additive blending
        final paint = Paint()
          ..shader = ui.Gradient.radial(
            Offset(p.x, p.y),
            currentSize,
            [
              color,
              color.withValues(alpha: 0),
            ],
          )
          ..blendMode = BlendMode.plus;
        canvas.drawCircle(Offset(p.x, p.y), currentSize, paint);

        // Inner bright core
        final corePaint = Paint()
          ..color = const Color(0xFFFFE8A0).withValues(alpha: opacity * 0.6)
          ..blendMode = BlendMode.plus;
        canvas.drawCircle(
          Offset(p.x, p.y),
          currentSize * 0.3,
          corePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FireParticlePainter oldDelegate) => true;
}
