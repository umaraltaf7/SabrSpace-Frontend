import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/providers/mood_update_progress_provider.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/visualize/presentation/models/visualize_track.dart';

class VisualizeScreen extends StatefulWidget {
  const VisualizeScreen({super.key});

  @override
  State<VisualizeScreen> createState() => _VisualizeScreenState();
}

class _VisualizeScreenState extends State<VisualizeScreen> {
  VisualizeCategory _selected = VisualizeCategory.tilawat;

  List<VisualizeTrack> get _tracks => _selected == VisualizeCategory.tilawat
      ? VisualizeTrack.tilawatTracks
      : VisualizeTrack.bodyScanTracks;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? _VP.darkBackgroundBottom : _VP.lightBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_VP.darkBackgroundTop, _VP.darkBackgroundBottom]
                : const [_VP.lightBackgroundTop, _VP.lightBackgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      _buildHero(context, isDark),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildDescription(context, isDark),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildCategorySelector(context, isDark),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildGrid(context, isDark),
                      Consumer(
                        builder: (context, ref, _) {
                          final fromMoodUpdate =
                              GoRouterState.of(context)
                                  .uri
                                  .queryParameters['mood_update'] ==
                              '1';
                          if (!fromMoodUpdate) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: AppSpacing.xxl,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(
                                        moodUpdateProgressProvider.notifier,
                                      )
                                      .completeVisualize();
                                  if (context.mounted) context.pop();
                                },
                                icon: const Icon(
                                  Icons.check_circle_outline_rounded,
                                ),
                                label: const Text(
                                  'Mark visualization complete',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          ScreenBackButton(
            iconColor: isDark ? _VP.darkAccentSoft : _VP.lightAccent,
          ),
          Expanded(
            child: Text(
              'Visualize',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSmall(context).copyWith(
                color: isDark ? _VP.darkTextPrimary : _VP.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF1A0B2E), Color(0xFF3D1D5C)]
              : const [Color(0xFF5B2D8E), Color(0xFF7B44AD)],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? _VP.darkShadow.withOpacity(0.80)
                : _VP.lightShadow.withOpacity(0.55),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: isDark
              ? const Color(0xFF9B5FC7).withOpacity(0.20)
              : Colors.white.withOpacity(0.12),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroScenePainter(isDark: isDark),
              ),
            ),
            // Soft overlay vignette
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.0, -0.2),
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(isDark ? 0.30 : 0.18),
                    ],
                    stops: const [0.50, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Glowing orb with icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.30),
                          Colors.white.withOpacity(0.08),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    const Color(0xFFD4A0F5).withOpacity(0.50),
                                    const Color(0xFF8B4FC6).withOpacity(0.70),
                                  ]
                                : [
                                    Colors.white.withOpacity(0.55),
                                    const Color(0xFFCCA8E2).withOpacity(0.65),
                                  ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.40),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFBC80DE).withOpacity(0.50),
                              blurRadius: 24,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.self_improvement_rounded,
                          size: 28,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Find Your Peace',
                    style: AppTypography.titleLarge(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.40),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Soothe your soul with sound',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: Colors.white.withOpacity(0.75),
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [_VP.darkSurfaceElevated, _VP.darkSurface]
              : [_VP.lightSurface, _VP.lightSurfaceSoft],
        ),
        border: Border.all(
          color: isDark
              ? _VP.darkBorder.withOpacity(0.30)
              : _VP.lightBorder.withOpacity(0.60),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? _VP.darkShadow.withOpacity(0.30)
                : _VP.lightShadow.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'Listen to soothing tilawat or body scan meditations '
        'below to feel rooted when you are feeling anxious.',
        textAlign: TextAlign.center,
        style: AppTypography.bodyMedium(context).copyWith(
          color: isDark ? _VP.darkTextSecondary : _VP.lightTextSecondary,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isDark
            ? _VP.darkSurface
            : _VP.lightSurfaceSoft.withOpacity(0.60),
        border: Border.all(
          color: isDark
              ? _VP.darkBorder.withOpacity(0.25)
              : _VP.lightBorder.withOpacity(0.50),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _categoryPill(
            context,
            isDark: isDark,
            label: 'Tilawat',
            icon: Icons.menu_book_rounded,
            selected: _selected == VisualizeCategory.tilawat,
            onTap: () => setState(() => _selected = VisualizeCategory.tilawat),
          ),
          const SizedBox(width: 4),
          _categoryPill(
            context,
            isDark: isDark,
            label: 'Meditate',
            icon: Icons.spa_rounded,
            selected: _selected == VisualizeCategory.bodyScan,
            onTap: () =>
                setState(() => _selected = VisualizeCategory.bodyScan),
          ),
        ],
      ),
    );
  }

  Widget _categoryPill(
    BuildContext context, {
    required bool isDark,
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected
                ? LinearGradient(
                    colors: isDark
                        ? const [_VP.darkAccent, _VP.darkHeroBottom]
                        : const [_VP.lightAccent, _VP.lightHeroBottom],
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: isDark
                          ? _VP.darkAccent.withOpacity(0.35)
                          : _VP.lightAccent.withOpacity(0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? Colors.white
                    : (isDark
                        ? _VP.darkTextSecondary
                        : _VP.lightTextSecondary),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelLarge(context).copyWith(
                  color: selected
                      ? Colors.white
                      : (isDark
                          ? _VP.darkTextSecondary
                          : _VP.lightTextSecondary),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, bool isDark) {
    final tracks = _tracks;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - AppSpacing.lg * 2 - AppSpacing.md) / 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: cardWidth / (cardWidth + 24),
      ),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        return _TrackCard(
          track: tracks[index],
          sceneIndex: index,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Track Card
// ─────────────────────────────────────────────────────────────────────────────

class _TrackCard extends StatelessWidget {
  const _TrackCard({
    required this.track,
    required this.sceneIndex,
  });

  final VisualizeTrack track;
  final int sceneIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTilawat = track.category == VisualizeCategory.tilawat;

    return GestureDetector(
      onTap: () => context.push('/visualize-player', extra: track),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isTilawat
                ? (isDark
                    ? const [Color(0xFF1A0B2E), Color(0xFF2D1650)]
                    : const [Color(0xFF6B3FA0), Color(0xFF4D2080)])
                : (isDark
                    ? const [Color(0xFF1B2338), Color(0xFF2A1B42)]
                    : const [Color(0xFF7B5FA0), Color(0xFF5C3D8E)]),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _VP.darkShadow.withOpacity(0.60)
                  : _VP.lightShadow.withOpacity(0.40),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
          border: Border.all(
            color: isDark
                ? const Color(0xFF9B5FC7).withOpacity(0.15)
                : Colors.white.withOpacity(0.12),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardScenePainter(
                    isDark: isDark,
                    sceneIndex: sceneIndex,
                    isTilawat: isTilawat,
                  ),
                ),
              ),
              // Bottom gradient for text readability
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(isDark ? 0.65 : 0.55),
                        ],
                        stops: const [0.0, 0.35, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: Icon(
                    isTilawat
                        ? Icons.menu_book_rounded
                        : Icons.spa_rounded,
                    size: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ),
              // Bottom content
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleSmall(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.50),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.headphones_rounded,
                                size: 11,
                                color: Colors.white.withOpacity(0.80),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                isTilawat ? 'Tilawat' : 'Meditate',
                                style: AppTypography.labelSmall(context)
                                    .copyWith(
                                  color: Colors.white.withOpacity(0.80),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isDark
                                  ? [
                                      const Color(0xFFBC80DE),
                                      const Color(0xFF8B4FC6),
                                    ]
                                  : [
                                      Colors.white.withOpacity(0.90),
                                      Colors.white.withOpacity(0.70),
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? const Color(0xFFBC80DE).withOpacity(0.40)
                                    : Colors.white.withOpacity(0.40),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: isDark
                                ? Colors.white
                                : _VP.lightAccent,
                            size: 18,
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

// ─────────────────────────────────────────────────────────────────────────────
// Palette
// ─────────────────────────────────────────────────────────────────────────────

class _VP {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFF3E6FB);

  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);
  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightHeroBottom = Color(0xFF4D2080);
  static const Color darkHeroBottom = Color(0xFF763E9D);

  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Scene Painter — night sky, crescent moon, mountains, mosque dome
// ─────────────────────────────────────────────────────────────────────────────

class _HeroScenePainter extends CustomPainter {
  _HeroScenePainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    _paintStars(canvas, size);
    _paintNebula(canvas, size);
    _paintMoon(canvas, size);
    _paintMountains(canvas, size);
    _paintDome(canvas, size);
    _paintSparkles(canvas, size);
    _paintRings(canvas, size);
  }

  void _paintNebula(Canvas canvas, Size size) {
    final c1 = isDark
        ? const Color(0xFF7B44AD).withOpacity(0.30)
        : const Color(0xFFCCA8E2).withOpacity(0.35);
    final c2 = isDark
        ? const Color(0xFF4D2080).withOpacity(0.25)
        : const Color(0xFFE0B2F0).withOpacity(0.28);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.70, size.height * 0.30),
        width: size.width * 0.60,
        height: size.height * 0.40,
      ),
      Paint()
        ..color = c1
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * 0.50),
        width: size.width * 0.45,
        height: size.height * 0.30,
      ),
      Paint()
        ..color = c2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );
  }

  void _paintStars(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final bright =
        Colors.white.withOpacity(isDark ? 0.90 : 0.80);
    final dim =
        Colors.white.withOpacity(isDark ? 0.50 : 0.45);
    final warm =
        const Color(0xFFF8DEAA).withOpacity(isDark ? 0.85 : 0.75);

    for (int i = 0; i < 35; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.65;
      final r = rng.nextDouble() * 1.4 + 0.3;
      final color = i % 7 == 0 ? warm : (i % 3 == 0 ? bright : dim);
      canvas.drawCircle(Offset(x, y), r, Paint()..color = color);
    }

    // 4-pointed sparkle stars
    for (final s in <(double, double, double)>[
      (0.15, 0.12, 4.0),
      (0.72, 0.08, 5.0),
      (0.88, 0.25, 3.5),
      (0.40, 0.18, 3.0),
    ]) {
      _drawSparkle(
        canvas,
        Offset(size.width * s.$1, size.height * s.$2),
        s.$3,
        bright,
      );
    }
  }

  void _drawSparkle(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(
      c,
      r * 2.5,
      Paint()
        ..color = color.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + r * 0.12, c.dy - r * 0.12)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx + r * 0.12, c.dy + r * 0.12)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - r * 0.12, c.dy + r * 0.12)
      ..lineTo(c.dx - r, c.dy)
      ..lineTo(c.dx - r * 0.12, c.dy - r * 0.12)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _paintMoon(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.82, size.height * 0.18);
    final radius = size.width * 0.10;
    final moonColor = isDark
        ? const Color(0xFFF8DEAA)
        : const Color(0xFFF9EACB);

    // Glow
    canvas.drawCircle(
      center,
      radius * 3.0,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.10 : 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawCircle(
      center,
      radius * 1.8,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.16 : 0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Crescent
    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    final cutPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(radius * 0.40, -radius * 0.15),
          radius: radius * 0.88,
        ),
      );
    final crescent =
        Path.combine(PathOperation.difference, moonPath, cutPath);
    canvas.drawPath(
      crescent,
      Paint()..color = moonColor.withOpacity(isDark ? 0.95 : 1.0),
    );
  }

  void _paintMountains(Canvas canvas, Size size) {
    // Far range
    final farColor = isDark
        ? const Color(0xFF5A2F79).withOpacity(0.60)
        : const Color(0xFFD2B6E8).withOpacity(0.50);
    final far = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.15,
        size.height * 0.48,
        size.width * 0.30,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.42,
        size.width * 0.70,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.64,
        size.width,
        size.height * 0.52,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(far, Paint()..color = farColor);

    // Near range
    final nearColor = isDark
        ? const Color(0xFF3D1D5C).withOpacity(0.85)
        : const Color(0xFFA978CC).withOpacity(0.55);
    final near = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.65,
        size.width * 0.45,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.70,
        size.height * 0.85,
        size.width,
        size.height * 0.72,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(near, Paint()..color = nearColor);
  }

  void _paintDome(Canvas canvas, Size size) {
    final color = isDark
        ? const Color(0xFF2A1540).withOpacity(0.90)
        : const Color(0xFF6B3FA0).withOpacity(0.50);

    final cx = size.width * 0.48;
    final baseY = size.height * 0.72;
    final domeW = size.width * 0.16;
    final domeH = size.height * 0.18;
    final paint = Paint()..color = color;

    // Dome body
    final dome = Path()
      ..moveTo(cx - domeW / 2, baseY)
      ..quadraticBezierTo(cx - domeW / 2, baseY - domeH, cx, baseY - domeH)
      ..quadraticBezierTo(cx + domeW / 2, baseY - domeH, cx + domeW / 2, baseY)
      ..close();
    canvas.drawPath(dome, paint);

    // Base
    canvas.drawRect(
      Rect.fromLTWH(cx - domeW / 2 - 4, baseY, domeW + 8, size.height - baseY),
      paint,
    );

    // Minaret left
    final mLeft = cx - domeW / 2 - 10;
    canvas.drawRect(
      Rect.fromLTWH(mLeft, baseY - domeH * 0.85, 4, domeH * 0.85 + (size.height - baseY)),
      paint,
    );
    // Minaret tip
    final tipY = baseY - domeH * 0.85 - 6;
    canvas.drawCircle(Offset(mLeft + 2, tipY), 3, paint);

    // Minaret right
    final mRight = cx + domeW / 2 + 6;
    canvas.drawRect(
      Rect.fromLTWH(mRight, baseY - domeH * 0.70, 4, domeH * 0.70 + (size.height - baseY)),
      paint,
    );
    canvas.drawCircle(Offset(mRight + 2, baseY - domeH * 0.70 - 5), 2.5, paint);
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final glow = isDark
        ? const Color(0xFFE0B2F0).withOpacity(0.30)
        : Colors.white.withOpacity(0.35);

    // Floating particles near mountains
    final rng = math.Random(99);
    for (int i = 0; i < 8; i++) {
      final x = rng.nextDouble() * size.width;
      final y = size.height * 0.55 + rng.nextDouble() * size.height * 0.25;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 2.0 + 0.5,
        Paint()
          ..color = glow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  void _paintRings(Canvas canvas, Size size) {
    // Subtle concentric meditation rings around center
    final center = Offset(size.width * 0.50, size.height * 0.42);
    final ringColor = Colors.white.withOpacity(isDark ? 0.06 : 0.10);
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (final r in [50.0, 70.0, 95.0]) {
      canvas.drawCircle(center, r, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeroScenePainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Card Scene Painter — unique scene per card
// ─────────────────────────────────────────────────────────────────────────────

class _CardScenePainter extends CustomPainter {
  _CardScenePainter({
    required this.isDark,
    required this.sceneIndex,
    required this.isTilawat,
  });

  final bool isDark;
  final int sceneIndex;
  final bool isTilawat;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(sceneIndex * 31 + (isTilawat ? 0 : 200));

    if (isTilawat) {
      _paintTilawatScene(canvas, size, rng);
    } else {
      _paintBodyScanScene(canvas, size, rng);
    }
  }

  void _paintTilawatScene(Canvas canvas, Size size, math.Random rng) {
    // Stars
    final starColor = Colors.white.withOpacity(isDark ? 0.75 : 0.70);
    final warmStar =
        const Color(0xFFF8DEAA).withOpacity(isDark ? 0.80 : 0.70);
    for (int i = 0; i < 16; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.50;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.3 + 0.3,
        Paint()..color = (i % 5 == 0) ? warmStar : starColor,
      );
    }

    // Crescent moon — position varies per card
    final moonX = size.width * (0.20 + (sceneIndex % 3) * 0.25);
    final moonY = size.height * 0.18;
    final moonR = size.width * 0.08;
    final moonColor = isDark
        ? const Color(0xFFF8DEAA).withOpacity(0.90)
        : const Color(0xFFF9EACB).withOpacity(0.95);

    canvas.drawCircle(
      Offset(moonX, moonY),
      moonR * 2.0,
      Paint()
        ..color = moonColor.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(moonX, moonY), radius: moonR));
    final cutPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(moonX + moonR * 0.42, moonY - moonR * 0.18),
        radius: moonR * 0.82,
      ));
    canvas.drawPath(
      Path.combine(PathOperation.difference, moonPath, cutPath),
      Paint()..color = moonColor,
    );

    // Geometric arches (Islamic pattern inspired)
    final archColor = Colors.white.withOpacity(isDark ? 0.08 : 0.12);
    final archPaint = Paint()
      ..color = archColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final archCx = size.width * (0.50 + rng.nextDouble() * 0.20 - 0.10);
    final archBy = size.height * 0.70;
    for (final s in [0.28, 0.22, 0.16]) {
      final w = size.width * s;
      final h = w * 1.4;
      final arch = Path()
        ..moveTo(archCx - w / 2, archBy)
        ..quadraticBezierTo(archCx - w / 2, archBy - h, archCx, archBy - h)
        ..quadraticBezierTo(archCx + w / 2, archBy - h, archCx + w / 2, archBy);
      canvas.drawPath(arch, archPaint);
    }

    // Small hills at bottom
    final hillColor = isDark
        ? const Color(0xFF2D1650).withOpacity(0.70)
        : const Color(0xFF4D2080).withOpacity(0.40);
    final hill = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.70,
        size.width * 0.55,
        size.height * 0.80,
      )
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.88,
        size.width,
        size.height * 0.76,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = hillColor);

    // One sparkle star
    _drawCardSparkle(
      canvas,
      Offset(size.width * (0.60 + rng.nextDouble() * 0.25),
          size.height * (0.08 + rng.nextDouble() * 0.15)),
      3.5,
      Colors.white.withOpacity(isDark ? 0.85 : 0.75),
    );
  }

  void _paintBodyScanScene(Canvas canvas, Size size, math.Random rng) {
    // Soft aurora glow
    final auroraColor = isDark
        ? const Color(0xFF7B5FA0).withOpacity(0.25)
        : const Color(0xFFCCA8E2).withOpacity(0.30);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.25),
        width: size.width * 0.80,
        height: size.height * 0.35,
      ),
      Paint()
        ..color = auroraColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Concentric meditation rings
    final ringCenter = Offset(size.width * 0.50, size.height * 0.35);
    final ringColor = Colors.white.withOpacity(isDark ? 0.10 : 0.15);
    for (final r in [16.0, 28.0, 42.0]) {
      canvas.drawCircle(
        ringCenter,
        r,
        Paint()
          ..color = ringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7,
      );
    }
    // Center dot
    canvas.drawCircle(
      ringCenter,
      4,
      Paint()..color = Colors.white.withOpacity(isDark ? 0.35 : 0.45),
    );

    // Rolling hills
    final hill1Color = isDark
        ? const Color(0xFF2A1B42).withOpacity(0.70)
        : const Color(0xFF7B5FA0).withOpacity(0.35);
    final hill1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.58,
        size.width * 0.60,
        size.height * 0.68,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.78,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(hill1, Paint()..color = hill1Color);

    final hill2Color = isDark
        ? const Color(0xFF1B2338).withOpacity(0.80)
        : const Color(0xFF5C3D8E).withOpacity(0.30);
    final hill2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.84)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.74,
        size.width * 0.70,
        size.height * 0.82,
      )
      ..quadraticBezierTo(
        size.width * 0.90,
        size.height * 0.88,
        size.width,
        size.height * 0.80,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(hill2, Paint()..color = hill2Color);

    // Leaves/plants
    final leafColor = isDark
        ? const Color(0xFF8D59AA).withOpacity(0.50)
        : const Color(0xFFCCA8E2).withOpacity(0.40);
    for (int i = 0; i < 5; i++) {
      final lx = rng.nextDouble() * size.width;
      final ly = size.height * (0.62 + rng.nextDouble() * 0.30);
      final angle = rng.nextDouble() * math.pi * 2;
      final len = 8.0 + rng.nextDouble() * 10;
      canvas.save();
      canvas.translate(lx, ly);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(len * 0.35, -len * 0.24, len, 0)
        ..quadraticBezierTo(len * 0.35, len * 0.24, 0, 0)
        ..close();
      canvas.drawPath(path, Paint()..color = leafColor);
      canvas.restore();
    }

    // Soft particles
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(
          rng.nextDouble() * size.width,
          rng.nextDouble() * size.height * 0.55,
        ),
        rng.nextDouble() * 1.2 + 0.4,
        Paint()..color = Colors.white.withOpacity(isDark ? 0.40 : 0.50),
      );
    }
  }

  void _drawCardSparkle(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(
      c,
      r * 2.2,
      Paint()
        ..color = color.withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + r * 0.12, c.dy - r * 0.12)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx + r * 0.12, c.dy + r * 0.12)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - r * 0.12, c.dy + r * 0.12)
      ..lineTo(c.dx - r, c.dy)
      ..lineTo(c.dx - r * 0.12, c.dy - r * 0.12)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CardScenePainter old) =>
      old.isDark != isDark || old.sceneIndex != sceneIndex;
}
