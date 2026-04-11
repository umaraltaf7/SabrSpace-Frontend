import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/sanctuary/presentation/models/breathe_session_args.dart';

enum _BreathPhase { inhale, hold, exhale }

/// Active breathe session — outer ring shows elapsed time; inner circle animates
/// with inhale (contract), hold (still), exhale (expand). Phase labels in the center;
/// optional dhikr phrases with "Change word".
class BreatheSessionScreen extends StatefulWidget {
  const BreatheSessionScreen({
    super.key,
    this.args = BreatheSessionArgs.defaultArgs,
  });

  final BreatheSessionArgs args;

  @override
  State<BreatheSessionScreen> createState() => _BreatheSessionScreenState();
}

class _BreatheSessionScreenState extends State<BreatheSessionScreen> {
  static const double _maxScale = 1.12;
  static const double _minScale = 0.82;

  late final int _totalSeconds;
  late int _remainingSeconds;
  Timer? _tickTimer;

  late final int _inhaleSec;
  late final int _holdSec;
  late final int _exhaleSec;

  _BreathPhase _phase = _BreathPhase.inhale;
  int _cycleId = 0;
  int _phaseSecondsLeft = 0;
  int _dhikrIndex = 0;

  static const List<String> _dhikrWords = [
    AppStrings.subhanAllah,
    AppStrings.alhamdulillah,
    AppStrings.allahuAkbar,
  ];

