import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final showFurtherSupport = !widget.args.isPositiveMood;

    return Scaffold(
      body: Container(
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
                        decoration: BoxDecoration(
                          gradient: index == _currentPage
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? const [
                                          _PanicPalette.darkCardTop,
                                          _PanicPalette.darkCardBottom,
                                        ]
                                      : const [
                                          _PanicPalette.lightCardTop,
                                          _PanicPalette.lightCardBottom,
                                        ],
                                )
                              : null,
                          color: index != _currentPage
                              ? context.palette.surfaceContainerLowest
                              : null,
                          borderRadius: AppSpacing.borderRadiusXl,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _PanicPalette.darkShadow.withOpacity(0.58)
                                  : _PanicPalette.lightShadow.withOpacity(0.34),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: AppSpacing.borderRadiusXl,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: CustomPaint(
                                    painter: _QuoteDecorPainter(
                                      isDark: isDark,
                                      isActive: index == _currentPage,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: AppSpacing.cardPadding,
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
                            ],
                          ),
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
                          ? (isDark
                              ? _PanicPalette.darkAccent
                              : _PanicPalette.lightAccent)
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

class _PanicPalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundMid = Color(0xFFF7EEFF);
  static const Color lightBackgroundBottom = Color(0xFFF1E4FB);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundMid = Color(0xFF40204F);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);
  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);
  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccent = Color(0xFFE0B2F0);
}

class _QuoteDecorPainter extends CustomPainter {
  _QuoteDecorPainter({required this.isDark, required this.isActive});

  final bool isDark;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    final moonColor = (isDark ? const Color(0xFFF8DEAA) : const Color(0xFFF9EACB))
        .withOpacity(0.90);
    final center = Offset(size.width * 0.18, size.height * 0.20);
    final radius = size.width * 0.07;
    final moonPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final cutPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(radius * 0.42, -radius * 0.14),
          radius: radius * 0.84,
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, moonPath, cutPath),
      Paint()..color = moonColor,
    );

    final star = Paint()..color = Colors.white.withOpacity(isDark ? 0.58 : 0.72);
    final rng = Random(23);
    for (int i = 0; i < 16; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height * 0.42),
        rng.nextDouble() * 1.2 + 0.3,
        star,
      );
    }

    final branchColor = (isDark ? const Color(0xFF7A4B95) : const Color(0xFFD2B6E8))
        .withOpacity(0.42);
    final branchPaint = Paint()
      ..color = branchColor
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.02, size.height * 0.86),
      Offset(size.width * 0.20, size.height * 0.68),
      branchPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.12, size.height * 0.76),
        width: 12,
        height: 7,
      ),
      Paint()..color = branchColor,
    );
  }

  @override
  bool shouldRepaint(covariant _QuoteDecorPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.isActive != isActive;
  }
}
