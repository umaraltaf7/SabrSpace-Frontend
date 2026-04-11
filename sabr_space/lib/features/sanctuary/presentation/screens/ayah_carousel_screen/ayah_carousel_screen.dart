import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _AyahPalette.darkBackgroundTop,
                    _AyahPalette.darkBackgroundMid,
                    _AyahPalette.darkBackgroundBottom,
                  ]
                : const [
                    _AyahPalette.lightBackgroundTop,
                    _AyahPalette.lightBackgroundMid,
                    _AyahPalette.lightBackgroundBottom,
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
                        decoration: BoxDecoration(
                          gradient: index == _currentPage
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? const [
                                          _AyahPalette.darkCardTop,
                                          _AyahPalette.darkCardBottom,
                                        ]
                                      : const [
                                          _AyahPalette.lightCardTop,
                                          _AyahPalette.lightCardBottom,
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
                                  ? _AyahPalette.darkShadow.withOpacity(0.58)
                                  : _AyahPalette.lightShadow.withOpacity(0.34),
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
                                    painter: _CardDecorPainter(
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
                            ],
                          ),
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
                          ? (isDark
                              ? _AyahPalette.darkAccent
                              : _AyahPalette.lightAccent)
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

class _CardDecorPainter extends CustomPainter {
  _CardDecorPainter({required this.isDark, required this.isActive});

  final bool isDark;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    final moonColor = (isDark ? const Color(0xFFF8DEAA) : const Color(0xFFF9EACB))
        .withOpacity(0.92);
    final center = Offset(size.width * 0.18, size.height * 0.20);
    final radius = size.width * 0.09;

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

    final star = Paint()..color = Colors.white.withOpacity(isDark ? 0.60 : 0.75);
    final rng = Random(17);
    for (int i = 0; i < 14; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height * 0.45),
        rng.nextDouble() * 1.2 + 0.3,
        star,
      );
    }

    final branch = Paint()
      ..color = (isDark ? const Color(0xFF7A4B95) : const Color(0xFFD2B6E8))
          .withOpacity(0.45)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.96, size.height * 0.88),
      Offset(size.width * 0.78, size.height * 0.68),
      branch,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.86, size.height * 0.74),
        width: 12,
        height: 7,
      ),
      Paint()..color = branch.color,
    );
  }

  @override
  bool shouldRepaint(covariant _CardDecorPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.isActive != isActive;
  }
}

class _AyahPalette {
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

