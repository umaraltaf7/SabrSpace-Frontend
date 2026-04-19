import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/features/journal/data/services/journal_bravery_points.dart';

/// Success / rewards screen after completing the guided journal entry.
class JournalRewardScreen extends StatefulWidget {
  const JournalRewardScreen({
    super.key,
    this.totalPoints,
  });

  /// Running total after this entry’s reward; if null, loaded from storage.
  final int? totalPoints;

  @override
  State<JournalRewardScreen> createState() => _JournalRewardScreenState();
}

class _JournalRewardScreenState extends State<JournalRewardScreen> {
  int? _total;

  @override
  void initState() {
    super.initState();
    _total = widget.totalPoints;
    if (_total == null) {
      JournalBraveryPoints.getTotal().then((v) {
        if (mounted) setState(() => _total = v);
      });
    }
  }

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'I completed a journal reflection in Sabr Space today — small steps, big heart.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final total = _total;

    return Scaffold(
      backgroundColor: palette.surfaceContainerLow,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.etherealGradientStart,
              palette.etherealGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: total == null
                      ? SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.primary,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.diamond_outlined,
                              size: 22,
                              color: palette.breatheAccent,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '$total',
                              style: AppTypography.titleMedium(context)
                                  .copyWith(
                                color: palette.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
                const Spacer(),
                SizedBox(
                  height: 220,
                  child: CustomPaint(
                    painter: _RewardCelebrationPainter(
                      body: palette.breatheAccent,
                      bodyDeep: palette.primary,
                      starColors: [
                        palette.gold,
                        palette.breatheAccent,
                        palette.secondaryFixedDim,
                        palette.primaryFixedDim,
                      ],
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  AppStrings.journalRewardTakeawaysTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMedium(context).copyWith(
                    color: palette.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.journalRewardTakeawaysBody,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge(context).copyWith(
                    color: palette.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.diamond_outlined,
                      size: 22,
                      color: palette.breatheAccent,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '+${JournalBraveryPoints.pointsPerJournalEntry} ${AppStrings.journalRewardBraveryLabel}',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: palette.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Material(
                      color: palette.primary,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _share,
                        child: SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(
                            Icons.share_rounded,
                            color: palette.onPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: () => context.go('/home'),
                          style: FilledButton.styleFrom(
                            backgroundColor: palette.primary,
                            foregroundColor: palette.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Text(
                            AppStrings.journalRewardContinue,
                            style:
                                AppTypography.labelLarge(context).copyWith(
                              color: palette.onPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Playful “level up” illustration — theme colors instead of reference teal.
class _RewardCelebrationPainter extends CustomPainter {
  _RewardCelebrationPainter({
    required this.body,
    required this.bodyDeep,
    required this.starColors,
  });

  final Color body;
  final Color bodyDeep;
  final List<Color> starColors;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.52;
    final rng = math.Random(7);

    for (var i = 0; i < 6; i++) {
      final a = (i / 6) * math.pi * 2 + 0.2;
      final r = size.width * (0.34 + rng.nextDouble() * 0.08);
      final p = Offset(cx + math.cos(a) * r, cy + math.sin(a) * r * 0.85);
      _star(canvas, p, 6 + rng.nextDouble() * 5,
          starColors[i % starColors.length]);
    }

    for (var i = 0; i < 10; i++) {
      final p = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height * 0.65,
      );
      canvas.drawCircle(
        p,
        rng.nextDouble() * 1.4 + 0.4,
        Paint()..color = Colors.white.withValues(alpha: 0.55),
      );
    }

    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(cx, cy + 8),
        width: size.width * 0.38,
        height: size.width * 0.34,
      ));
    canvas.drawPath(bodyPath, Paint()..color = body);

    final hornL = Path()
      ..moveTo(cx - size.width * 0.14, cy - size.width * 0.02)
      ..lineTo(cx - size.width * 0.18, cy - size.width * 0.12)
      ..lineTo(cx - size.width * 0.10, cy - size.width * 0.08);
    canvas.drawPath(
      hornL,
      Paint()
        ..color = bodyDeep
        ..style = PaintingStyle.fill,
    );
    final hornR = Path()
      ..moveTo(cx + size.width * 0.14, cy - size.width * 0.02)
      ..lineTo(cx + size.width * 0.18, cy - size.width * 0.12)
      ..lineTo(cx + size.width * 0.10, cy - size.width * 0.08);
    canvas.drawPath(
      hornR,
      Paint()
        ..color = bodyDeep
        ..style = PaintingStyle.fill,
    );

    final band = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy - size.width * 0.02),
        width: size.width * 0.26,
        height: 10,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(band, Paint()..color = const Color(0xFF1A1520));

    canvas.drawCircle(
      Offset(cx - size.width * 0.08, cy + size.width * 0.02),
      size.width * 0.045,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx + size.width * 0.08, cy + size.width * 0.02),
      size.width * 0.045,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx - size.width * 0.08, cy + size.width * 0.02),
      size.width * 0.018,
      Paint()..color = const Color(0xFF2D1B3D),
    );
    canvas.drawCircle(
      Offset(cx + size.width * 0.08, cy + size.width * 0.02),
      size.width * 0.018,
      Paint()..color = const Color(0xFF2D1B3D),
    );

    final smile = Path()
      ..moveTo(cx - size.width * 0.10, cy + size.width * 0.10)
      ..quadraticBezierTo(
        cx,
        cy + size.width * 0.16,
        cx + size.width * 0.10,
        cy + size.width * 0.10,
      );
    canvas.drawPath(
      smile,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.92)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    final barY = cy - size.width * 0.22;
    final barW = size.width * 0.52;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, barY),
          width: barW,
          height: 12,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = _barbellColor,
    );
    canvas.drawCircle(
      Offset(cx - barW * 0.5, barY),
      14,
      Paint()..color = _barbellColor.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      Offset(cx + barW * 0.5, barY),
      14,
      Paint()..color = _barbellColor.withValues(alpha: 0.85),
    );
  }

  Color get _barbellColor => bodyDeep.withValues(alpha: 0.88);

  void _star(Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + i * (2 * math.pi / 5);
      final ox = c.dx + math.cos(a) * r;
      final oy = c.dy + math.sin(a) * r;
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      final a2 = a + math.pi / 5;
      path.lineTo(
        c.dx + math.cos(a2) * r * 0.42,
        c.dy + math.sin(a2) * r * 0.42,
      );
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.95)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RewardCelebrationPainter old) =>
      old.body != body || old.bodyDeep != bodyDeep;
}
