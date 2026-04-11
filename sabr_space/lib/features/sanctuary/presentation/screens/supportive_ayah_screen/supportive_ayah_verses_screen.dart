import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final p = context.palette;
    final accent = isDark
        ? _PanicPalette.darkAccent
        : _PanicPalette.lightAccent;

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
                                  color: isDark
                                      ? _PanicPalette.darkAccent
                                      : _PanicPalette.lightAccent,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = context.palette;

    // Structure matches [AyahCarouselScreen] item card (same margin, padding, typography).
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: isActive
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
        color: isActive ? null : p.surfaceContainerLowest,
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
                  painter: _DecorPainter(
                    isDark: isDark,
                    isActive: isActive,
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
  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);
  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccent = Color(0xFFE0B2F0);
}

class _DecorPainter extends CustomPainter {
  _DecorPainter({required this.isDark, required this.isActive});

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

    final branchColor = (isDark ? const Color(0xFF7A4B95) : const Color(0xFFD2B6E8))
        .withOpacity(0.45);
    final branch = Paint()
      ..color = branchColor
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
      Paint()..color = branchColor,
    );
  }

  @override
  bool shouldRepaint(covariant _DecorPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.isActive != isActive;
  }
}

