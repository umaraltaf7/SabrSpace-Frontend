import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? _HomePalette.darkBackgroundBottom
          : _HomePalette.lightBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _HomePalette.darkBackgroundTop,
                    _HomePalette.darkBackgroundBottom,
                  ]
                : const [
                    _HomePalette.lightBackgroundTop,
                    _HomePalette.lightBackgroundBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreetingRow(context),
                const SizedBox(height: AppSpacing.xxl),
                _buildHero(context, isDark),
                const SizedBox(height: AppSpacing.huge),
                _buildQuickOptions(context, isDark),
                const SizedBox(height: AppSpacing.massive),
                _buildSectionHeader(context, isDark),
                const SizedBox(height: AppSpacing.xxxl),
                _buildMeditationCards(context, isDark),
                const SizedBox(height: AppSpacing.mega),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Salam, ',
                style: AppTypography.headlineSmall(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? _HomePalette.darkTextPrimary
                      : _HomePalette.lightTextPrimary,
                ),
              ),
              TextSpan(
                text: 'Aisha',
                style: AppTypography.headlineSmall(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? _HomePalette.darkTextSecondary
                      : _HomePalette.lightTextSecondary,
                ),
              ),
              TextSpan(
                text: ' ✨',
                style: AppTypography.titleLarge(
                  context,
                ).copyWith(color: _HomePalette.gold),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Container(
            width: 68,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [
                        _HomePalette.darkSurface,
                        _HomePalette.darkSurfaceElevated,
                      ]
                    : const [
                        _HomePalette.lightSurfaceSoft,
                        _HomePalette.lightSurface,
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? _HomePalette.darkBorder.withOpacity(0.72)
                    : _HomePalette.lightBorder.withOpacity(0.98),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? _HomePalette.darkShadow.withOpacity(0.52)
                      : _HomePalette.lightShadow.withOpacity(0.48),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 26,
                color: isDark
                    ? _HomePalette.darkTextPrimary
                    : _HomePalette.lightAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => context.push('/mood-check'),
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [_HomePalette.darkHeroTop, _HomePalette.darkHeroBottom]
                : const [
                    _HomePalette.lightHeroTop,
                    _HomePalette.lightHeroBottom,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _HomePalette.darkShadow.withOpacity(0.80)
                  : _HomePalette.lightShadow.withOpacity(0.82),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.black.withOpacity(0.22)
                : Colors.white.withOpacity(0.12),
            width: 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _HeroScenePainter(isDark: isDark)),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(isDark ? 0.16 : 0.26),
                          Colors.transparent,
                          Colors.white.withOpacity(isDark ? 0.04 : 0.10),
                        ],
                        stops: const [0.0, 0.48, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              if (isDark)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.05,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.22),
                        ],
                        stops: const [0.62, 1.0],
                      ),
                    ),
                  ),
                ),
              if (!isDark)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.06,
                        colors: [
                          Colors.transparent,
                          _HomePalette.lightHeroBottom.withOpacity(0.62),
                        ],
                        stops: const [0.60, 1.0],
                      ),
                    ),
                  ),
                ),
              Center(
                child: Container(
                  width: 194,
                  height: 194,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? _HomePalette.darkAccent.withOpacity(0.38)
                          : Colors.white.withOpacity(0.35),
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _HomePalette.darkAccent.withOpacity(0.36)
                            : _HomePalette.lightAccent.withOpacity(0.34),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                      if (isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.22),
                          blurRadius: 30,
                          spreadRadius: 6,
                        ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 164,
                  height: 164,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? const [
                              _HomePalette.darkOrbTop,
                              _HomePalette.darkOrbBottom,
                            ]
                          : const [
                              _HomePalette.lightOrbTop,
                              _HomePalette.lightOrbBottom,
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? _HomePalette.darkAccentSoft.withOpacity(0.62)
                          : Colors.white.withOpacity(0.84),
                      width: 2.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _HomePalette.darkAccent.withOpacity(0.66)
                            : _HomePalette.lightAccent.withOpacity(0.46),
                        blurRadius: 34,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: isDark
                            ? _HomePalette.darkAccentSoft.withOpacity(0.44)
                            : _HomePalette.lightAccentSoft.withOpacity(0.46),
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
                  child: Center(
                    child: Text(
                      'Peace',
                      style: AppTypography.headlineMedium(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        shadows: isDark
                            ? [
                                Shadow(
                                  color: _HomePalette.darkAccentSoft
                                      .withOpacity(0.40),
                                  blurRadius: 12,
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.28),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickOptions(BuildContext context, bool isDark) {
    const options = <_QuickOption>[
      _QuickOption(
        icon: Icons.air_rounded,
        label: 'Breathe',
        route: '/breathe',
      ),
      _QuickOption(
        icon: Icons.nights_stay_rounded,
        label: 'Dhikr',
        route: '/dhikr',
      ),
      _QuickOption(
        icon: Icons.auto_stories_rounded,
        label: 'Journal',
        route: '/journal',
      ),
      _QuickOption(
        icon: Icons.local_fire_department_rounded,
        label: 'Grief Burner',
        route: '/grief-write',
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((item) {
        return GestureDetector(
          onTap: () => context.push(item.route),
          child: SizedBox(
            width: 78,
            child: Column(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? const [
                              _HomePalette.darkSurfaceElevated,
                              _HomePalette.darkSurface,
                            ]
                          : const [
                              _HomePalette.lightSurfaceSoft,
                              _HomePalette.lightSurfaceElevated,
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? _HomePalette.darkBorder.withOpacity(0.48)
                          : _HomePalette.lightBorder,
                      width: 1.35,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _HomePalette.darkShadow.withOpacity(0.38)
                            : _HomePalette.lightShadow.withOpacity(0.50),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    color: isDark
                        ? _HomePalette.darkTextPrimary
                        : _HomePalette.lightAccent,
                    size: 30,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall(context).copyWith(
                    color: isDark
                        ? _HomePalette.darkTextPrimary
                        : _HomePalette.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  _HomePalette.darkSurfaceElevated,
                  _HomePalette.darkSurface,
                ]
              : const [
                  _HomePalette.lightSurface,
                  _HomePalette.lightSurfaceSoft,
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? _HomePalette.darkBorder.withOpacity(0.40)
              : _HomePalette.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? _HomePalette.darkShadow.withOpacity(0.34)
                : _HomePalette.lightShadow.withOpacity(0.38),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? _HomePalette.darkAccent.withOpacity(0.34)
                  : _HomePalette.lightAccentSoft,
            ),
            child: Icon(
              Icons.nights_stay_rounded,
              color: isDark
                  ? _HomePalette.darkAccentSoft
                  : _HomePalette.lightAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Audios & Meditation',
              style: AppTypography.titleMedium(context).copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? _HomePalette.darkTextPrimary
                    : _HomePalette.lightTextPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/audio-library'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'see all',
                  style: AppTypography.labelMedium(context).copyWith(
                    color: isDark
                        ? _HomePalette.darkTextSecondary
                        : _HomePalette.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? _HomePalette.darkTextSecondary
                      : _HomePalette.lightTextSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCards(BuildContext context, bool isDark) {
    const items = <_MeditationCardData>[
      _MeditationCardData(title: 'Finding Strength', minutes: 9),
      _MeditationCardData(title: 'Release Intense', minutes: 9),
      _MeditationCardData(title: 'Inner Calm', minutes: 12),
      _MeditationCardData(title: 'Gentle Healing', minutes: 7),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - AppSpacing.lg * 2 - AppSpacing.md) / 2;

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => _MeditationCard(
          item: items[index],
          width: cardWidth,
          sceneIndex: index,
        ),
      ),
    );
  }
}

class _QuickOption {
  final IconData icon;
  final String label;
  final String route;

  const _QuickOption({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _MeditationCardData {
  final String title;
  final int minutes;

  const _MeditationCardData({required this.title, required this.minutes});
}

class _MeditationCard extends StatelessWidget {
  const _MeditationCard({
    required this.item,
    required this.width,
    required this.sceneIndex,
  });

  final _MeditationCardData item;
  final double width;
  final int sceneIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/audio-library'),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_HomePalette.darkCardTop, _HomePalette.darkCardBottom]
                : const [
                    _HomePalette.lightCardTop,
                    _HomePalette.lightCardBottom,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _HomePalette.darkShadow.withOpacity(0.62)
                  : _HomePalette.lightShadow.withOpacity(0.78),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.black.withOpacity(0.24)
                : Colors.white.withOpacity(0.10),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardScenePainter(
                    isDark: isDark,
                    sceneIndex: sceneIndex,
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(isDark ? 0.14 : 0.24),
                          Colors.transparent,
                          Colors.white.withOpacity(isDark ? 0.03 : 0.09),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              if (isDark)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.08,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.26),
                        ],
                        stops: const [0.60, 1.0],
                      ),
                    ),
                  ),
                ),
              if (!isDark)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.10,
                        colors: [
                          Colors.transparent,
                          _HomePalette.lightCardBottom.withOpacity(0.66),
                        ],
                        stops: const [0.58, 1.0],
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleSmall(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          '${item.minutes} min',
                          style: AppTypography.bodySmall(
                            context,
                          ).copyWith(color: Colors.white.withOpacity(0.96)),
                        ),
                        const Spacer(),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? _HomePalette.darkPlayButton
                                : _HomePalette.lightPlayButton,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
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

class _HomePalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFFFFFFF);

  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);
  static const Color lightSurfaceElevated = Color(0xFFC9A7E2);

  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);

  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightHeroTop = Color(0xFF552688);
  static const Color lightHeroBottom = Color(0xFF3B1A66);

  static const Color darkHeroTop = Color(0xFF5A2F79);
  static const Color darkHeroBottom = Color(0xFF763E9D);

  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);

  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);

  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);

  static const Color lightPlayButton = Color(0xFF6A33A2);
  static const Color darkPlayButton = Color(0xFFC998E5);

  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);

  static const Color gold = Color(0xFFF2D28A);
}

class _HeroScenePainter extends CustomPainter {
  final bool isDark;

  _HeroScenePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    _paintClouds(canvas, size);
    _paintHills(canvas, size);
    _paintBranches(canvas, size);
    _paintMoon(canvas, size);
    _paintSparkles(canvas, size);
  }

  void _paintMoon(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.28, size.height * 0.36);
    final radius = size.width * 0.22;

    final moonColor = isDark
        ? const Color(0xFFF8DEAA)
        : const Color(0xFFF9EACB);

    canvas.drawCircle(
      center,
      radius * 2.0,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.12 : 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(
      center,
      radius * 1.4,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.18 : 0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    final cutPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(radius * 0.38, -radius * 0.15),
          radius: radius * 0.92,
        ),
      );
    final crescent = Path.combine(PathOperation.difference, moonPath, cutPath);

    canvas.drawPath(
      crescent,
      Paint()..color = moonColor.withOpacity(isDark ? 0.96 : 1.0),
    );

    canvas.drawPath(
      crescent,
      Paint()
        ..color = Colors.white.withOpacity(isDark ? 0.28 : 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  void _paintClouds(Canvas canvas, Size size) {
    final cloudColor = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.white.withOpacity(0.28);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.18),
        width: size.width * 0.55,
        height: size.height * 0.14,
      ),
      Paint()
        ..color = cloudColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.62),
        width: size.width * 0.42,
        height: size.height * 0.10,
      ),
      Paint()
        ..color = cloudColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.78, size.height * 0.48),
        width: size.width * 0.38,
        height: size.height * 0.09,
      ),
      Paint()
        ..color = cloudColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
  }

  void _paintHills(Canvas canvas, Size size) {
    final farColor = isDark
        ? const Color(0xFF7A4B95).withOpacity(0.50)
        : const Color(0xFFD2B6E8).withOpacity(0.54);

    final far = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.58,
        size.width * 0.48,
        size.height * 0.70,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.82,
        size.width,
        size.height * 0.64,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(far, Paint()..color = farColor);

    final nearColor = isDark
        ? const Color(0xFF4B285F).withOpacity(0.86)
        : const Color(0xFFA978CC).withOpacity(0.50);

    final near = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.84)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.73,
        size.width * 0.58,
        size.height * 0.82,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.90,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(near, Paint()..color = nearColor);
  }

  void _paintBranches(Canvas canvas, Size size) {
    final leafA = isDark
        ? const Color(0xFF6C3D83).withOpacity(0.88)
        : const Color(0xFFB785D5).withOpacity(0.56);
    final leafB = isDark
        ? const Color(0xFF48285A).withOpacity(0.92)
        : const Color(0xFFDCC4EE).withOpacity(0.54);
    final leafC = isDark
        ? const Color(0xFF8D59AA).withOpacity(0.72)
        : const Color(0xFFC898DF).withOpacity(0.50);

    _drawStem(
      canvas,
      Offset(size.width + 2, size.height * 0.05),
      Offset(size.width * 0.78, size.height * 0.38),
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.97, size.height * 0.04),
      -0.5,
      36,
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.94, size.height * 0.10),
      -0.8,
      32,
      leafC,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.91, size.height * 0.17),
      -1.1,
      30,
      leafB,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.88, size.height * 0.24),
      -1.4,
      26,
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.85, size.height * 0.30),
      -1.6,
      22,
      leafC,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.82, size.height * 0.36),
      -1.9,
      20,
      leafB,
    );

    _drawLeaf(
      canvas,
      Offset(size.width * 0.98, size.height * 0.16),
      -0.2,
      22,
      leafB,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.96, size.height * 0.26),
      -0.4,
      18,
      leafC,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.86, size.height * 0.08),
      -0.3,
      26,
      leafB,
    );

    _drawStem(
      canvas,
      Offset(size.width + 2, size.height * 0.65),
      Offset(size.width * 0.88, size.height * 0.80),
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.97, size.height * 0.66),
      -2.0,
      24,
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.94, size.height * 0.72),
      -2.3,
      20,
      leafC,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.91, size.height * 0.78),
      -2.6,
      18,
      leafB,
    );

    _drawStem(
      canvas,
      Offset(-2, size.height * 0.50),
      Offset(size.width * 0.16, size.height * 0.72),
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.02, size.height * 0.50),
      0.5,
      30,
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.05, size.height * 0.56),
      0.2,
      26,
      leafC,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.08, size.height * 0.63),
      -0.1,
      22,
      leafB,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.11, size.height * 0.69),
      -0.4,
      20,
      leafA,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.01, size.height * 0.44),
      0.9,
      24,
      leafB,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.14, size.height * 0.74),
      -0.6,
      16,
      leafC,
    );

    _drawLeaf(
      canvas,
      Offset(size.width * 0.03, size.height * 0.06),
      0.4,
      20,
      leafB,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.01, size.height * 0.14),
      0.7,
      16,
      leafC,
    );
  }

  void _drawStem(Canvas canvas, Offset from, Offset to, Color color) {
    canvas.drawLine(
      from,
      to,
      Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawLeaf(
    Canvas canvas,
    Offset base,
    double angle,
    double len,
    Color color,
  ) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(angle);

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(len * 0.35, -len * 0.24, len, 0)
      ..quadraticBezierTo(len * 0.35, len * 0.24, 0, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final bright = isDark
        ? Colors.white.withOpacity(1.0)
        : Colors.white.withOpacity(0.96);
    final dim = isDark
        ? Colors.white.withOpacity(0.90)
        : Colors.white.withOpacity(0.90);
    final warm = isDark
        ? const Color(0xFFF8DEAA).withOpacity(1.0)
        : const Color(0xFFF9EACB).withOpacity(0.99);

    _drawSparkle(
      canvas,
      Offset(size.width * 0.70, size.height * 0.10),
      5.0,
      bright,
      glow: true,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.56, size.height * 0.07),
      3.5,
      bright,
      glow: true,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.80, size.height * 0.36),
      4.0,
      bright,
      glow: true,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.18, size.height * 0.14),
      3.0,
      bright,
      glow: true,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.62, size.height * 0.16),
      2.8,
      warm,
      glow: true,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.30, size.height * 0.22),
      2.2,
      warm,
    );

    _drawSparkle(
      canvas,
      Offset(size.width * 0.44, size.height * 0.18),
      2.5,
      dim,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.66, size.height * 0.26),
      2.0,
      dim,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.36, size.height * 0.40),
      2.0,
      dim,
    );
    _drawSparkle(
      canvas,
      Offset(size.width * 0.75, size.height * 0.22),
      2.5,
      dim,
    );

    final dotColor = isDark
        ? Colors.white.withOpacity(0.48)
        : Colors.white.withOpacity(0.62);

    final rng = Random(7);
    for (int i = 0; i < 14; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.50;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.3 + 0.4,
        Paint()..color = dotColor,
      );
    }
  }

  void _drawSparkle(
    Canvas canvas,
    Offset c,
    double r,
    Color color, {
    bool glow = false,
  }) {
    if (glow) {
      canvas.drawCircle(
        c,
        r * 2.8,
        Paint()
          ..color = color.withOpacity(0.30)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + r * 0.15, c.dy - r * 0.15)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx + r * 0.15, c.dy + r * 0.15)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - r * 0.15, c.dy + r * 0.15)
      ..lineTo(c.dx - r, c.dy)
      ..lineTo(c.dx - r * 0.15, c.dy - r * 0.15)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _HeroScenePainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _CardScenePainter extends CustomPainter {
  final bool isDark;
  final int sceneIndex;

  _CardScenePainter({required this.isDark, required this.sceneIndex});

  @override
  void paint(Canvas canvas, Size size) {
    _paintSky(canvas, size);
    _paintMountains(canvas, size);
    _paintGround(canvas, size);
    _paintMoon(canvas, size);
    _paintBench(canvas, size);
    _paintStars(canvas, size);
  }

  void _paintSky(Canvas canvas, Size size) {
    final skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [const Color(0xFF8E59AE).withOpacity(0.40), Colors.transparent]
          : [const Color(0xFFE7CFF4).withOpacity(0.46), Colors.transparent],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.5),
      Paint()
        ..shader = skyGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height * 0.5),
        ),
    );
  }

  void _paintMoon(Canvas canvas, Size size) {
    final isLeft = sceneIndex.isEven;
    final center = Offset(
      isLeft ? size.width * 0.25 : size.width * 0.75,
      size.height * 0.16,
    );
    final radius = size.width * 0.07;

    final moonColor = isDark
        ? const Color(0xFFF8DEAA).withOpacity(0.94)
        : const Color(0xFFF9E9C9).withOpacity(0.98);

    canvas.drawCircle(
      center,
      radius * 2.2,
      Paint()..color = moonColor.withOpacity(0.22),
    );

    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    final cutPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(radius * 0.45, -radius * 0.25),
          radius: radius * 0.78,
        ),
      );
    final crescent = Path.combine(PathOperation.difference, moonPath, cutPath);

    canvas.drawPath(crescent, Paint()..color = moonColor);
  }

  void _paintMountains(Canvas canvas, Size size) {
    final color1 = isDark
        ? const Color(0xFF7A4B95).withOpacity(0.44)
        : const Color(0xFFD4B6E8).withOpacity(0.44);
    final color2 = isDark
        ? const Color(0xFF4C295F).withOpacity(0.68)
        : const Color(0xFFAA7ACD).withOpacity(0.40);

    final shift = (sceneIndex % 2) * 0.15;

    final far = Path()
      ..moveTo(0, size.height * 0.58)
      ..lineTo(size.width * (0.2 + shift), size.height * 0.32)
      ..lineTo(size.width * (0.4 + shift), size.height * 0.48)
      ..lineTo(size.width * (0.65 - shift), size.height * 0.28)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(far, Paint()..color = color1);

    final near = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * (0.3 - shift),
        size.height * 0.42,
        size.width * 0.5,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * (0.7 + shift),
        size.height * 0.65,
        size.width,
        size.height * 0.50,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(near, Paint()..color = color2);
  }

  void _paintBench(Canvas canvas, Size size) {
    final color = isDark
        ? Colors.black.withOpacity(0.72)
        : const Color(0xFF6A3D8B).withOpacity(0.60);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final isLeft = sceneIndex % 3 != 0;
    final cx = isLeft ? size.width * 0.35 : size.width * 0.65;
    final groundY = size.height * 0.66;
    final bw = size.width * 0.22;
    final bh = size.height * 0.10;
    final leg = 2.5;

    final left = cx - bw / 2;
    final right = cx + bw / 2;

    canvas.drawRect(Rect.fromLTWH(left, groundY - bh, leg, bh), paint);
    canvas.drawRect(Rect.fromLTWH(right - leg, groundY - bh, leg, bh), paint);
    canvas.drawRect(Rect.fromLTWH(left - 3, groundY - bh, bw + 6, 3), paint);

    final backTop = groundY - bh - bh * 0.55;
    canvas.drawRect(Rect.fromLTWH(left - 3, backTop, bw + 6, 2.5), paint);

    for (int i = 0; i < 3; i++) {
      final x = left + (bw / 2) * i;
      canvas.drawRect(Rect.fromLTWH(x, backTop, 2, bh * 0.55), paint);
    }
  }

  void _paintGround(Canvas canvas, Size size) {
    final color = isDark
        ? const Color(0xFF4B285F).withOpacity(0.72)
        : const Color(0xFFA978CC).withOpacity(0.40);

    final path = Path()
      ..moveTo(0, size.height * 0.66)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.60,
        size.width,
        size.height * 0.64,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  void _paintStars(Canvas canvas, Size size) {
    final starColor = isDark
        ? Colors.white.withOpacity(0.84)
        : Colors.white.withOpacity(0.94);
    final warm = isDark
        ? const Color(0xFFF8DEAA).withOpacity(0.82)
        : const Color(0xFFF9E9C9).withOpacity(0.84);

    final rng = Random(sceneIndex * 42);
    for (int i = 0; i < 6; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.35;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.5 + 0.5,
        Paint()..color = (i == 1 || i == 4) ? warm : starColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CardScenePainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.sceneIndex != sceneIndex;
  }
}
