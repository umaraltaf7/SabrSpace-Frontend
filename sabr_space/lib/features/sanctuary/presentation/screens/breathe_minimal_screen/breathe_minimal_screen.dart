import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
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
    final hPad = _horizontalPad(media.size.width);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
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
                      Text(
                        AppStrings.breathe,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineMedium(context).copyWith(
                          color: context.palette.breatheAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppStrings.breatheSetupSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: context.palette.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.breatheSelectTechnique,
                          style: AppTypography.labelSmall(context).copyWith(
                            color: context.palette.outline,
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
                            color: context.palette.outline,
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
                          backgroundColor: context.palette.breatheAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const StadiumBorder(),
                          elevation: 2,
                          shadowColor: context.palette.breatheAccent.withValues(
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
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        ScreenBackButton(
          iconColor: context.palette.breatheAccent,
        ),
        Expanded(
          child: Text(
            AppStrings.appName,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerif(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: context.palette.breatheAccent,
            ),
          ),
        ),
        Material(
          color: context.palette.breatheAccent.withValues(alpha: 0.12),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push('/profile'),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.person_rounded,
                color: context.palette.breatheAccent,
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
    final border = selected
        ? Border.all(color: context.palette.breatheAccent, width: 1.5)
        : Border.all(color: Colors.transparent, width: 1.5);

    final cs = Theme.of(context).colorScheme;
    final bg =
        selected ? cs.primaryContainer : cs.surfaceContainerHighest;
    // On primaryContainer, pair with onPrimaryContainer for readable contrast (light mode).
    final titleColor =
        selected ? cs.onPrimaryContainer : context.palette.breatheAccent;
    final subtitleColor = selected
        ? cs.onPrimaryContainer.withValues(alpha: 0.88)
        : context.palette.onSurfaceVariant;

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
                  color: context.palette.onSurface.withValues(alpha: 0.04),
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
                          color: context.palette.outlineVariant,
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
    final cs = Theme.of(context).colorScheme;
    final bg = cardSelected
        ? cs.onPrimaryContainer.withValues(alpha: 0.14)
        : context.palette.primaryFixed.withValues(alpha: 0.55);
    final fg = cardSelected ? cs.onPrimaryContainer : context.palette.breatheAccent;

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
                ? context.palette.breatheAccent
                : Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: context.palette.breatheAccent.withValues(alpha: 0.35),
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
              color: selected ? Colors.white : context.palette.onSurfaceVariant,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.palette.onSurface.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: context.palette.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: context.palette.secondaryFixedDim,
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
                    color: context.palette.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.breathePairDhikrSub,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: context.palette.onSurfaceVariant,
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
            activeTrackColor: context.palette.breatheAccent,
          ),
        ],
      ),
    );
  }
}