  @override
  void initState() {
    super.initState();
    final pattern = widget.args.breathPattern;
    _inhaleSec = pattern.$1;
    _holdSec = pattern.$2;
    _exhaleSec = pattern.$3;

    _totalSeconds = widget.args.durationSeconds;
    _remainingSeconds = _totalSeconds;
    _phaseSecondsLeft = _secondsForPhase(_phase);

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  int _secondsForPhase(_BreathPhase p) {
    switch (p) {
      case _BreathPhase.inhale:
        return _inhaleSec;
      case _BreathPhase.hold:
        return _holdSec;
      case _BreathPhase.exhale:
        return _exhaleSec;
    }
  }

  void _onTick() {
    if (!mounted) return;

    if (_remainingSeconds <= 1) {
      _tickTimer?.cancel();
      context.pushReplacement('/breathe-complete');
      return;
    }

    setState(() {
      _remainingSeconds--;
      _phaseSecondsLeft--;
      if (_phaseSecondsLeft <= 0) {
        _advancePhase();
      }
    });
  }

  void _advancePhase() {
    if (_phase == _BreathPhase.exhale) {
      _cycleId++;
    }
    _phase = switch (_phase) {
      _BreathPhase.inhale => _BreathPhase.hold,
      _BreathPhase.hold => _BreathPhase.exhale,
      _BreathPhase.exhale => _BreathPhase.inhale,
    };
    _phaseSecondsLeft = _secondsForPhase(_phase);
  }

  String get _phaseLabel {
    switch (_phase) {
      case _BreathPhase.inhale:
        return AppStrings.breathInLabel;
      case _BreathPhase.hold:
        return AppStrings.breathHoldLabel;
      case _BreathPhase.exhale:
        return AppStrings.breathOutLabel;
    }
  }

  double _tweenBegin(_BreathPhase p) {
    switch (p) {
      case _BreathPhase.inhale:
        return _maxScale;
      case _BreathPhase.hold:
        return _minScale;
      case _BreathPhase.exhale:
        return _minScale;
    }
  }

  double _tweenEnd(_BreathPhase p) {
    switch (p) {
      case _BreathPhase.inhale:
        return _minScale;
      case _BreathPhase.hold:
        return _minScale;
      case _BreathPhase.exhale:
        return _maxScale;
    }
  }

  int _phaseDurationSeconds(_BreathPhase p) => _secondsForPhase(p);

  double get _elapsedProgress {
    if (_totalSeconds == 0) return 1;
    return (_totalSeconds - _remainingSeconds) / _totalSeconds;
  }

  String get _timeLabel {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _endSession() {
    _tickTimer?.cancel();
    context.pushReplacement('/breathe-complete');
  }

  @override
  Widget build(BuildContext context) {
    final progress = _elapsedProgress;
    final pairDhikr = widget.args.pairWithDhikr;
    final phaseDur = _phaseDurationSeconds(_phase);
    final animKey = ValueKey<String>('${_phase.name}_$_cycleId');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _BreatheSessionPalette.darkBackgroundTop,
                    _BreatheSessionPalette.darkBackgroundBottom,
                  ]
                : const [
                    _BreatheSessionPalette.lightBackgroundTop,
                    _BreatheSessionPalette.lightBackgroundBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _SessionDecorPainter(isDark: isDark),
                  ),
                ),
              ),
              Column(
                children: [
              const SizedBox(height: AppSpacing.xl),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark
                                ? _BreatheSessionPalette.darkAccentSoft
                                : _BreatheSessionPalette.lightAccentSoft)
                            .withValues(alpha: 0.35),
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Text(
                        AppStrings.sessionInProgress,
                        style: AppTypography.labelSmall(context).copyWith(
                          color: isDark
                              ? _BreatheSessionPalette.darkTextPrimary
                              : _BreatheSessionPalette.lightAccent,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                AppStrings.peacefulMorning,
                style: AppTypography.headlineSmall(context).copyWith(
                  color: isDark
                      ? _BreatheSessionPalette.darkTextPrimary
                      : _BreatheSessionPalette.lightTextPrimary,
                ),
              ),
              const Spacer(),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: CustomPaint(
                            painter: _ProgressRingPainter(
                              progress: progress,
                              strokeWidth: 8,
                              trackColor: isDark
                                  ? _BreatheSessionPalette.darkSurfaceElevated
                                  : _BreatheSessionPalette.lightSurface,
                              progressColor: isDark
                                  ? _BreatheSessionPalette.darkAccent
                                  : _BreatheSessionPalette.lightAccent,
                            ),
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          key: animKey,
                          tween: Tween<double>(
                            begin: _tweenBegin(_phase),
                            end: _tweenEnd(_phase),
                          ),
                          duration: Duration(seconds: phaseDur),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 226,
                            height: 226,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? const [
                                        _BreatheSessionPalette.darkCardTop,
                                        _BreatheSessionPalette.darkCardBottom,
                                      ]
                                    : const [
                                        _BreatheSessionPalette.lightCardTop,
                                        _BreatheSessionPalette.lightCardBottom,
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isDark
                                          ? _BreatheSessionPalette.darkAccent
                                          : _BreatheSessionPalette.lightAccent)
                                      .withValues(alpha: 0.24),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              child: _buildCenterContent(context, pairDhikr),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pairDhikr) ...[
                    const SizedBox(height: AppSpacing.sm),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _dhikrIndex = (_dhikrIndex + 1) % _dhikrWords.length;
                        });
                      },
                      tooltip: AppStrings.breatheChangeWord,
                      icon: Icon(
                        Icons.autorenew_rounded,
                        color: isDark
                            ? _BreatheSessionPalette.darkAccentSoft
                            : _BreatheSessionPalette.lightAccent,
                        size: 28,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                '${(progress * 100).clamp(0, 100).toInt()}% of session',
                style: AppTypography.labelMedium(context).copyWith(
                  color: isDark
                      ? _BreatheSessionPalette.darkTextSecondary
                      : _BreatheSessionPalette.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoChip(AppStrings.serenity, Icons.spa_outlined),
                  const SizedBox(width: AppSpacing.xxl),
                  _buildInfoChip(AppStrings.presence, Icons.visibility_outlined),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                _timeLabel,
                style: AppTypography.headlineSmall(context).copyWith(
                  color: isDark
                      ? _BreatheSessionPalette.darkAccentSoft
                      : _BreatheSessionPalette.lightAccent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextButton(
                onPressed: _endSession,
                child: Text(
                  AppStrings.endSession,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: context.palette.error,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context, bool pairDhikr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phaseStyle = AppTypography.titleLarge(context).copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
    final dhikrStyle = AppTypography.headlineSmall(context).copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      height: 1.2,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pairDhikr)
          Text(
            _dhikrWords[_dhikrIndex],
            style: dhikrStyle,
            textAlign: TextAlign.center,
          )
        else
          Text(
            _phaseLabel,
            style: phaseStyle,
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$_phaseSecondsLeft s',
          style: AppTypography.labelSmall(context).copyWith(
            color: isDark
                ? _BreatheSessionPalette.darkTextSecondary
                : Colors.white.withValues(alpha: 0.88),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark
              ? _BreatheSessionPalette.darkTextSecondary
              : _BreatheSessionPalette.lightTextSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: isDark
                ? _BreatheSessionPalette.darkTextSecondary
                : _BreatheSessionPalette.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _SessionDecorPainter extends CustomPainter {
  _SessionDecorPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final farGround = Paint()
      ..color = (isDark ? const Color(0xFF5A2F79) : const Color(0xFFA978CC))
          .withValues(alpha: isDark ? 0.58 : 0.46);
    final nearGround = Paint()
      ..color = (isDark ? const Color(0xFF44245C) : const Color(0xFF8F58BB))
          .withValues(alpha: isDark ? 0.78 : 0.58);

    final farPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.80)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.72,
        size.width * 0.50,
        size.height * 0.80,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.90,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(farPath, farGround);

    final nearPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.84,
        size.width * 0.60,
        size.height * 0.92,
      )
      ..quadraticBezierTo(
        size.width * 0.84,
        size.height * 0.98,
        size.width,
        size.height * 0.90,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(nearPath, nearGround);

    final treeColor = (isDark ? const Color(0xFF2A173A) : const Color(0xFF6B3D8B))
        .withValues(alpha: isDark ? 0.86 : 0.62);
    final treePaint = Paint()
      ..color = treeColor
      ..strokeCap = StrokeCap.round;

    // Main tree trunk from bottom-left near footer area.
    treePaint.strokeWidth = 7;
    canvas.drawLine(
      Offset(size.width * 0.03, size.height * 1.02),
      Offset(size.width * 0.20, size.height * 0.44),
      treePaint,
    );

    // Branches spreading upward across the screen.
    treePaint.strokeWidth = 3.4;
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.60),
      Offset(size.width * 0.36, size.height * 0.46),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.54),
      Offset(size.width * 0.44, size.height * 0.30),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.20, size.height * 0.50),
      Offset(size.width * 0.56, size.height * 0.24),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.14, size.height * 0.70),
      Offset(size.width * 0.34, size.height * 0.62),
      treePaint,
    );

    // Left-side branches from the trunk.
    canvas.drawLine(
      Offset(size.width * 0.14, size.height * 0.64),
      Offset(size.width * 0.06, size.height * 0.52),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.58),
      Offset(size.width * 0.04, size.height * 0.40),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.52),
      Offset(size.width * 0.02, size.height * 0.30),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.60),
      Offset(size.width * 0.66, size.height * 0.50),
      treePaint,
    );

    // Subtle branches behind breathing circle.
    treePaint.strokeWidth = 2.3;
    canvas.drawLine(
      Offset(size.width * 0.26, size.height * 0.62),
      Offset(size.width * 0.50, size.height * 0.56),
      treePaint..color = treeColor.withValues(alpha: isDark ? 0.44 : 0.34),
    );
    canvas.drawLine(
      Offset(size.width * 0.24, size.height * 0.68),
      Offset(size.width * 0.52, size.height * 0.66),
      treePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.58),
      Offset(size.width * 0.58, size.height * 0.46),
      treePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SessionDecorPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _BreatheSessionPalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFF1E4FB);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);

  static const Color lightSurface = Color(0xFFECE1FA);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);
}

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final sweep = 2 * math.pi * progress.clamp(0.0, 1.0);

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          progressColor,
          progressColor.withValues(alpha: 0.75),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter old) =>
      old.progress != progress ||
      old.strokeWidth != strokeWidth ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}
