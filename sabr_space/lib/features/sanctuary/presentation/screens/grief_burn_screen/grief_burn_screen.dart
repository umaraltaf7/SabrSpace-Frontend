import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
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
      await _audioPlayer.setSource(AssetSource('sounds/burn.mp3'));
      _audioReady = true;
    } catch (_) {
      _audioReady = false;
    }
  }

  Future<void> _startBurn() async {
    setState(() => _burnStarted = true);
    if (_audioReady) {
      try {
        await _audioPlayer.resume();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _BP.darkBgBottom : _BP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_BP.darkBgTop, _BP.darkBgBottom]
                : const [_BP.lightBgTop, _BP.lightBgBottom],
          ),
        ),
        child: Stack(
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
                        isDark: isDark,
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
                    iconColor:
                        isDark ? _BP.darkAccent : _BP.lightAccent,
                    backgroundColor: isDark
                        ? _BP.darkSurface.withOpacity(0.90)
                        : _BP.lightSurface.withOpacity(0.90),
                  ),
                ),
              ),
          ],
        ),
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
    required this.isDark,
    required this.onRelease,
  });

  final bool isDark;
  final VoidCallback onRelease;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Envelope with purple-flame ambient glow
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? _BP.darkFlame.withOpacity(0.18)
                          : _BP.lightFlame.withOpacity(0.14),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                    BoxShadow(
                      color: isDark
                          ? _BP.darkAccent.withOpacity(0.14)
                          : _BP.lightAccent.withOpacity(0.10),
                      blurRadius: 60,
                      spreadRadius: 30,
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
              color: isDark
                  ? _BP.darkTextPrimary.withOpacity(0.88)
                  : _BP.lightTextPrimary.withOpacity(0.88),
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          Text(
            'When you\u2019re ready, release it to the flame.',
            style: AppTypography.bodySmall(context).copyWith(
              color: isDark
                  ? _BP.darkTextSecondary
                  : _BP.lightTextSecondary,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),

          // ── Burn button with flame gradient ──
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [_BP.darkFlame, _BP.darkAccent]
                      : const [_BP.lightFlame, _BP.lightAccent],
                ),
                borderRadius: AppSpacing.borderRadiusFull,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? _BP.darkFlame.withOpacity(0.40)
                        : _BP.lightFlame.withOpacity(0.36),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: isDark
                        ? _BP.darkAccent.withOpacity(0.22)
                        : _BP.lightAccent.withOpacity(0.22),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onRelease,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                ),
                child: Text(
                  'Release and burn',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.jumbo),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors + warm flame accent
// ─────────────────────────────────────────────────────────────────────────────

class _BP {
  // ── Light mode ──
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightAccent = Color(0xFF6E35A3);

  static const Color lightFlame = Color(0xFFC25A8E);

  // ── Dark mode ──
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color darkSurface = Color(0xFF341C49);

  static const Color darkAccent = Color(0xFFBC80DE);

  static const Color darkFlame = Color(0xFFE07AA8);
}
