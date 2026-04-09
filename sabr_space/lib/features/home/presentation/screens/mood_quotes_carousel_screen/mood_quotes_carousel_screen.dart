import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/home/presentation/models/mood_quotes_args.dart';

/// Swipeable English-only quote cards after mood check-in (quotes path).
class MoodQuotesCarouselScreen extends StatefulWidget {
  const MoodQuotesCarouselScreen({
    super.key,
    this.args = MoodQuotesArgs.defaultPositive,
  });

  final MoodQuotesArgs args;

  @override
  State<MoodQuotesCarouselScreen> createState() => _MoodQuotesCarouselScreenState();
}

class _MoodQuotesCarouselScreenState extends State<MoodQuotesCarouselScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  List<Map<String, String>> get _quotes => widget.args.isPositiveMood
      ? AppStrings.moodPositiveEnglishQuotes
      : AppStrings.moodNegativeEnglishQuotes;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotes = _quotes;
    final cs = Theme.of(context).colorScheme;
    final showFurtherSupport = !widget.args.isPositiveMood;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      AppStrings.moodQuotesCarouselTitle,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: context.palette.primary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 420,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: quotes.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final item = quotes[index];
                    final quote = item['quote']!;
                    final reflection = item['reflection']!;
                    return AnimatedScale(
                      scale: index == _currentPage ? 1.0 : 0.92,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          gradient: index == _currentPage
                              ? AppGradients.primaryGradient(context)
                              : null,
                          color: index != _currentPage
                              ? context.palette.surfaceContainerLowest
                              : null,
                          borderRadius: AppSpacing.borderRadiusXl,
                          boxShadow: [
                            BoxShadow(
                              color: context.palette.primary.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '"$quote"',
                              style: AppTypography.titleMedium(context).copyWith(
                                color: index == _currentPage
                                    ? Colors.white
                                    : context.palette.onBackground,
                                fontStyle: FontStyle.italic,
                                height: 1.45,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Container(
                              width: 40,
                              height: 2,
                              color: index == _currentPage
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : context.palette.outlineVariant.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              reflection,
                              style: AppTypography.bodySmall(context).copyWith(
                                color: index == _currentPage
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : context.palette.outline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  quotes.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? context.palette.primary
                          : context.palette.outlineVariant,
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (showFurtherSupport)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                    MediaQuery.paddingOf(context).bottom + AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.supportiveAyahExhaustedPrompt,
                        textAlign: TextAlign.center,
                        style: AppTypography.labelSmall(context).copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton.icon(
                        onPressed: () =>
                            context.push('/mood-further-support'),
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
                          elevation: 1,
                          shadowColor: cs.shadow.withValues(alpha: 0.2),
                        ),
                        icon: Icon(
                          Icons.headset_mic_rounded,
                          size: 22,
                          color: cs.onPrimary,
                        ),
                        label: Text(
                          AppStrings.needFurtherSupportButton,
                          style: AppTypography.labelLarge(context).copyWith(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
