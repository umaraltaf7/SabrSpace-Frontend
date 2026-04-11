import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/audio/presentation/models/audio_player_args.dart';

/// Full-screen now playing UI.
class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({
    super.key,
    required this.args,
  });

  final AudioPlayerArgs args;

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _playing = true;
  double _progress = 0.43;

  AudioPlayerArgs get _a => widget.args;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _APP.darkBgBottom : _APP.lightBgBottom,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_APP.darkBgTop, _APP.darkBgBottom]
                : const [_APP.lightBgTop, _APP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm),
                child: Row(
                  children: [
                    ScreenBackButton(
                      iconColor:
                          isDark ? _APP.darkAccent : _APP.lightAccent,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'NOW PLAYING',
                            style: AppTypography.labelSmall(context)
                                .copyWith(
                              color: isDark
                                  ? _APP.darkTextSecondary
                                  : _APP.lightTextSecondary,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _a.collectionTitle,
                            style: AppTypography.headlineSmall(context)
                                .copyWith(
                              color: isDark
                                  ? _APP.darkAccent
                                  : _APP.lightAccent,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  _APP.darkSurfaceElevated
                                      .withOpacity(0.78),
                                  _APP.darkSurface.withOpacity(0.66),
                                ]
                              : [
                                  _APP.lightSurfaceSoft
                                      .withOpacity(0.58),
                                  _APP.lightSurface.withOpacity(0.70),
                                ],
                        ),
                        border: Border.all(
                          color: isDark
                              ? _APP.darkBorder.withOpacity(0.22)
                              : _APP.lightBorder.withOpacity(0.40),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: isDark
                              ? _APP.darkTextPrimary
                              : _APP.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Artwork disc ──
              _ArtworkDisc(isDark: isDark),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Track info ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: Column(
                  children: [
                    Text(
                      _a.trackTitle,
                      style: AppTypography.headlineSmall(context)
                          .copyWith(
                        color: isDark
                            ? _APP.darkTextPrimary
                            : _APP.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _a.artist,
                      style:
                          AppTypography.bodyMedium(context).copyWith(
                        color: isDark
                            ? _APP.darkTextSecondary
                            : _APP.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Slider ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                        activeTrackColor: isDark
                            ? _APP.darkAccent
                            : _APP.lightAccent,
                        inactiveTrackColor: isDark
                            ? _APP.darkTextSecondary.withOpacity(0.25)
                            : _APP.lightTextSecondary.withOpacity(0.28),
                        thumbColor: isDark
                            ? _APP.darkAccent
                            : _APP.lightAccent,
                        overlayColor: isDark
                            ? _APP.darkAccent.withOpacity(0.20)
                            : _APP.lightAccent.withOpacity(0.20),
                      ),
                      child: Slider(
                        value: _progress.clamp(0.0, 1.0),
                        onChanged: (v) =>
                            setState(() => _progress = v),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _fmtDuration(
                              Duration(
                                milliseconds: (_progress *
                                        _a.duration.inMilliseconds)
                                    .round(),
                              ),
                            ),
                            style: AppTypography.labelSmall(context)
                                .copyWith(
                              color: isDark
                                  ? _APP.darkTextSecondary
                                  : _APP.lightTextSecondary,
                            ),
                          ),
                          Text(
                            _fmtDuration(_a.duration),
                            style: AppTypography.labelSmall(context)
                                .copyWith(
                              color: isDark
                                  ? _APP.darkTextSecondary
                                  : _APP.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ── Transport controls ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shuffle_rounded,
                        color: isDark
                            ? _APP.darkTextSecondary
                            : _APP.lightTextSecondary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      iconSize: 32,
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: isDark
                            ? _APP.darkTextPrimary
                            : _APP.lightTextPrimary,
                      ),
                    ),

                    // ── Play / pause orb ──
                    GestureDetector(
                      onTap: () =>
                          setState(() => _playing = !_playing),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? const [
                                    _APP.darkOrbTop,
                                    _APP.darkOrbBottom,
                                  ]
                                : const [
                                    _APP.lightOrbTop,
                                    _APP.lightOrbBottom,
                                  ],
                          ),
                          border: Border.all(
                            color: isDark
                                ? _APP.darkAccentSoft.withOpacity(0.52)
                                : Colors.white.withOpacity(0.72),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _APP.darkAccent.withOpacity(0.40)
                                  : _APP.lightAccent.withOpacity(0.36),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: isDark
                                  ? _APP.darkAccentSoft
                                      .withOpacity(0.18)
                                  : _APP.lightAccentSoft
                                      .withOpacity(0.22),
                              blurRadius: 42,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          _playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      iconSize: 32,
                      icon: Icon(
                        Icons.skip_next_rounded,
                        color: isDark
                            ? _APP.darkTextPrimary
                            : _APP.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.repeat_rounded,
                        color: isDark
                            ? _APP.darkTextSecondary
                            : _APP.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Bottom actions ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionIcon(
                      icon: Icons.favorite_border_rounded,
                      label: 'Save',
                      isDark: isDark,
                    ),
                    _ActionIcon(
                      icon: Icons.queue_music_rounded,
                      label: 'Queue',
                      isDark: isDark,
                    ),
                    _ActionIcon(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      isDark: isDark,
                    ),
                    _ActionIcon(
                      icon: Icons.bedtime_rounded,
                      label: 'Sleep',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Artwork disc with concentric rings
// ─────────────────────────────────────────────────────────────────────────────

class _ArtworkDisc extends StatelessWidget {
  const _ArtworkDisc({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const size = 220.0;
    return SizedBox(
      width: size + 28,
      height: size + 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size + 24,
            height: size + 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? _APP.darkAccent.withOpacity(0.28)
                    : _APP.lightAccent.withOpacity(0.22),
                width: 1.5,
              ),
            ),
          ),
          // Inner ring
          Container(
            width: size + 12,
            height: size + 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? _APP.darkBorder.withOpacity(0.20)
                    : _APP.lightBorder.withOpacity(0.26),
                width: 1,
              ),
            ),
          ),
          // Main disc
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        _APP.darkSurfaceElevated,
                        _APP.darkOrbTop.withOpacity(0.55),
                        _APP.darkOrbBottom.withOpacity(0.42),
                      ]
                    : [
                        _APP.lightSurfaceSoft,
                        _APP.lightOrbTop.withOpacity(0.50),
                        _APP.lightOrbBottom.withOpacity(0.38),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? _APP.darkAccentSoft.withOpacity(0.30)
                    : Colors.white.withOpacity(0.60),
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? _APP.darkAccent.withOpacity(0.22)
                      : _APP.lightAccent.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: isDark
                      ? _APP.darkShadow.withOpacity(0.38)
                      : _APP.lightShadow.withOpacity(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.music_note_rounded,
              size: 72,
              color: isDark
                  ? _APP.darkTextSecondary.withOpacity(0.40)
                  : _APP.lightTextSecondary.withOpacity(0.38),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action icon button
// ─────────────────────────────────────────────────────────────────────────────

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? _APP.darkTextSecondary : _APP.lightTextSecondary;
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: color),
        ),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _APP {
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
  static const Color darkShadow = Color(0xFF0C0515);
}
