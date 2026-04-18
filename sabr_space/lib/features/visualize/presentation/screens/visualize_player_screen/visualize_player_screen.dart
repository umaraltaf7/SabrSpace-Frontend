import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/visualize/presentation/models/visualize_track.dart';

class VisualizePlayerScreen extends StatefulWidget {
  const VisualizePlayerScreen({super.key, required this.track});

  final VisualizeTrack track;

  @override
  State<VisualizePlayerScreen> createState() => _VisualizePlayerScreenState();
}

class _VisualizePlayerScreenState extends State<VisualizePlayerScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _playing = false;
  bool _finished = false;
  bool _loading = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _rotateController;

  late StreamSubscription<Duration> _positionSub;
  late StreamSubscription<Duration> _durationSub;
  late StreamSubscription<PlayerState> _stateSub;

  VisualizeTrack get _track => widget.track;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _durationSub = _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });

    _stateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playing = state == PlayerState.playing;
        _loading = false;
        if (state == PlayerState.completed) {
          _finished = true;
          _playing = false;
          _position = _duration;
          _pulseController.stop();
          _rotateController.stop();
        }
      });
      if (state == PlayerState.playing) {
        _pulseController.repeat(reverse: true);
        _rotateController.repeat();
      } else if (state == PlayerState.paused) {
        _pulseController.stop();
        _rotateController.stop();
      }
    });

    _startAudio();
  }

  Future<void> _startAudio() async {
    try {
      await _audioPlayer.play(UrlSource(_track.audioUrl));
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _durationSub.cancel();
    _stateSub.cancel();
    _audioPlayer.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_finished) {
      _restart();
      return;
    }
    if (_playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
  }

  Future<void> _restart() async {
    setState(() {
      _finished = false;
      _position = Duration.zero;
    });
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.resume();
  }

  Future<void> _seekTo(Duration target) async {
    final clamped = Duration(
      milliseconds: target.inMilliseconds.clamp(0, _duration.inMilliseconds),
    );
    if (_finished && clamped < _duration) {
      setState(() => _finished = false);
    }
    await _audioPlayer.seek(clamped);
    if (!_playing && !_finished) {
      await _audioPlayer.resume();
    }
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_duration.inMilliseconds == 0) return 0.0;
    return (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _PP.darkBgBottom : _PP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_PP.darkBgTop, _PP.darkBgBottom]
                : const [_PP.lightBgTop, _PP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, isDark),
              const Spacer(flex: 2),
              _buildAnimatedOrb(context, isDark),
              const Spacer(flex: 1),
              _buildTrackInfo(context, isDark),
              const SizedBox(height: AppSpacing.xxxl),
              _buildProgressBar(context, isDark),
              const SizedBox(height: AppSpacing.xxxl),
              _buildControls(context, isDark),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          ScreenBackButton(
            iconColor: isDark ? _PP.darkAccentSoft : _PP.lightAccent,
          ),
          Expanded(
            child: Text(
              _track.category == VisualizeCategory.tilawat
                  ? 'TILAWAT'
                  : 'MEDITATE',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall(context).copyWith(
                color: isDark
                    ? _PP.darkTextSecondary
                    : _PP.lightTextSecondary,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAnimatedOrb(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotateController]),
      builder: (context, _) {
        final scale = _playing ? _pulseAnimation.value : 0.92;
        final rotation = _rotateController.value * 2 * math.pi;

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: rotation,
                child: Container(
                  width: 270 * scale,
                  height: 270 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? _PP.darkAccent.withOpacity(0.20)
                          : _PP.lightAccent.withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Container(
                width: 230 * scale,
                height: 230 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? _PP.darkAccentSoft.withOpacity(0.25)
                        : _PP.lightAccentSoft.withOpacity(0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? _PP.darkAccent.withOpacity(0.15)
                          : _PP.lightAccent.withOpacity(0.12),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 170 * scale,
                height: 170 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? const [_PP.darkOrbTop, _PP.darkOrbBottom]
                        : const [_PP.lightOrbTop, _PP.lightOrbBottom],
                  ),
                  border: Border.all(
                    color: isDark
                        ? _PP.darkAccentSoft.withOpacity(0.55)
                        : Colors.white.withOpacity(0.70),
                    width: 2.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? _PP.darkAccent.withOpacity(0.55)
                          : _PP.lightAccent.withOpacity(0.40),
                      blurRadius: 30,
                      spreadRadius: 6,
                    ),
                    BoxShadow(
                      color: isDark
                          ? _PP.darkAccentSoft.withOpacity(0.30)
                          : _PP.lightAccentSoft.withOpacity(0.35),
                      blurRadius: 50,
                      spreadRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: _loading
                      ? SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white.withOpacity(0.80),
                          ),
                        )
                      : Icon(
                          _track.category == VisualizeCategory.tilawat
                              ? Icons.menu_book_rounded
                              : Icons.self_improvement_rounded,
                          size: 48,
                          color: Colors.white.withOpacity(0.85),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackInfo(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Text(
        _track.title,
        textAlign: TextAlign.center,
        style: AppTypography.headlineSmall(context).copyWith(
          color: isDark ? _PP.darkTextPrimary : _PP.lightTextPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor:
                  isDark ? _PP.darkAccent : _PP.lightAccent,
              inactiveTrackColor: isDark
                  ? _PP.darkTextSecondary.withOpacity(0.20)
                  : _PP.lightTextSecondary.withOpacity(0.25),
              thumbColor: isDark ? _PP.darkAccent : _PP.lightAccent,
              overlayColor: isDark
                  ? _PP.darkAccent.withOpacity(0.20)
                  : _PP.lightAccent.withOpacity(0.20),
            ),
            child: Slider(
              value: _progress,
              onChanged: (v) {
                final target = Duration(
                  milliseconds: (v * _duration.inMilliseconds).round(),
                );
                _seekTo(target);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _fmtDuration(_position),
                  style: AppTypography.labelSmall(context).copyWith(
                    color: isDark
                        ? _PP.darkTextSecondary
                        : _PP.lightTextSecondary,
                  ),
                ),
                Text(
                  _fmtDuration(_duration),
                  style: AppTypography.labelSmall(context).copyWith(
                    color: isDark
                        ? _PP.darkTextSecondary
                        : _PP.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () =>
              _seekTo(_position - const Duration(seconds: 10)),
          iconSize: 36,
          icon: Icon(
            Icons.replay_10_rounded,
            color: isDark ? _PP.darkTextSecondary : _PP.lightTextSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.xxl),
        GestureDetector(
          onTap: _loading ? null : _togglePlay,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [_PP.darkOrbTop, _PP.darkOrbBottom]
                    : const [_PP.lightOrbTop, _PP.lightOrbBottom],
              ),
              border: Border.all(
                color: isDark
                    ? _PP.darkAccentSoft.withOpacity(0.50)
                    : Colors.white.withOpacity(0.70),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? _PP.darkAccent.withOpacity(0.45)
                      : _PP.lightAccent.withOpacity(0.35),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: isDark
                      ? _PP.darkAccentSoft.withOpacity(0.20)
                      : _PP.lightAccentSoft.withOpacity(0.25),
                  blurRadius: 42,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              _finished
                  ? Icons.replay_rounded
                  : (_playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
              size: 42,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xxl),
        IconButton(
          onPressed: () =>
              _seekTo(_position + const Duration(seconds: 10)),
          iconSize: 36,
          icon: Icon(
            Icons.forward_10_rounded,
            color: isDark ? _PP.darkTextSecondary : _PP.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _PP {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFF3E6FB);

  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);

  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);
}
