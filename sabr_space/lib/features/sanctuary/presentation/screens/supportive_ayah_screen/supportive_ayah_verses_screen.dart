import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Comforting Quranic verses after a difficult mood check-in.
///
/// Verses are shown in a horizontal carousel. "Need further support" opens
/// `/mood-further-support`.
class SupportiveAyahVersesScreen extends StatefulWidget {
  const SupportiveAyahVersesScreen({super.key});

  @override
  State<SupportiveAyahVersesScreen> createState() =>
      _SupportiveAyahVersesScreenState();
}

class _SupportiveAyahVersesScreenState extends State<SupportiveAyahVersesScreen> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  /// Same viewport height as [AyahCarouselScreen] so cards align and feel the same size.
  static const double _carouselViewportHeight = 420;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    final ayahs = AppStrings.supportiveAyahs;
    if (ayahs.isEmpty) return;
    final next = (_pageIndex + 1) % ayahs.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ayahs = AppStrings.supportiveAyahs;
    final cs = Theme.of(context).colorScheme;
    final p = context.palette;
    final accent = p.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      AppStrings.appName,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: p.primary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.dailySolaceEyebrow,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall(context).copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                ),
                child: Text(
                  AppStrings.findPeaceInHisWords,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineSmall(context).copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              if (ayahs.isNotEmpty) ...[
                const Spacer(),
                SizedBox(
                  height: _carouselViewportHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        padEnds: true,
                        onPageChanged: (i) =>
                            setState(() => _pageIndex = i),
                        itemCount: ayahs.length,
                        itemBuilder: (context, index) {
                          final active = index == _pageIndex;
                          return AnimatedScale(
                            scale: active ? 1.0 : 0.92,
                            duration: const Duration(milliseconds: 300),
                            child: _AyahCarouselCard(
                              ayah: ayahs[index],
                              isActive: active,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: AppSpacing.sm,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Material(
                            color: cs.surfaceContainerHighest,
                            elevation: 0,
                            shape: const CircleBorder(),
                            shadowColor:
                                cs.shadow.withValues(alpha: 0.12),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _goNext,
                              child: Ink(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: cs.outlineVariant
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: accent,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                if (ayahs.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      ayahs.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _pageIndex ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.borderRadiusFull,
                          color: i == _pageIndex
                              ? accent
                              : cs.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
              ],

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

/// Matches [AyahCarouselScreen] card styling (good mood check-in path).
class _AyahCarouselCard extends StatelessWidget {
  const _AyahCarouselCard({
    required this.ayah,
    required this.isActive,
  });

  final Map<String, String> ayah;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    // Structure matches [AyahCarouselScreen] item card (same margin, padding, typography).
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: isActive ? AppGradients.primaryGradient(context) : null,
        color: isActive ? null : p.surfaceContainerLowest,
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: [
          BoxShadow(
            color: p.primary.withValues(alpha: 0.15),
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
              color: isActive ? Colors.white : p.onBackground,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            ayah['english']!,
            style: AppTypography.bodyMedium(context).copyWith(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.9)
                  : p.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 40,
            height: 2,
            color: isActive
                ? Colors.white.withValues(alpha: 0.3)
                : p.outlineVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            ayah['reflection']!,
            style: AppTypography.bodySmall(context).copyWith(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.7)
                  : p.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

