import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/home/presentation/models/mood_quotes_args.dart';

/// "How are you feeling?" then Ayahs vs English quotes for either mood.
class MoodCheckScreen extends StatefulWidget {
  const MoodCheckScreen({super.key});

  @override
  State<MoodCheckScreen> createState() => _MoodCheckScreenState();
}

class _MoodCheckScreenState extends State<MoodCheckScreen> {
  /// 0 = pick mood, 1 = pick ayahs vs quotes.
  int _step = 0;
  bool? _isPositiveMood;

  void _onMoodSelected(bool isPositive) {
    setState(() {
      _isPositiveMood = isPositive;
      _step = 1;
    });
  }

  void _onContentSelected(bool wantAyahs) {
    final pos = _isPositiveMood;
    if (pos == null) return;
    if (wantAyahs) {
      if (pos) {
        context.push('/ayah-carousel');
      } else {
        context.push('/supportive-ayah');
      }
    } else {
      context.push(
        '/mood-quotes',
        extra: MoodQuotesArgs(isPositiveMood: pos),
      );
    }
  }

  void _onBack() {
    if (_step == 1) {
      setState(() {
        _step = 0;
        _isPositiveMood = null;
      });
    } else {
      navigateBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _PanicPalette.darkBackgroundTop,
                    _PanicPalette.darkBackgroundMid,
                    _PanicPalette.darkBackgroundBottom,
                  ]
                : const [
                    _PanicPalette.lightBackgroundTop,
                    _PanicPalette.lightBackgroundMid,
                    _PanicPalette.lightBackgroundBottom,
                  ],
            stops: const [0.0, 0.48, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    ScreenBackButton(onPressed: _onBack),
                    const Spacer(),
                    Text(
                      AppStrings.checkInWithHeart,
                      style: AppTypography.labelSmall(context).copyWith(
                        letterSpacing: 1.5,
                        color: isDark
                            ? _PanicPalette.darkTextSecondary
                            : _PanicPalette.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Spacer(),

              // ── Heading ──
              Text(
                _step == 0
                    ? AppStrings.howAreYouFeeling
                    : AppStrings.moodChooseContentTitle,
                style: AppTypography.headlineLarge(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _step == 0
                    ? AppStrings.takeABreath
                    : AppStrings.moodChooseContentSubtitle,
                style: AppTypography.labelSmall(context).copyWith(
                  letterSpacing: 1.5,
                  color: isDark
                      ? _PanicPalette.darkTextSecondary
                      : _PanicPalette.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.jumbo),

              // ── Step 1: mood ── / Step 2: content type ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                child: _step == 0 ? _buildMoodRow(context) : _buildContentRow(context),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodRow(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _moodCard(
              context,
              icon: Icons.sentiment_satisfied_alt,
              label: AppStrings.good,
              subtitle: AppStrings.peacefulBalanced,
              isPositive: true,
              onTap: () => _onMoodSelected(true),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: _moodCard(
              context,
              icon: Icons.sentiment_dissatisfied,
              label: AppStrings.notGood,
              subtitle: AppStrings.restlessHeavy,
              isPositive: false,
              onTap: () => _onMoodSelected(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentRow(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _contentCard(
              context,
              icon: Icons.auto_stories_rounded,
              label: AppStrings.moodContentAyahsLabel,
              subtitle: AppStrings.moodContentAyahsSubtitle,
              accent: context.palette.primary,
              isDark: Theme.of(context).brightness == Brightness.dark,
              onTap: () => _onContentSelected(true),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: _contentCard(
              context,
              icon: Icons.format_quote_rounded,
              label: AppStrings.moodContentQuotesLabel,
              subtitle: AppStrings.moodContentQuotesSubtitle,
              accent: context.palette.secondary,
              isDark: Theme.of(context).brightness == Brightness.dark,
              onTap: () => _onContentSelected(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color accent,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _PanicPalette.darkCardTop,
                    _PanicPalette.darkCardBottom,
                  ]
                : const [
                    _PanicPalette.lightCardTop,
                    _PanicPalette.lightCardBottom,
                  ],
          ),
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(
            color: isDark
                ? _PanicPalette.darkBorder.withOpacity(0.35)
                : _PanicPalette.lightBorder.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _PanicPalette.darkShadow.withOpacity(0.48)
                  : _PanicPalette.lightShadow.withOpacity(0.32),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: accent),
            const SizedBox(height: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.titleMedium(context).copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall(context).copyWith(
                color: Colors.white.withOpacity(0.84),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isPositive,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _PanicPalette.darkCardTop,
                    _PanicPalette.darkCardBottom,
                  ]
                : const [
                    _PanicPalette.lightCardTop,
                    _PanicPalette.lightCardBottom,
                  ],
          ),
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(
            color: isDark
                ? _PanicPalette.darkBorder.withOpacity(0.35)
                : _PanicPalette.lightBorder.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _PanicPalette.darkShadow.withOpacity(0.48)
                  : _PanicPalette.lightShadow.withOpacity(0.32),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isPositive
                  ? (isDark ? _PanicPalette.darkAccent : _PanicPalette.lightAccent)
                  : context.palette.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.titleMedium(context).copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall(context).copyWith(
                color: Colors.white.withOpacity(0.84),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PanicPalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundMid = Color(0xFFF7EEFF);
  static const Color lightBackgroundBottom = Color(0xFFF1E4FB);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundMid = Color(0xFF40204F);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);
  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);
  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);
  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccent = Color(0xFFE0B2F0);
}
