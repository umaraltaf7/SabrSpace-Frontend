import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';

/// Step 1 of the new-entry flow: select one or more mood tags.
///
/// Passes the selected moods to the next screen (date → entry).
class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen>
    with SingleTickerProviderStateMixin {
  final Set<JournalMood> _selected = {};
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _MP.darkBgBottom : _MP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_MP.darkBgTop, _MP.darkBgBottom]
                : const [_MP.lightBgTop, _MP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // ── Top bar ──
                  Row(
                    children: [
                      ScreenBackButton(
                        iconColor:
                            isDark ? _MP.darkAccent : _MP.lightAccent,
                      ),
                      const Spacer(),
                      Text(
                        'Journal',
                        style: AppTypography.titleMedium(context).copyWith(
                          color: isDark
                              ? _MP.darkTextPrimary
                              : _MP.lightAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Heading orb with glow ──
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark
                              ? const [
                                  _MP.darkOrbTop,
                                  _MP.darkOrbBottom,
                                ]
                              : const [
                                  _MP.lightOrbTop,
                                  _MP.lightOrbBottom,
                                ],
                        ),
                        border: Border.all(
                          color: isDark
                              ? _MP.darkAccentSoft.withOpacity(0.62)
                              : Colors.white.withOpacity(0.84),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? _MP.darkAccent.withOpacity(0.50)
                                : _MP.lightAccent.withOpacity(0.36),
                            blurRadius: 28,
                            spreadRadius: 6,
                          ),
                          BoxShadow(
                            color: isDark
                                ? _MP.darkAccentSoft.withOpacity(0.30)
                                : _MP.lightAccentSoft.withOpacity(0.34),
                            blurRadius: 48,
                            spreadRadius: 14,
                          ),
                          if (isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              blurRadius: 18,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                        ],
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  Center(
                    child: Text(
                      'How are you feeling?',
                      style:
                          AppTypography.headlineSmall(context).copyWith(
                        color: isDark
                            ? _MP.darkTextPrimary
                            : _MP.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: Text(
                      'Select the moods that resonate with you right now.',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: isDark
                            ? _MP.darkTextSecondary
                            : _MP.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Decorative sparkle divider ──
                  Center(
                    child: SizedBox(
                      height: 20,
                      child: CustomPaint(
                        size: const Size(160, 20),
                        painter:
                            _SparkleLinePainter(isDark: isDark),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Mood chips ──
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: JournalMood.values
                        .map((mood) => _MoodChip(
                              mood: mood,
                              isDark: isDark,
                              isSelected: _selected.contains(mood),
                              onTap: () => setState(() {
                                if (_selected.contains(mood)) {
                                  _selected.remove(mood);
                                } else {
                                  _selected.add(mood);
                                }
                              }),
                            ))
                        .toList(),
                  ),

                  const Spacer(),

                  // ── Continue button ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _selected.isNotEmpty ? 1.0 : 0.35,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? const [
                                    _MP.darkAccent,
                                    _MP.darkAccentSoft,
                                  ]
                                : const [
                                    _MP.lightAccent,
                                    _MP.lightOrbTop,
                                  ],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                          boxShadow: _selected.isNotEmpty
                              ? [
                                  BoxShadow(
                                    color: isDark
                                        ? _MP.darkAccent.withOpacity(0.40)
                                        : _MP.lightAccent
                                            .withOpacity(0.36),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                  BoxShadow(
                                    color: isDark
                                        ? _MP.darkAccentSoft
                                            .withOpacity(0.22)
                                        : _MP.lightAccentSoft
                                            .withOpacity(0.28),
                                    blurRadius: 40,
                                    spreadRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton(
                          onPressed: _selected.isNotEmpty
                              ? () {
                                  final moodIndices = _selected
                                      .map((m) => m.index.toString())
                                      .join(',');
                                  context.push(
                                    '/journal/entry?moods=$moodIndices',
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.transparent,
                            disabledForegroundColor:
                                Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusFull,
                            ),
                          ),
                          child: Text(
                            _selected.isNotEmpty
                                ? 'Continue'
                                : 'Select a mood to continue',
                            style: AppTypography.labelLarge(context)
                                .copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOOD CHIP WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.mood,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  final JournalMood mood;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          _MP.darkAccent.withOpacity(0.32),
                          _MP.darkAccentSoft.withOpacity(0.18),
                        ]
                      : [
                          _MP.lightAccentSoft.withOpacity(0.60),
                          _MP.lightAccent.withOpacity(0.14),
                        ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          _MP.darkSurfaceElevated,
                          _MP.darkSurface,
                        ]
                      : [
                          _MP.lightSurfaceSoft,
                          _MP.lightSurface,
                        ],
                ),
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: isSelected
                ? (isDark
                    ? _MP.darkAccent.withOpacity(0.72)
                    : _MP.lightAccent.withOpacity(0.72))
                : (isDark
                    ? _MP.darkBorder.withOpacity(0.36)
                    : _MP.lightBorder.withOpacity(0.72)),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: isDark
                        ? _MP.darkAccent.withOpacity(0.28)
                        : _MP.lightAccent.withOpacity(0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark
                        ? _MP.darkShadow.withOpacity(0.30)
                        : _MP.lightShadow.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: AppSpacing.sm),
            Text(
              mood.label,
              style: AppTypography.labelLarge(context).copyWith(
                color: isSelected
                    ? (isDark
                        ? _MP.darkTextPrimary
                        : _MP.lightAccent)
                    : (isDark
                        ? _MP.darkTextPrimary
                        : _MP.lightTextPrimary),
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sparkle line divider
// ─────────────────────────────────────────────────────────────────────────────

class _SparkleLinePainter extends CustomPainter {
  final bool isDark;
  _SparkleLinePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final lineColor = isDark
        ? _MP.darkBorder.withOpacity(0.30)
        : _MP.lightBorder.withOpacity(0.50);

    canvas.drawLine(
      Offset(cx - 70, cy),
      Offset(cx - 12, cy),
      Paint()
        ..color = lineColor
        ..strokeWidth = 0.8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(cx + 12, cy),
      Offset(cx + 70, cy),
      Paint()
        ..color = lineColor
        ..strokeWidth = 0.8
        ..strokeCap = StrokeCap.round,
    );

    final accent = isDark ? _MP.darkAccentSoft : _MP.lightAccent;

    final diamond = Path()
      ..moveTo(cx, cy - 5)
      ..lineTo(cx + 5, cy)
      ..lineTo(cx, cy + 5)
      ..lineTo(cx - 5, cy)
      ..close();
    canvas.drawPath(
      diamond,
      Paint()..color = accent.withOpacity(isDark ? 0.68 : 0.54),
    );

    final dotColor = accent.withOpacity(isDark ? 0.40 : 0.30);
    for (final dx in [-50.0, -30.0, 30.0, 50.0]) {
      canvas.drawCircle(Offset(cx + dx, cy), 1.5, Paint()..color = dotColor);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkleLinePainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _MP {
  // ── Light mode ──
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);

  static const Color lightBorder = Color(0xFFBC95D8);

  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  static const Color lightShadow = Color(0xFF6F39AF);

  // ── Dark mode ──
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);

  static const Color darkShadow = Color(0xFF0C0515);
}
