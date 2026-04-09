import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
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
                        color: context.palette.onSurfaceVariant,
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
                  color: context.palette.onSurfaceVariant,
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
    return Row(
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
    );
  }

  Widget _buildContentRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _contentCard(
            context,
            icon: Icons.auto_stories_rounded,
            label: AppStrings.moodContentAyahsLabel,
            subtitle: AppStrings.moodContentAyahsSubtitle,
            accent: context.palette.primary,
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
            onTap: () => _onContentSelected(false),
          ),
        ),
      ],
    );
  }

  Widget _contentCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: context.palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusXl,
          boxShadow: [
            BoxShadow(
              color: context.palette.onSurface.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: accent),
            const SizedBox(height: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.titleMedium(context),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall(context).copyWith(
                color: context.palette.onSurfaceVariant,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: context.palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusXl,
          boxShadow: [
            BoxShadow(
              color: context.palette.onSurface.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isPositive ? context.palette.primary : context.palette.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.titleMedium(context),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall(context).copyWith(
                color: context.palette.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
