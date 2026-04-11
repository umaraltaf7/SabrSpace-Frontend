import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? _ZikrPalette.darkBgBottom
          : _ZikrPalette.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _ZikrPalette.darkBgTop,
                    _ZikrPalette.darkBgBottom,
                  ]
                : const [
                    _ZikrPalette.lightBgTop,
                    _ZikrPalette.lightBgBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ScreenBackButton(
                      iconColor: isDark
                          ? _ZikrPalette.darkAccent
                          : _ZikrPalette.lightAccent,
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.dhikrScreenTitle,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: isDark
                            ? _ZikrPalette.darkTextPrimary
                            : _ZikrPalette.lightAccent,
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
                    color: isDark
                        ? _ZikrPalette.darkTextSecondary
                        : _ZikrPalette.lightTextSecondary,
                  ),
                ),
                const Spacer(),

                if (_completed) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: isDark
                        ? _ZikrPalette.darkAccent
                        : _ZikrPalette.lightAccent,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.dhikrRoundComplete,
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall(context).copyWith(
                      color: isDark
                          ? _ZikrPalette.darkTextPrimary
                          : _ZikrPalette.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.dhikrRoundCompleteSub,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: isDark
                          ? _ZikrPalette.darkTextSecondary
                          : _ZikrPalette.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Center(
                    child: FilledButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(AppStrings.dhikrStartAgain),
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark
                            ? _ZikrPalette.darkAccent
                            : _ZikrPalette.lightAccent,
                        foregroundColor: Colors.white,
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
                      color: isDark
                          ? _ZikrPalette.darkTextSecondary
                          : _ZikrPalette.lightTextSecondary,
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
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? const [
                                        _ZikrPalette.darkOrbTop,
                                        _ZikrPalette.darkOrbBottom,
                                      ]
                                    : const [
                                        _ZikrPalette.lightOrbTop,
                                        _ZikrPalette.lightOrbBottom,
                                      ],
                              ),
                              border: Border.all(
                                color: isDark
                                    ? _ZikrPalette.darkAccentSoft
                                        .withOpacity(0.62)
                                    : Colors.white.withOpacity(0.84),
                                width: 2.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? _ZikrPalette.darkAccent
                                          .withOpacity(0.50)
                                      : _ZikrPalette.lightAccent
                                          .withOpacity(0.36),
                                  blurRadius: 34,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: isDark
                                      ? _ZikrPalette.darkAccentSoft
                                          .withOpacity(0.32)
                                      : _ZikrPalette.lightAccentSoft
                                          .withOpacity(0.38),
                                  blurRadius: 56,
                                  spreadRadius: 18,
                                ),
                                if (isDark)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.26),
                                    blurRadius: 22,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      shadows: isDark
                                          ? [
                                              Shadow(
                                                color: _ZikrPalette
                                                    .darkAccentSoft
                                                    .withOpacity(0.40),
                                                blurRadius: 12,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  _transliteration[_phase],
                                  textAlign: TextAlign.center,
                                  style: AppTypography.labelLarge(context)
                                      .copyWith(
                                    color: Colors.white.withOpacity(0.88),
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
                      color: isDark
                          ? _ZikrPalette.darkTextPrimary
                          : _ZikrPalette.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.dhikrPhaseNofM(_phase + 1, 3),
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: isDark
                          ? _ZikrPalette.darkTextSecondary
                          : _ZikrPalette.lightTextSecondary,
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
                        color: isDark
                            ? _ZikrPalette.darkTextSecondary
                            : _ZikrPalette.lightBorder,
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

class _ZikrPalette {
  // ── Light mode ──
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);

  static const Color lightBorder = Color(0xFFBC95D8);

  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  // ── Dark mode ──
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);
}
