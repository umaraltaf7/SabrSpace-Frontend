import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/features/journal/data/providers/journal_providers.dart';

/// Main journal screen: scrollable history of all entries with "New Entry" FAB.
class JournalHistoryScreen extends ConsumerStatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  ConsumerState<JournalHistoryScreen> createState() =>
      _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends ConsumerState<JournalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(journalEntriesProvider.notifier).loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entries = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: isDark ? _HP.darkBgBottom : _HP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_HP.darkBgTop, _HP.darkBgBottom]
                : const [_HP.lightBgTop, _HP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          isDark ? _HP.darkAccent : _HP.lightAccent,
                    ),
                    const Spacer(),
                    Text(
                      'Journal',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: isDark
                            ? _HP.darkTextPrimary
                            : _HP.lightAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Hero banner with moon scene ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [_HP.darkHeroTop, _HP.darkHeroBottom]
                          : const [_HP.lightHeroTop, _HP.lightHeroBottom],
                    ),
                    border: Border.all(
                      color: isDark
                          ? Colors.black.withOpacity(0.22)
                          : Colors.white.withOpacity(0.12),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _HP.darkShadow.withOpacity(0.60)
                            : _HP.lightShadow.withOpacity(0.50),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter:
                                _JournalBannerPainter(isDark: isDark),
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
                                    Colors.white
                                        .withOpacity(isDark ? 0.12 : 0.22),
                                    Colors.transparent,
                                    Colors.white
                                        .withOpacity(isDark ? 0.04 : 0.08),
                                  ],
                                  stops: const [0.0, 0.48, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Your Reflections',
                                style: AppTypography.headlineSmall(context)
                                    .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${entries.length} ${entries.length == 1 ? 'entry' : 'entries'}',
                                style:
                                    AppTypography.bodySmall(context).copyWith(
                                  color: Colors.white.withOpacity(0.80),
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

              const SizedBox(height: AppSpacing.xxl),

              // ── Entry list or empty state ──
              Expanded(
                child: entries.isEmpty
                    ? _EmptyState(isDark: isDark)
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                        ),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return _JournalEntryCard(
                            entry: entries[index],
                            isDark: isDark,
                            onTap: () => context.push(
                              '/journal/detail/${entries[index].id}',
                            ),
                            onDelete: () async {
                              final confirmed =
                                  await _confirmDelete(context, isDark);
                              if (confirmed) {
                                ref
                                    .read(journalEntriesProvider.notifier)
                                    .deleteEntry(entries[index].id);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // ── New Entry FAB ──
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [_HP.darkAccent, _HP.darkAccentSoft]
                : const [_HP.lightAccent, _HP.lightOrbTop],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _HP.darkAccent.withOpacity(0.46)
                  : _HP.lightAccent.withOpacity(0.40),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: isDark
                  ? _HP.darkAccentSoft.withOpacity(0.24)
                  : _HP.lightAccentSoft.withOpacity(0.30),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/journal/mood'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.edit_note_rounded),
          label: Text(
            'New Entry',
            style: AppTypography.labelLarge(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
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
                isDark ? _HP.darkSurfaceElevated : _HP.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark
                    ? _HP.darkBorder.withOpacity(0.36)
                    : _HP.lightBorder.withOpacity(0.60),
              ),
            ),
            title: Text(
              'Delete Entry',
              style: TextStyle(
                color: isDark
                    ? _HP.darkTextPrimary
                    : _HP.lightTextPrimary,
              ),
            ),
            content: Text(
              'This entry will be permanently removed. Are you sure?',
              style: TextStyle(
                color: isDark
                    ? _HP.darkTextSecondary
                    : _HP.lightTextSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDark ? _HP.darkAccent : _HP.lightAccent,
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
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          _HP.darkSurfaceElevated,
                          _HP.darkSurface,
                        ]
                      : [
                          _HP.lightSurfaceSoft,
                          _HP.lightSurface,
                        ],
                ),
                border: Border.all(
                  color: isDark
                      ? _HP.darkBorder.withOpacity(0.40)
                      : _HP.lightBorder,
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? _HP.darkAccent.withOpacity(0.22)
                        : _HP.lightAccent.withOpacity(0.18),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.book_outlined,
                size: 36,
                color: isDark ? _HP.darkAccent : _HP.lightAccent,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Your journal is empty',
              style: AppTypography.titleMedium(context).copyWith(
                color: isDark
                    ? _HP.darkTextPrimary
                    : _HP.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Begin your first reflection.\nTap "New Entry" to start writing.',
              style: AppTypography.bodySmall(context).copyWith(
                color: isDark
                    ? _HP.darkTextSecondary
                    : _HP.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JOURNAL ENTRY CARD
// ─────────────────────────────────────────────────────────────────────────────

class _JournalEntryCard extends StatelessWidget {
  const _JournalEntryCard({
    required this.entry,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  final JournalEntry entry;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _HP.darkSurfaceElevated,
                    _HP.darkSurface,
                  ]
                : const [
                    _HP.lightSurfaceSoft,
                    _HP.lightSurface,
                  ],
          ),
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: isDark
                ? _HP.darkBorder.withOpacity(0.36)
                : _HP.lightBorder,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _HP.darkShadow.withOpacity(0.42)
                  : _HP.lightShadow.withOpacity(0.30),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? _HP.darkAccent.withOpacity(0.18)
                        : _HP.lightAccentSoft.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _formatDate(entry.entryDate),
                    style: AppTypography.labelSmall(context).copyWith(
                      color: isDark
                          ? _HP.darkAccentSoft
                          : _HP.lightAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: isDark
                        ? _HP.darkTextSecondary.withOpacity(0.40)
                        : _HP.lightTextSecondary.withOpacity(0.50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              entry.preview,
              style: AppTypography.bodyMedium(context).copyWith(
                color: isDark
                    ? _HP.darkTextPrimary
                    : _HP.lightTextPrimary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: entry.moods
                  .map((mood) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    _HP.darkAccent.withOpacity(0.22),
                                    _HP.darkAccentSoft.withOpacity(0.12),
                                  ]
                                : [
                                    _HP.lightAccentSoft.withOpacity(0.48),
                                    _HP.lightAccent.withOpacity(0.10),
                                  ],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                          border: Border.all(
                            color: isDark
                                ? _HP.darkAccent.withOpacity(0.24)
                                : _HP.lightBorder.withOpacity(0.50),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          '${mood.emoji} ${mood.label}',
                          style:
                              AppTypography.labelSmall(context).copyWith(
                            color: isDark
                                ? _HP.darkTextPrimary
                                : _HP.lightAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner painter — crescent moon, sparkles, hills (mini home hero)
// ─────────────────────────────────────────────────────────────────────────────

class _JournalBannerPainter extends CustomPainter {
  final bool isDark;
  _JournalBannerPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    _paintHills(canvas, size);
    _paintMoon(canvas, size);
    _paintSparkles(canvas, size);
  }

  void _paintMoon(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.82, size.height * 0.32);
    final radius = size.width * 0.09;

    final moonColor =
        isDark ? const Color(0xFFF8DEAA) : const Color(0xFFF9EACB);

    canvas.drawCircle(
      center,
      radius * 2.0,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.12 : 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    final cutPath = Path()
      ..addOval(Rect.fromCircle(
        center: center + Offset(radius * 0.38, -radius * 0.15),
        radius: radius * 0.92,
      ));
    final crescent =
        Path.combine(PathOperation.difference, moonPath, cutPath);
    canvas.drawPath(
      crescent,
      Paint()..color = moonColor.withOpacity(isDark ? 0.96 : 1.0),
    );
  }

  void _paintHills(Canvas canvas, Size size) {
    final farColor = isDark
        ? const Color(0xFF7A4B95).withOpacity(0.50)
        : const Color(0xFFD2B6E8).withOpacity(0.54);

    final far = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.68)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.50,
          size.width * 0.50, size.height * 0.65)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.80,
          size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(far, Paint()..color = farColor);

    final nearColor = isDark
        ? const Color(0xFF4B285F).withOpacity(0.86)
        : const Color(0xFFA978CC).withOpacity(0.50);

    final near = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.82)
      ..quadraticBezierTo(
          size.width * 0.35, size.height * 0.68,
          size.width * 0.60, size.height * 0.78)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.88,
          size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(near, Paint()..color = nearColor);
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final bright = isDark
        ? Colors.white.withOpacity(1.0)
        : Colors.white.withOpacity(0.96);
    final warm = isDark
        ? const Color(0xFFF8DEAA).withOpacity(1.0)
        : const Color(0xFFF9EACB).withOpacity(0.99);

    _drawSparkle(canvas, Offset(size.width * 0.15, size.height * 0.20),
        4.0, bright);
    _drawSparkle(canvas, Offset(size.width * 0.40, size.height * 0.14),
        3.0, warm);
    _drawSparkle(canvas, Offset(size.width * 0.62, size.height * 0.22),
        2.5, bright);
    _drawSparkle(canvas, Offset(size.width * 0.72, size.height * 0.10),
        3.5, warm);

    final dotColor = isDark
        ? Colors.white.withOpacity(0.48)
        : Colors.white.withOpacity(0.62);
    final rng = Random(42);
    for (int i = 0; i < 8; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.50;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.2 + 0.3,
        Paint()..color = dotColor,
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
  bool shouldRepaint(covariant _JournalBannerPainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _HP {
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

  static const Color lightHeroTop = Color(0xFF552688);
  static const Color lightHeroBottom = Color(0xFF3B1A66);

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

  static const Color darkHeroTop = Color(0xFF5A2F79);
  static const Color darkHeroBottom = Color(0xFF763E9D);

  static const Color darkShadow = Color(0xFF0C0515);
}
