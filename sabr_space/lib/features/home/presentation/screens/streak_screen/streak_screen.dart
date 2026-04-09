import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Streak detail — opened from the home streak chip.
///
/// Same vocabulary as the rest of the app (gradients, typography, spacing)
/// with a denser, contemporary “glow” layout.
class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
    with SingleTickerProviderStateMixin {
  /// Demo value — swap with real data later.
  static const int _currentStreakDays = 7;

  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: Stack(
          children: [
            // Soft atmosphere orbs
            ..._backgroundOrbs(context, media.size),
            SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.jumbo),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ScreenBackButton(
                          iconColor: context.palette.onSurface,
                          backgroundColor:
                              context.palette.surface.withValues(alpha: 0.75),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AppStrings.streakHeroEyebrow,
                      style: AppTypography.labelSmall(context).copyWith(
                        letterSpacing: 2.4,
                        color: context.palette.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.streakScreenTitle,
                      style: AppTypography.headlineMedium(context).copyWith(
                        color: context.palette.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    _HeroStreakCard(
                      days: _currentStreakDays,
                      animation: CurvedAnimation(
                        parent: _pulse,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      AppStrings.streakHeroSubtitle,
                      style: AppTypography.titleSmall(context).copyWith(
                        color: context.palette.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.jumbo),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.streakThisWeek,
                            style: AppTypography.titleSmall(context).copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.palette.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: AppSpacing.borderRadiusFull,
                            gradient: LinearGradient(
                              colors: [
                                context.palette.primaryFixed.withValues(alpha: 0.55),
                                context.palette.secondaryFixed
                                    .withValues(alpha: 0.45),
                              ],
                            ),
                          ),
                          child: Text(
                            AppStrings.streakNextMilestone,
                            style: AppTypography.labelSmall(context).copyWith(
                              color: context.palette.onPrimaryFixed,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _WeekStreakRail(
                      daysCompleted: _currentStreakDays,
                      todayIndex: 6,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(
                      AppStrings.streakEncouragement,
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: context.palette.onSurfaceVariant,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _backgroundOrbs(BuildContext context, Size size) {
    return [
      Positioned(
        top: -size.height * 0.06,
        right: -size.width * 0.15,
        child: _GlowOrb(
          diameter: size.width * 0.55,
          colors: [
            context.palette.primary.withValues(alpha: 0.14),
            context.palette.primaryFixedDim.withValues(alpha: 0.06),
            Colors.transparent,
          ],
        ),
      ),
      Positioned(
        bottom: size.height * 0.1,
        left: -size.width * 0.2,
        child: _GlowOrb(
          diameter: size.width * 0.5,
          colors: [
            context.palette.secondaryFixed.withValues(alpha: 0.2),
            context.palette.primaryContainer.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
      Positioned(
        top: size.height * 0.32,
        left: size.width * 0.12,
        child: Icon(
          Icons.star_rounded,
          size: 18,
          color: context.palette.primary.withValues(alpha: 0.22),
        ),
      ),
      Positioned(
        top: size.height * 0.22,
        right: size.width * 0.18,
        child: Icon(
          Icons.auto_awesome,
          size: 16,
          color: context.palette.secondary.withValues(alpha: 0.35),
        ),
      ),
    ];
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.diameter,
    required this.colors,
  });

  final double diameter;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: colors,
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }
}

class _HeroStreakCard extends StatelessWidget {
  const _HeroStreakCard({
    required this.days,
    required this.animation,
  });

  final int days;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color: context.palette.primary.withValues(alpha: 0.12),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.72),
            context.palette.surface.withValues(alpha: 0.55),
            context.palette.primaryFixed.withValues(alpha: 0.08),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.palette.primary.withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: context.palette.secondary.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(-8, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final t = 0.96 + (animation.value * 0.06);
              return Transform.scale(
                scale: t,
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        context.palette.primaryFixedDim.withValues(alpha: 0.45),
                        context.palette.primary.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                      stops: const [0.35, 0.65, 1.0],
                    ),
                  ),
                ),
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primaryGradient(context),
                    boxShadow: [
                      BoxShadow(
                        color: context.palette.primary.withValues(alpha: 0.45),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.palette.primary,
                  context.palette.primaryContainer,
                  context.palette.secondary,
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            child: Text(
              '$days',
              style: AppTypography.displayMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.05,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.streakDaysLabel,
            style: AppTypography.labelMedium(context).copyWith(
              color: context.palette.onSurfaceVariant,
              letterSpacing: 3.2,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WeekStreakRail extends StatelessWidget {
  const _WeekStreakRail({
    required this.daysCompleted,
    required this.todayIndex,
  });

  final int daysCompleted;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const count = 7;
        return SizedBox(
          height: 88,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 18,
                right: 18,
                top: 22,
                child: CustomPaint(
                  size: Size(w - 36, 4),
                  painter: _StreakRailPainter(
                    progress:
                        (daysCompleted / count).clamp(0.0, 1.0).toDouble(),
                    inactiveColor: context.palette.outlineVariant
                        .withValues(alpha: 0.55),
                    activeGradient: [
                      context.palette.primary,
                      context.palette.secondary,
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(count, (i) {
                  final done = i < daysCompleted;
                  final today = i == todayIndex;
                  return Expanded(
                    child: Column(
                      children: [
                        _DayNode(done: done, today: today),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          labels[i],
                          style: AppTypography.labelSmall(context).copyWith(
                            color: today
                                ? context.palette.primary
                                : context.palette.outline,
                            fontWeight:
                                today ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DayNode extends StatelessWidget {
  const _DayNode({required this.done, required this.today});

  final bool done;
  final bool today;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: done ? AppGradients.goldGradient : null,
        color: done ? null : context.palette.surfaceContainerHigh,
        border: Border.all(
          color: today
              ? context.palette.primary
              : (done
                  ? Colors.white.withValues(alpha: 0.35)
                  : context.palette.outlineVariant),
          width: today ? 2.8 : 1.2,
        ),
        boxShadow: done
            ? [
                BoxShadow(
                  color: context.palette.secondary.withValues(alpha: 0.28),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: done
          ? Icon(
              Icons.check_rounded,
              color: context.palette.onSecondary,
              size: 22,
            )
          : (today
              ? Icon(
                  Icons.fiber_manual_record,
                  size: 10,
                  color: context.palette.primary.withValues(alpha: 0.5),
                )
              : null),
    );
  }
}

class _StreakRailPainter extends CustomPainter {
  _StreakRailPainter({
    required this.progress,
    required this.inactiveColor,
    required this.activeGradient,
  });

  final double progress;
  final Color inactiveColor;
  final List<Color> activeGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..shader = LinearGradient(
        colors: activeGradient,
      ).createShader(Rect.fromLTWH(0, 0, size.width * progress, 4))
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), inactivePaint);
    if (progress > 0) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * progress, y),
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StreakRailPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.activeGradient != activeGradient;
  }
}
