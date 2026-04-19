import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/providers/mood_update_progress_provider.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

class StreakScreen extends ConsumerStatefulWidget {
  const StreakScreen({super.key});

  @override
  ConsumerState<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends ConsumerState<StreakScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _orbit;
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _orbit.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final streakDays =
        ref.watch(moodUpdateProgressProvider).value?.dailyStreakDays ?? 0;
    final railDays = streakDays.clamp(0, 7);
    final todayIndex = DateTime.now().weekday - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF32143E), Color(0xFF4D255A)]
                : const [Colors.white, Color(0xFFF7EEFF)],
          ),
        ),
        child: Stack(
          children: [
            ..._floatingParticles(isDark, size),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, 0,
                    ),
                    child: Row(
                      children: [const ScreenBackButton(), const Spacer()],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          Text(
                            AppStrings.streakHeroEyebrow,
                            style: AppTypography.labelSmall(context).copyWith(
                              letterSpacing: 2.4,
                              color: isDark
                                  ? const Color(0xFFE0B2F0)
                                  : const Color(0xFF6E35A3),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            AppStrings.streakScreenTitle,
                            style:
                                AppTypography.headlineMedium(context).copyWith(
                              color: isDark
                                  ? const Color(0xFFF4EAFB)
                                  : const Color(0xFF3D274E),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xxxl),
                          _HeroStreakOrb(
                            days: streakDays,
                            pulse: CurvedAnimation(
                              parent: _pulse,
                              curve: Curves.easeInOutCubic,
                            ),
                            orbit: _orbit,
                            shimmer: _shimmer,
                            isDark: isDark,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            AppStrings.streakHeroSubtitle,
                            style: AppTypography.titleSmall(context).copyWith(
                              color: isDark
                                  ? const Color(0xFFE8D4F4)
                                  : const Color(0xFF7C57A0),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.jumbo),
                          _buildThisWeekHeader(context, isDark),
                          const SizedBox(height: AppSpacing.lg),
                          _WeekStreakRail(
                            daysCompleted: railDays,
                            todayIndex: todayIndex,
                            isDark: isDark,
                          ),
                          const SizedBox(height: AppSpacing.xxxl),
                          Text(
                            AppStrings.streakEncouragement,
                            style: AppTypography.bodyMedium(context).copyWith(
                              color: isDark
                                  ? const Color(0xFFE8D4F4)
                                  : const Color(0xFF7C57A0),
                              height: 1.55,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
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

  Widget _buildThisWeekHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.streakThisWeek,
            style: AppTypography.titleSmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? const Color(0xFFF4EAFB)
                  : const Color(0xFF3D274E),
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
              colors: isDark
                  ? const [Color(0xFF5A2F79), Color(0xFF763E9D)]
                  : const [Color(0xFF552688), Color(0xFF3B1A66)],
            ),
          ),
          child: Text(
            AppStrings.streakNextMilestone,
            style: AppTypography.labelSmall(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _floatingParticles(bool isDark, Size size) {
    return [
      Positioned(
        top: -size.height * 0.06,
        right: -size.width * 0.15,
        child: _GlowOrb(
          diameter: size.width * 0.55,
          color: isDark
              ? const Color(0xFF763E9D).withOpacity(0.20)
              : const Color(0xFF6E35A3).withOpacity(0.08),
        ),
      ),
      Positioned(
        bottom: size.height * 0.1,
        left: -size.width * 0.2,
        child: _GlowOrb(
          diameter: size.width * 0.5,
          color: isDark
              ? const Color(0xFF9B4DC8).withOpacity(0.15)
              : const Color(0xFFBC95D8).withOpacity(0.12),
        ),
      ),
      AnimatedBuilder(
        animation: _orbit,
        builder: (context, _) {
          final t = _orbit.value * 2 * math.pi;
          return Positioned(
            top: size.height * 0.30 + math.sin(t) * 12,
            left: size.width * 0.12 + math.cos(t) * 8,
            child: Icon(
              Icons.star_rounded,
              size: 18,
              color: isDark
                  ? const Color(0xFFE0B2F0).withOpacity(0.30)
                  : const Color(0xFF6E35A3).withOpacity(0.18),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _orbit,
        builder: (context, _) {
          final t = _orbit.value * 2 * math.pi + math.pi;
          return Positioned(
            top: size.height * 0.20 + math.cos(t) * 10,
            right: size.width * 0.16 + math.sin(t) * 6,
            child: Icon(
              Icons.auto_awesome,
              size: 16,
              color: isDark
                  ? const Color(0xFFCCA8E2).withOpacity(0.35)
                  : const Color(0xFF9B4DC8).withOpacity(0.20),
            ),
          );
        },
      ),
    ];
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0.0)],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}

class _HeroStreakOrb extends StatelessWidget {
  const _HeroStreakOrb({
    required this.days,
    required this.pulse,
    required this.orbit,
    required this.shimmer,
    required this.isDark,
  });

  final int days;
  final Animation<double> pulse;
  final AnimationController orbit;
  final AnimationController shimmer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Center(
        child: AnimatedBuilder(
          animation: pulse,
          builder: (context, child) {
            final scale = 0.96 + pulse.value * 0.06;
            return Transform.scale(scale: scale, child: child);
          },
          child: SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF763E9D).withOpacity(0.40),
                              const Color(0xFF5A2F79).withOpacity(0.10),
                              Colors.transparent,
                            ]
                          : [
                              const Color(0xFFBC95D8).withOpacity(0.35),
                              const Color(0xFFE0C9F0).withOpacity(0.15),
                              Colors.transparent,
                            ],
                      stops: const [0.3, 0.65, 1.0],
                    ),
                  ),
                ),

                // Orbiting sparkles
                ...List.generate(3, (i) {
                  final offset = i * (2 * math.pi / 3);
                  return AnimatedBuilder(
                    animation: orbit,
                    builder: (context, _) {
                      final angle = orbit.value * 2 * math.pi + offset;
                      const radius = 88.0;
                      return Positioned(
                        left: 110 + math.cos(angle) * radius - 5,
                        top: 110 + math.sin(angle) * radius - 5,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFFE0B2F0).withOpacity(0.7)
                                : const Color(0xFF9B4DC8).withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? const Color(0xFFE0B2F0).withOpacity(0.4)
                                    : const Color(0xFF6E35A3).withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Main fire circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [Color(0xFF5A2F79), Color(0xFF763E9D)]
                          : const [Color(0xFF552688), Color(0xFF3B1A66)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? const Color(0xFF763E9D).withOpacity(0.50)
                            : const Color(0xFF552688).withOpacity(0.35),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$days',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekStreakRail extends StatelessWidget {
  const _WeekStreakRail({
    required this.daysCompleted,
    required this.todayIndex,
    required this.isDark,
  });

  final int daysCompleted;
  final int todayIndex;
  final bool isDark;

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
                    inactiveColor: isDark
                        ? const Color(0xFF46275E)
                        : const Color(0xFFE0C9F0),
                    activeColors: isDark
                        ? const [Color(0xFF763E9D), Color(0xFFBC80DE)]
                        : const [Color(0xFF552688), Color(0xFF9B4DC8)],
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
                        _DayNode(
                            done: done, today: today, isDark: isDark),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          labels[i],
                          style: AppTypography.labelSmall(context).copyWith(
                            color: today
                                ? (isDark
                                    ? const Color(0xFFBC80DE)
                                    : const Color(0xFF6E35A3))
                                : (isDark
                                    ? const Color(0xFFE8D4F4).withOpacity(0.5)
                                    : const Color(0xFF7C57A0)
                                        .withOpacity(0.6)),
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
  const _DayNode({
    required this.done,
    required this.today,
    required this.isDark,
  });

  final bool done;
  final bool today;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: done
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF763E9D), Color(0xFFBC80DE)]
                    : const [Color(0xFF552688), Color(0xFF9B4DC8)],
              )
            : null,
        color: done
            ? null
            : (isDark ? const Color(0xFF46275E) : const Color(0xFFE0C9F0)),
        border: Border.all(
          color: today
              ? (isDark
                  ? const Color(0xFFBC80DE)
                  : const Color(0xFF6E35A3))
              : (done
                  ? Colors.white.withOpacity(0.25)
                  : (isDark
                      ? const Color(0xFFCC98E7).withOpacity(0.20)
                      : const Color(0xFFBC95D8).withOpacity(0.40))),
          width: today ? 2.8 : 1.2,
        ),
        boxShadow: done
            ? [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF763E9D).withOpacity(0.35)
                      : const Color(0xFF552688).withOpacity(0.20),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: done
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
          : (today
              ? Icon(
                  Icons.fiber_manual_record,
                  size: 10,
                  color: isDark
                      ? const Color(0xFFBC80DE).withOpacity(0.6)
                      : const Color(0xFF6E35A3).withOpacity(0.4),
                )
              : null),
    );
  }
}

class _StreakRailPainter extends CustomPainter {
  _StreakRailPainter({
    required this.progress,
    required this.inactiveColor,
    required this.activeColors,
  });

  final double progress;
  final Color inactiveColor;
  final List<Color> activeColors;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), inactivePaint);

    if (progress > 0) {
      final activePaint = Paint()
        ..shader = LinearGradient(colors: activeColors)
            .createShader(Rect.fromLTWH(0, 0, size.width * progress, 4))
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
          Offset(0, y), Offset(size.width * progress, y), activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StreakRailPainter old) =>
      old.progress != progress ||
      old.inactiveColor != inactiveColor ||
      old.activeColors != activeColors;
}
