import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/audio/presentation/models/audio_player_args.dart';

/// Full-screen now playing UI — layout mirrors the reference; colors from [AppColors] only.
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
    final bg = context.palette.surface;
    final onSurf = context.palette.onSurface;
    final onVar = context.palette.onSurfaceVariant;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                children: [
                  const ScreenBackButton(),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'NOW PLAYING',
                          style: AppTypography.labelSmall(context).copyWith(
                            color: onVar,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _a.collectionTitle,
                          style: AppTypography.headlineSmall(context).copyWith(
                            color: context.palette.secondaryFixed,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: onSurf,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: context.palette.surfaceContainerHigh,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _ArtworkDisc(),
            const SizedBox(height: AppSpacing.xxxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                children: [
                  Text(
                    _a.trackTitle,
                    style: AppTypography.headlineSmall(context).copyWith(
                      color: onSurf,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _a.artist,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: onVar,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
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
                      activeTrackColor: context.palette.secondaryFixed,
                      inactiveTrackColor:
                          onVar.withValues(alpha: 0.35),
                      thumbColor: context.palette.secondaryFixed,
                      overlayColor:
                          context.palette.secondaryFixed.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _progress.clamp(0.0, 1.0),
                      onChanged: (v) => setState(() => _progress = v),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fmtDuration(
                            Duration(
                              milliseconds: (_progress *
                                      _a.duration.inMilliseconds)
                                  .round(),
                            ),
                          ),
                          style: AppTypography.labelSmall(context).copyWith(
                            color: onVar,
                          ),
                        ),
                        Text(
                          _fmtDuration(_a.duration),
                          style: AppTypography.labelSmall(context).copyWith(
                            color: onVar,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shuffle_rounded,
                      color: onVar,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    iconSize: 32,
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      color: onSurf,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _playing = !_playing),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color:
                                context.palette.secondary.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 40,
                        color: context.palette.onSecondaryFixed,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    iconSize: 32,
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: onSurf,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: onVar,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionIcon(
                    icon: Icons.favorite_border_rounded,
                    label: 'Save',
                    onVar: onVar,
                  ),
                  _ActionIcon(
                    icon: Icons.queue_music_rounded,
                    label: 'Queue',
                    onVar: onVar,
                  ),
                  _ActionIcon(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    onVar: onVar,
                  ),
                  _ActionIcon(
                    icon: Icons.bedtime_rounded,
                    label: 'Sleep',
                    onVar: onVar,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
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

class _ArtworkDisc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const size = 220.0;
    return SizedBox(
      width: size + 28,
      height: size + 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size + 24,
            height: size + 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.palette.secondaryFixed.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: size + 12,
            height: size + 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.palette.primaryFixed.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.palette.surfaceContainerHighest,
                  context.palette.primaryFixedDim.withValues(alpha: 0.65),
                  context.palette.primaryContainer.withValues(alpha: 0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: context.palette.primary.withValues(alpha: 0.22),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              Icons.music_note_rounded,
              size: 72,
              color: context.palette.onSurfaceVariant.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onVar,
  });

  final IconData icon;
  final String label;
  final Color onVar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: onVar),
        ),
        Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: onVar,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
