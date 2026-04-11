import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/sanctuary/presentation/models/breathe_session_args.dart';

/// Breathe setup — technique, duration, optional dhikr; matches reference UI.
class BreatheMinimalScreen extends StatefulWidget {
  const BreatheMinimalScreen({super.key});

  @override
  State<BreatheMinimalScreen> createState() => _BreatheMinimalScreenState();
}

class _BreatheMinimalScreenState extends State<BreatheMinimalScreen> {
  static const double _cardRadius = 20;
  static const double _maxContent = 520;

  int _techniqueIndex = 0;
  int _durationIndex = 1;
  bool _pairDhikr = true;

  static const _durations = <int>[2, 5, 10];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad = _horizontalPad(media.size.width);

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
                    _BreathePalette.darkBackgroundTop,
                    _BreathePalette.darkBackgroundBottom,
                  ]
                : const [
                    _BreathePalette.lightBackgroundTop,
                    _BreathePalette.lightBackgroundBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = math.min(constraints.maxWidth - 2 * hPad, _maxContent);
            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  AppSpacing.sm,
                  hPad,
                  AppSpacing.xl + media.padding.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _topBar(context),
                      const SizedBox(height: AppSpacing.lg),
                      _BreatheHeroCard(isDark: isDark),
                      const SizedBox(height: AppSpacing.xxl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.breatheSelectTechnique,
                          style: AppTypography.labelSmall(context).copyWith(
                            color: isDark
                                ? _BreathePalette.darkTextSecondary
                                : _BreathePalette.lightTextSecondary,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _TechniqueCard(
                        radius: _cardRadius,
                        selected: _techniqueIndex == 0,
                        title: AppStrings.breatheTechniqueBox,
                        subtitle: AppStrings.breatheTechniqueBoxSub,
                        tags: const [
                          AppStrings.breatheTagFocus,
                          AppStrings.breatheTagBalance,
                        ],
                        onTap: () => setState(() => _techniqueIndex = 0),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _TechniqueCard(
                        radius: _cardRadius,
                        selected: _techniqueIndex == 1,
                        title: AppStrings.breatheTechnique478,
                        subtitle: AppStrings.breatheTechnique478Sub,
                        onTap: () => setState(() => _techniqueIndex = 1),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _TechniqueCard(
                        radius: _cardRadius,
                        selected: _techniqueIndex == 2,
                        title: AppStrings.breatheTechniqueSimple,
                        subtitle: AppStrings.breatheTechniqueSimpleSub,
                        onTap: () => setState(() => _techniqueIndex = 2),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.breatheDurationLabel,
                          style: AppTypography.labelSmall(context).copyWith(
                            color: isDark
                                ? _BreathePalette.darkTextSecondary
                                : _BreathePalette.lightTextSecondary,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: List.generate(_durations.length, (i) {
                          final selected = _durationIndex == i;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i < _durations.length - 1 ? AppSpacing.sm : 0,
                              ),
                              child: _DurationPill(
                                label: '${_durations[i]} min',
                                selected: selected,
                                onTap: () =>
                                    setState(() => _durationIndex = i),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _DhikrCard(
                        value: _pairDhikr,
                        onChanged: (v) => setState(() => _pairDhikr = v),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      FilledButton(
                        onPressed: () => context.push(
                          '/breathe-session',
                          extra: BreatheSessionArgs(
                            durationMinutes: _durations[_durationIndex],
                            techniqueIndex: _techniqueIndex,
                            pairWithDhikr: _pairDhikr,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark
                              ? _BreathePalette.darkAccent
                              : _BreathePalette.lightAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const StadiumBorder(),
                          elevation: 2,
                          shadowColor: (isDark
                                  ? _BreathePalette.darkAccent
                                  : _BreathePalette.lightAccent)
                              .withValues(
                            alpha: 0.45,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.breatheBeginPractice,
                              style: AppTypography.labelLarge(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            );
          },
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        ScreenBackButton(
          iconColor: isDark
              ? _BreathePalette.darkAccentSoft
              : _BreathePalette.lightAccent,
        ),
        Expanded(
          child: Text(
            AppStrings.appName,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerif(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? _BreathePalette.darkAccentSoft
                  : _BreathePalette.lightAccent,
            ),
          ),
        ),
        Material(
          color: (isDark
                  ? _BreathePalette.darkAccentSoft
                  : _BreathePalette.lightAccent)
              .withValues(alpha: 0.15),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push('/profile'),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.person_rounded,
                color: isDark
                    ? _BreathePalette.darkAccentSoft
                    : _BreathePalette.lightAccent,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _horizontalPad(double width) {
    if (width >= 900) return 40;
    if (width >= 600) return 28;
    return AppSpacing.xxl;
  }
}

class _TechniqueCard extends StatelessWidget {
  const _TechniqueCard({
    required this.radius,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.tags,
  });

  final double radius;
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final List<String>? tags;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = selected
        ? Border.all(
            color: isDark
                ? _BreathePalette.darkAccentSoft
                : _BreathePalette.lightAccent,
            width: 1.5,
          )
        : Border.all(color: Colors.transparent, width: 1.5);

    final bg = selected
        ? (isDark
            ? _BreathePalette.darkCardTop
            : _BreathePalette.lightCardTop)
        : (isDark
            ? _BreathePalette.darkSurfaceElevated
            : _BreathePalette.lightSurface);
    final titleColor = selected
        ? Colors.white
        : (isDark
            ? _BreathePalette.darkTextPrimary
            : _BreathePalette.lightTextPrimary);
    final subtitleColor = selected
        ? Colors.white.withValues(alpha: 0.90)
        : (isDark
            ? _BreathePalette.darkTextSecondary
            : _BreathePalette.lightTextSecondary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            border: border,
            boxShadow: [
              if (!selected)
                BoxShadow(
                  color: (isDark
                          ? _BreathePalette.darkShadow
                          : _BreathePalette.lightShadow)
                      .withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.notoSerif(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                      if (tags != null && tags!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          children: tags!
                              .map(
                                (t) => _TechniqueTag(
                                  label: t,
                                  cardSelected: selected,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: selected
                      ? Icon(
                          Icons.check_circle,
                          color: titleColor,
                          size: 28,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: isDark
                              ? _BreathePalette.darkTextSecondary
                              : _BreathePalette.lightTextSecondary,
                          size: 28,
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

class _TechniqueTag extends StatelessWidget {
  const _TechniqueTag({
    required this.label,
    this.cardSelected = false,
  });

  final String label;
  final bool cardSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = cardSelected
        ? (isDark
                ? _BreathePalette.darkAccentSoft
                : _BreathePalette.lightAccent)
            .withValues(alpha: 0.20)
        : (isDark
                ? _BreathePalette.darkAccentSoft
                : _BreathePalette.lightAccentSoft)
            .withValues(alpha: 0.45);
    final fg = cardSelected
        ? Colors.white
        : (isDark ? _BreathePalette.darkTextPrimary : _BreathePalette.lightAccent);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall(context).copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? (isDark
                    ? _BreathePalette.darkAccent
                    : _BreathePalette.lightAccent)
                : (isDark
                    ? _BreathePalette.darkSurfaceElevated
                    : _BreathePalette.lightSurface),
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: (isDark
                              ? _BreathePalette.darkAccent
                              : _BreathePalette.lightAccent)
                          .withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.labelLarge(context).copyWith(
              color: selected
                  ? Colors.white
                  : (isDark
                      ? _BreathePalette.darkTextSecondary
                      : _BreathePalette.lightTextSecondary),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? _BreathePalette.darkSurface
            : _BreathePalette.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark
                    ? _BreathePalette.darkShadow
                    : _BreathePalette.lightShadow)
                .withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: isDark
              ? _BreathePalette.darkBorder.withValues(alpha: 0.45)
              : _BreathePalette.lightBorder.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? _BreathePalette.darkAccent.withValues(alpha: 0.25)
                  : _BreathePalette.lightAccentSoft.withValues(alpha: 0.65),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: isDark
                  ? _BreathePalette.darkAccentSoft
                  : _BreathePalette.lightAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.breathePairDhikr,
                  style: AppTypography.titleSmall(context).copyWith(
                    color: isDark
                        ? _BreathePalette.darkTextPrimary
                        : _BreathePalette.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.breathePairDhikrSub,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: isDark
                        ? _BreathePalette.darkTextSecondary
                        : _BreathePalette.lightTextSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: isDark
                ? _BreathePalette.darkAccent
                : _BreathePalette.lightAccent,
          ),
        ],
      ),
    );
  }
}

class _BreatheHeroCard extends StatelessWidget {
  const _BreatheHeroCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [_BreathePalette.darkCardTop, _BreathePalette.darkCardBottom]
              : const [_BreathePalette.lightCardTop, _BreathePalette.lightCardBottom],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? _BreathePalette.darkShadow : _BreathePalette.lightShadow)
                .withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _BreatheHeroPainter(isDark: isDark),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.breathe,
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: Text(
                      AppStrings.breatheSetupSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        height: 1.5,
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
}

class _BreatheHeroPainter extends CustomPainter {
  _BreatheHeroPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final waveColor = Colors.white.withValues(alpha: isDark ? 0.26 : 0.34);
    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final waveA = Path()
      ..moveTo(size.width * 0.08, size.height * 0.26)
      ..quadraticBezierTo(
        size.width * 0.26,
        size.height * 0.20,
        size.width * 0.46,
        size.height * 0.27,
      )
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.34,
        size.width * 0.88,
        size.height * 0.26,
      );
    final waveB = Path()
      ..moveTo(size.width * 0.12, size.height * 0.38)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.30,
        size.width * 0.56,
        size.height * 0.39,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.46,
        size.width * 0.90,
        size.height * 0.40,
      );
    canvas.drawPath(waveA, wavePaint);
    canvas.drawPath(waveB, wavePaint..strokeWidth = 1.5);

    final leafColor = (isDark ? const Color(0xFFB88ED8) : const Color(0xFFE4C7F3))
        .withValues(alpha: 0.68);
    final leafPaint = Paint()..color = leafColor;
    for (final leaf in <(Offset, double, double)>[
      (Offset(size.width * 0.18, size.height * 0.18), -0.5, 16),
      (Offset(size.width * 0.30, size.height * 0.14), -0.2, 13),
      (Offset(size.width * 0.82, size.height * 0.30), -2.5, 14),
      (Offset(size.width * 0.70, size.height * 0.22), -2.1, 12),
      (Offset(size.width * 0.12, size.height * 0.68), 0.5, 12),
      (Offset(size.width * 0.88, size.height * 0.70), -2.6, 12),
    ]) {
      canvas.save();
      canvas.translate(leaf.$1.dx, leaf.$1.dy);
      canvas.rotate(leaf.$2);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(leaf.$3 * 0.35, -leaf.$3 * 0.24, leaf.$3, 0)
        ..quadraticBezierTo(leaf.$3 * 0.35, leaf.$3 * 0.24, 0, 0)
        ..close();
      canvas.drawPath(path, leafPaint);
      canvas.restore();
    }

    final particle = Paint()..color = Colors.white.withValues(alpha: isDark ? 0.46 : 0.62);
    final rng = math.Random(31);
    for (int i = 0; i < 14; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height * 0.72),
        rng.nextDouble() * 1.2 + 0.35,
        particle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BreatheHeroPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _BreathePalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFF1E4FB);
  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightCardTop = Color(0xFF955FBE);
  static const Color lightCardBottom = Color(0xFF63339A);
  static const Color darkCardTop = Color(0xFF44245C);
  static const Color darkCardBottom = Color(0xFF663783);

  static const Color lightSurface = Color(0xFFECE1FA);
  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightShadow = Color(0xFF6F39AF);
  static const Color darkShadow = Color(0xFF0C0515);
}
