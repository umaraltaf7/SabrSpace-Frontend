import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';
import 'package:sabr_space/features/sanctuary/presentation/widgets/burning_envelope_animation.dart';

/// Grief Burner – Burn State: envelope + "Release and burn", then burn animation.
class GriefBurnScreen extends StatefulWidget {
  const GriefBurnScreen({super.key});

  @override
  State<GriefBurnScreen> createState() => _GriefBurnScreenState();
}

class _GriefBurnScreenState extends State<GriefBurnScreen> {
  bool _burnStarted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioReady = false;

  @override
  void initState() {
    super.initState();
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    try {
      // Pre-load the burn sound for instant playback.
      // Graceful fallback: if the asset doesn't exist, we skip sound.
      await _audioPlayer.setSource(AssetSource('sounds/burn.mp3'));
      _audioReady = true;
    } catch (_) {
      // Asset not present — animation works fine without sound.
      _audioReady = false;
    }
  }

  Future<void> _startBurn() async {
    setState(() => _burnStarted = true);
    if (_audioReady) {
      try {
        await _audioPlayer.resume();
      } catch (_) {
        // Ignore audio errors — visual animation proceeds regardless.
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _burnStarted
                  ? BurningEnvelopeAnimation(
                      key: const ValueKey('burn'),
                      duration: const Duration(milliseconds: 3200),
                      onCompleted: () {
                        if (context.mounted) {
                          context.pushReplacement('/grief-complete');
                        }
                      },
                    )
                  : _PreBurnContent(
                      key: const ValueKey('pre'),
                      onRelease: _startBurn,
                    ),
            ),
          ),
          if (!_burnStarted)
            Positioned(
              top: 0,
              left: AppSpacing.sm,
              child: SafeArea(
                bottom: false,
                child: ScreenBackButton(
                  iconColor: context.palette.primary,
                  backgroundColor: context.palette.surface.withValues(alpha: 0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRE-BURN UI — envelope preview + "Release and burn" CTA
// ─────────────────────────────────────────────────────────────────────────────

class _PreBurnContent extends StatelessWidget {
  const _PreBurnContent({
    super.key,
    required this.onRelease,
  });

  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Envelope with subtle warm ambient glow behind it
          Stack(
            alignment: Alignment.center,
            children: [
              // Ambient pre-glow
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.palette.primary.withValues(alpha: 0.12),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
              const EnvelopeIllustration(maxWidth: 240),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),

          Text(
            AppStrings.weightOfUnspoken,
            style: AppTypography.bodyLarge(context).copyWith(
              color: context.palette.onSurface.withValues(alpha: 0.88),
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          Text(
            'When you\u2019re ready, release it to the flame.',
            style: AppTypography.bodySmall(context).copyWith(
              color: context.palette.onSurfaceVariant,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),

          // CTA button
          GradientButton(
            text: 'Release and burn',
            onPressed: onRelease,
          ),
          const SizedBox(height: AppSpacing.jumbo),
        ],
      ),
    );
  }
}
