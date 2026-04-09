import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Tasbih-style dhikr: 34 × Allahu Akbar, 33 × Alhamdulillah, 33 × SubhanAllah.
class ZikrCounterScreen extends StatefulWidget {
  const ZikrCounterScreen({super.key});

  @override
  State<ZikrCounterScreen> createState() => _ZikrCounterScreenState();
}

class _ZikrCounterScreenState extends State<ZikrCounterScreen> {
  static const List<int> _targets = [34, 33, 33];

  static const List<String> _arabic = [
    'اللهُ أَكْبَر',
    'الْحَمْدُ لِلَّهِ',
    'سُبْحَانَ اللَّهِ',
  ];

  static const List<String> _transliteration = [
    'Allāhu Akbar',
    'Alhamdulillāh',
    'SubhānAllāh',
  ];

  int _phase = 0;
  int _count = 0;
  bool _completed = false;

  int get _target => _targets[_phase];

  void _onCircleTap() {
    if (_completed) return;

    HapticFeedback.lightImpact();

    final t = _target;
    if (_count < t) {
      setState(() {
        _count++;
        if (_count == t) {
          if (_phase == 2) {
            _completed = true;
          } else {
            _phase++;
            _count = 0;
          }
        }
      });
    }
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _phase = 0;
      _count = 0;
      _completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ScreenBackButton(iconColor: cs.primary),
                    const Spacer(),
                    Text(
                      AppStrings.dhikrScreenTitle,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.dhikrScreenSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: p.onSurfaceVariant,
                  ),
                ),
                const Spacer(),

                if (_completed) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: cs.primary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.dhikrRoundComplete,
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall(context).copyWith(
                      color: p.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.dhikrRoundCompleteSub,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: p.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Center(
                    child: FilledButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(AppStrings.dhikrStartAgain),
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    AppStrings.dhikrTapCircle,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: p.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: Semantics(
                      button: true,
                      label: AppStrings.dhikrTapToCount,
                      child: Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAlias,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _onCircleTap,
                          customBorder: const CircleBorder(),
                          child: Ink(
                            height: 280,
                            width: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.surfaceContainerHigh,
                              border: Border.all(
                                color: cs.primary.withValues(alpha: 0.45),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.primary.withValues(alpha: 0.18),
                                  blurRadius: 32,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                  ),
                                  child: Text(
                                    _arabic[_phase],
                                    textAlign: TextAlign.center,
                                    style: AppTypography.arabicVerse(context)
                                        .copyWith(
                                      fontSize: 26,
                                      height: 1.4,
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  _transliteration[_phase],
                                  textAlign: TextAlign.center,
                                  style: AppTypography.labelLarge(context)
                                      .copyWith(
                                    color: p.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    '${_count.clamp(0, _target)} / $_target',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium(context).copyWith(
                      color: p.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.dhikrPhaseNofM(_phase + 1, 3),
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: p.outline,
                    ),
                  ),
                ],

                const Spacer(),
                if (!_completed)
                  TextButton(
                    onPressed: _reset,
                    child: Text(
                      AppStrings.dhikrReset,
                      style: AppTypography.labelLarge(context).copyWith(
                        color: p.outline,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
