import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/journal/data/providers/journal_providers.dart';

/// Full detail view of a single journal entry.
class JournalDetailScreen extends ConsumerWidget {
  const JournalDetailScreen({
    super.key,
    required this.entryId,
  });

  final String entryId;

  String _formatFullDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}  •  $hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entries = ref.watch(journalEntriesProvider);
    final entry = entries.where((e) => e.id == entryId).firstOrNull;

    if (entry == null) {
      return Scaffold(
        backgroundColor:
            isDark ? _DP.darkBgBottom : _DP.lightBgBottom,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Entry not found',
                style: AppTypography.titleMedium(context).copyWith(
                  color: isDark
                      ? _DP.darkTextPrimary
                      : _DP.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => context.go('/journal'),
                child: Text(
                  'Return to Journal',
                  style: TextStyle(
                    color: isDark ? _DP.darkAccent : _DP.lightAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDark ? _DP.darkBgBottom : _DP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_DP.darkBgTop, _DP.darkBgBottom]
                : const [_DP.lightBgTop, _DP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),

              // ── Top bar ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    ScreenBackButton(
                      iconColor:
                          isDark ? _DP.darkAccent : _DP.lightAccent,
                    ),
                    const Spacer(),
                    Text(
                      'Entry',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: isDark
                            ? _DP.darkTextPrimary
                            : _DP.lightAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark
                              ? [
                                  _DP.darkSurfaceElevated,
                                  _DP.darkSurface,
                                ]
                              : [
                                  _DP.lightSurfaceSoft,
                                  _DP.lightSurface,
                                ],
                        ),
                        border: Border.all(
                          color: isDark
                              ? _DP.darkBorder.withOpacity(0.48)
                              : _DP.lightBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? _DP.darkShadow.withOpacity(0.36)
                                : _DP.lightShadow.withOpacity(0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          final confirmed =
                              await _confirmDelete(context, isDark);
                          if (confirmed && context.mounted) {
                            ref
                                .read(journalEntriesProvider.notifier)
                                .deleteEntry(entryId);
                            context.go('/journal');
                          }
                        },
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: isDark
                              ? _DP.darkAccentSoft
                              : _DP.lightAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Decorative stars divider ──
              SizedBox(
                height: 24,
                child: CustomPaint(
                  size: const Size(220, 24),
                  painter: _StarsDividerPainter(isDark: isDark),
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date + time chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? const [
                                    _DP.darkSurfaceElevated,
                                    _DP.darkSurface,
                                  ]
                                : const [
                                    _DP.lightSurfaceSoft,
                                    _DP.lightSurface,
                                  ],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                          border: Border.all(
                            color: isDark
                                ? _DP.darkBorder.withOpacity(0.40)
                                : _DP.lightBorder,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _DP.darkShadow.withOpacity(0.32)
                                  : _DP.lightShadow.withOpacity(0.24),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _formatFullDate(entry.entryDate),
                          style:
                              AppTypography.labelSmall(context).copyWith(
                            color: isDark
                                ? _DP.darkTextSecondary
                                : _DP.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Mood chips
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: entry.moods
                            .map((mood) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                    vertical: AppSpacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isDark
                                          ? [
                                              _DP.darkAccent
                                                  .withOpacity(0.28),
                                              _DP.darkAccentSoft
                                                  .withOpacity(0.16),
                                            ]
                                          : [
                                              _DP.lightAccentSoft
                                                  .withOpacity(0.52),
                                              _DP.lightAccent
                                                  .withOpacity(0.12),
                                            ],
                                    ),
                                    borderRadius:
                                        AppSpacing.borderRadiusFull,
                                    border: Border.all(
                                      color: isDark
                                          ? _DP.darkAccent
                                              .withOpacity(0.32)
                                          : _DP.lightBorder
                                              .withOpacity(0.60),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${mood.emoji} ${mood.label}',
                                    style: AppTypography.labelMedium(
                                            context)
                                        .copyWith(
                                      color: isDark
                                          ? _DP.darkTextPrimary
                                          : _DP.lightAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      // Prompt (frosted glass card)
                      if (entry.prompt != null &&
                          entry.prompt!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      _DP.darkSurfaceElevated
                                          .withOpacity(0.85),
                                      _DP.darkSurface.withOpacity(0.70),
                                    ]
                                  : [
                                      _DP.lightSurfaceSoft
                                          .withOpacity(0.72),
                                      _DP.lightSurface.withOpacity(0.80),
                                    ],
                            ),
                            borderRadius: AppSpacing.borderRadiusMd,
                            border: Border.all(
                              color: isDark
                                  ? _DP.darkBorder.withOpacity(0.38)
                                  : _DP.lightBorder.withOpacity(0.72),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? _DP.darkShadow.withOpacity(0.42)
                                    : _DP.lightShadow.withOpacity(0.28),
                                blurRadius: 18,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark
                                          ? _DP.darkAccent
                                              .withOpacity(0.26)
                                          : _DP.lightAccentSoft
                                              .withOpacity(0.60),
                                    ),
                                    child: Icon(
                                      Icons.auto_awesome,
                                      size: 13,
                                      color: isDark
                                          ? _DP.darkAccentSoft
                                          : _DP.lightAccent,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'PROMPT',
                                    style: AppTypography.labelSmall(
                                            context)
                                        .copyWith(
                                      color: isDark
                                          ? _DP.darkAccentSoft
                                          : _DP.lightAccent,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                entry.prompt!,
                                style: AppTypography.bodyMedium(context)
                                    .copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? _DP.darkTextSecondary
                                      : _DP.lightTextSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],

                      // Full content in a paper-style card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? [
                                    _DP.darkSurface.withOpacity(0.80),
                                    _DP.darkSurfaceElevated
                                        .withOpacity(0.50),
                                  ]
                                : const [
                                    _DP.lightSurface,
                                    _DP.lightSurfaceSoft,
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? _DP.darkBorder.withOpacity(0.28)
                                : _DP.lightBorder.withOpacity(0.48),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? _DP.darkShadow.withOpacity(0.36)
                                  : _DP.lightShadow.withOpacity(0.22),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          entry.content,
                          style:
                              AppTypography.bodyLarge(context).copyWith(
                            height: 1.8,
                            color: isDark
                                ? _DP.darkTextPrimary
                                : _DP.lightTextPrimary,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.huge),

                      // Created at timestamp
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Created ${_formatFullDate(entry.createdAt)}',
                          style:
                              AppTypography.labelSmall(context).copyWith(
                            color: isDark
                                ? _DP.darkTextSecondary.withOpacity(0.50)
                                : _DP.lightTextSecondary
                                    .withOpacity(0.50),
                            fontSize: 10,
                          ),
                        ),
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

  Future<bool> _confirmDelete(BuildContext context, bool isDark) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor:
                isDark ? _DP.darkSurfaceElevated : _DP.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark
                    ? _DP.darkBorder.withOpacity(0.36)
                    : _DP.lightBorder.withOpacity(0.60),
              ),
            ),
            title: Text(
              'Delete Entry',
              style: TextStyle(
                color: isDark
                    ? _DP.darkTextPrimary
                    : _DP.lightTextPrimary,
              ),
            ),
            content: Text(
              'This entry will be permanently removed. Are you sure?',
              style: TextStyle(
                color: isDark
                    ? _DP.darkTextSecondary
                    : _DP.lightTextSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color:
                        isDark ? _DP.darkAccent : _DP.lightAccent,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFE05A6D),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative stars divider — scattered sparkles between header and content
// ─────────────────────────────────────────────────────────────────────────────

class _StarsDividerPainter extends CustomPainter {
  final bool isDark;

  _StarsDividerPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final lineColor = isDark
        ? _DP.darkBorder.withOpacity(0.30)
        : _DP.lightBorder.withOpacity(0.50);
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx - 90, cy), Offset(cx - 16, cy), linePaint);
    canvas.drawLine(Offset(cx + 16, cy), Offset(cx + 90, cy), linePaint);

    final accent = isDark ? _DP.darkAccentSoft : _DP.lightAccent;

    _drawStar(canvas, Offset(cx, cy), 6.0, accent.withOpacity(0.72));
    _drawStar(
        canvas, Offset(cx - 28, cy - 2), 3.2, accent.withOpacity(0.44));
    _drawStar(
        canvas, Offset(cx + 28, cy + 1), 3.2, accent.withOpacity(0.44));

    final dotColor = accent.withOpacity(isDark ? 0.32 : 0.28);
    final rng = Random(11);
    for (final dx in [-70.0, -50.0, 50.0, 70.0]) {
      canvas.drawCircle(
        Offset(cx + dx, cy + (rng.nextDouble() - 0.5) * 6),
        1.4,
        Paint()..color = dotColor,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r, Color color) {
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
  bool shouldRepaint(covariant _StarsDividerPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _DP {
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

  static const Color darkShadow = Color(0xFF0C0515);
}
