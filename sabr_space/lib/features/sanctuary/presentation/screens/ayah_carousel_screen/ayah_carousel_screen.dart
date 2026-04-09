import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Ayah Carousel — swipeable Quranic verse cards with Arabic + English.
class AyahCarouselScreen extends StatefulWidget {
  const AyahCarouselScreen({super.key});

  @override
  State<AyahCarouselScreen> createState() => _AyahCarouselScreenState();
}

class _AyahCarouselScreenState extends State<AyahCarouselScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      'Ayah Carousel',
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

              // ── Page View ──
              SizedBox(
                height: 420,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: AppStrings.ayahs.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final ayah = AppStrings.ayahs[index];
                    return AnimatedScale(
                      scale: index == _currentPage ? 1.0 : 0.92,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm),
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
                              color:
                              context.palette.primary.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ayah['arabic']!,
                              style: AppTypography.arabicVerse(context).copyWith(
                                color: index == _currentPage
                                    ? Colors.white
                                    : context.palette.onBackground,
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              ayah['english']!,
                              style: AppTypography.bodyMedium(context).copyWith(
                                color: index == _currentPage
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : context.palette.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              width: 40,
                              height: 2,
                              color: index == _currentPage
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : context.palette.outlineVariant.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              ayah['reflection']!,
                              style: AppTypography.bodySmall(context).copyWith(
                                color: index == _currentPage
                                    ? Colors.white.withValues(alpha: 0.7)
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

              // ── Page indicators ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AppStrings.ayahs.length,
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
            ],
          ),
        ),
      ),
    );
  }
}

