import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/features/journal/data/providers/journal_providers.dart';

/// Journal home: month calendar (layout inspired by playful calendar UIs) using Sabr theme colors.
class JournalHistoryScreen extends ConsumerStatefulWidget {
  const JournalHistoryScreen({super.key});

  @override
  ConsumerState<JournalHistoryScreen> createState() =>
      _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends ConsumerState<JournalHistoryScreen> {
  late DateTime _monthShown;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _monthShown = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
    Future.microtask(() {
      ref.read(journalEntriesProvider.notifier).loadEntries(force: true);
    });
  }

  Map<String, List<JournalEntry>> _entriesByDay(List<JournalEntry> entries) {
    final map = <String, List<JournalEntry>>{};
    for (final e in entries) {
      final k = _dayKey(e.entryDate);
      map.putIfAbsent(k, () => []).add(e);
    }
    for (final list in map.values) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return map;
  }

  String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void _prevMonth() {
    setState(() {
      _monthShown = DateTime(_monthShown.year, _monthShown.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _monthShown = DateTime(_monthShown.year, _monthShown.month + 1, 1);
    });
  }

  void _showHelp(BuildContext context) {
    final p = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Journal',
          style: AppTypography.titleLarge(context).copyWith(color: p.onSurface),
        ),
        content: Text(
          'Pick a day on the calendar to focus your next entry. Days with a '
          'golden star already have reflections. Tap + to start writing after '
          'choosing your mood.',
          style: AppTypography.bodyMedium(context).copyWith(
            color: p.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Got it',
              style: TextStyle(
                color: isDark ? p.breatheAccent : p.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(journalEntriesProvider);
    final byDay = _entriesByDay(entries);
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: palette.surface,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/journal/mood'),
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _JournalSkyscapePainter(
              skyTop: palette.etherealGradientStart,
              skyBottom: palette.etherealGradientEnd,
              cloud: isDark
                  ? palette.onSurface.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.72),
              hillFar: palette.secondaryFixed.withValues(alpha: isDark ? 0.85 : 0.55),
              hillNear: palette.primaryFixedDim.withValues(alpha: isDark ? 0.65 : 0.42),
              orb: palette.gold.withValues(alpha: isDark ? 0.22 : 0.18),
              isDark: isDark,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Row(
                    children: [
                      ScreenBackButton(
                        iconColor: isDark ? palette.breatheAccent : palette.primary,
                        backgroundColor:
                            palette.surface.withValues(alpha: 0.88),
                      ),
                      Expanded(
                        child: Text(
                          'My Journal',
                          textAlign: TextAlign.center,
                          style: AppTypography.titleMedium(context).copyWith(
                            color: palette.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Material(
                        color: palette.surface.withValues(alpha: 0.88),
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: () => _showHelp(context),
                          icon: Icon(
                            Icons.help_outline_rounded,
                            color: isDark
                                ? palette.breatheAccent
                                : palette.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.xxl,
                    right: AppSpacing.md,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _prevMonth,
                              icon: Icon(
                                Icons.chevron_left_rounded,
                                color: palette.onSurfaceVariant,
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat.MMMM().format(_monthShown),
                                    style:
                                        AppTypography.headlineMedium(context)
                                            .copyWith(
                                      color: palette.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${_monthShown.year}',
                                    style:
                                        AppTypography.titleMedium(context)
                                            .copyWith(
                                      color: palette.onSurfaceVariant,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _nextMonth,
                              icon: Icon(
                                Icons.chevron_right_rounded,
                                color: palette.onSurfaceVariant,
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 118,
                        height: 104,
                        child: CustomPaint(
                          painter: _JournalBuddyPainter(
                            body: palette.breatheAccent,
                            bodyLight: palette.primaryFixed,
                            outline: palette.onSurface.withValues(alpha: 0.12),
                            glass: palette.secondaryFixedDim
                                .withValues(alpha: 0.35),
                            cheek: palette.primary.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                    ),
                    child: _CalendarGrid(
                      month: _monthShown,
                      selected: _selectedDay,
                      byDay: byDay,
                      palette: palette,
                      onDayTap: (day) {
                        setState(() => _selectedDay = _dateOnly(day));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.sm,
                    AppSpacing.xxl,
                    88,
                  ),
                  child: Text(
                    'Select a date to begin your journal entry.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: palette.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.selected,
    required this.byDay,
    required this.palette,
    required this.onDayTap,
  });

  final DateTime month;
  final DateTime selected;
  final Map<String, List<JournalEntry>> byDay;
  final SabrPalette palette;
  final ValueChanged<DateTime> onDayTap;

  String _key(int year, int month, int day) =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday % 7;
    final totalCells = leading + daysInMonth;
    final rows = (totalCells / 7).ceil();

    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels
              .map(
                (l) => Expanded(
                  child: Center(
                    child: Text(
                      l,
                      style: AppTypography.labelSmall(context).copyWith(
                        color: palette.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: Column(
            children: List.generate(rows, (row) {
              return Expanded(
                child: Row(
                  children: List.generate(7, (col) {
                    final index = row * 7 + col;
                    final dayNum = index - leading + 1;
                    if (dayNum < 1 || dayNum > daysInMonth) {
                      return const Expanded(child: SizedBox());
                    }
                    final day = DateTime(month.year, month.month, dayNum);
                    final k = _key(month.year, month.month, dayNum);
                    final hasEntry = byDay.containsKey(k);
                    final isSelected = day.year == selected.year &&
                        day.month == selected.month &&
                        day.day == selected.day;

                    return Expanded(
                      child: _DayCell(
                        day: dayNum,
                        hasEntry: hasEntry,
                        selected: isSelected,
                        palette: palette,
                        onTap: () => onDayTap(day),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.hasEntry,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final int day;
  final bool hasEntry;
  final bool selected;
  final SabrPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? palette.onPrimary : palette.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: palette.primary.withValues(alpha: 0.12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? palette.primary : Colors.transparent,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: palette.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '$day',
                style: AppTypography.labelLarge(context).copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              Icons.star_rounded,
              size: 11,
              color: hasEntry
                  ? palette.gold
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft sky, clouds, hills, and horizon glow — Sabr lavender palette.
class _JournalSkyscapePainter extends CustomPainter {
  _JournalSkyscapePainter({
    required this.skyTop,
    required this.skyBottom,
    required this.cloud,
    required this.hillFar,
    required this.hillNear,
    required this.orb,
    required this.isDark,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color cloud;
  final Color hillFar;
  final Color hillNear;
  final Color orb;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [skyTop, skyBottom],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final orbCenter = Offset(size.width * 0.5, size.height * 0.88);
    canvas.drawCircle(
      orbCenter,
      size.width * 0.42,
      Paint()..color = orb,
    );

    _cloud(canvas, size, Offset(size.width * 0.12, size.height * 0.14), 0.85);
    _cloud(canvas, size, Offset(size.width * 0.55, size.height * 0.08), 1.0);
    _cloud(canvas, size, Offset(size.width * 0.82, size.height * 0.20), 0.72);
    _cloud(canvas, size, Offset(size.width * 0.38, size.height * 0.26), 0.65);

    _hills(canvas, size);
  }

  void _cloud(Canvas canvas, Size size, Offset c, double scale) {
    final w = size.width * 0.22 * scale;
    final h = size.height * 0.06 * scale;
    final p = Paint()..color = cloud;
    canvas.drawOval(Rect.fromCenter(center: c, width: w, height: h), p);
    canvas.drawCircle(c + Offset(-w * 0.28, h * 0.08), h * 0.72, p);
    canvas.drawCircle(c + Offset(w * 0.28, h * 0.05), h * 0.68, p);
  }

  void _hills(Canvas canvas, Size size) {
    final far = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.62,
        size.width * 0.45,
        size.height * 0.70,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.78,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(far, Paint()..color = hillFar);

    final near = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.74,
        size.width * 0.55,
        size.height * 0.80,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.88,
        size.width,
        size.height * 0.76,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(near, Paint()..color = hillNear);
  }

  @override
  bool shouldRepaint(covariant _JournalSkyscapePainter old) =>
      old.skyTop != skyTop ||
      old.skyBottom != skyBottom ||
      old.isDark != isDark;
}

/// Friendly “peek-in” character — theme purples instead of reference teal.
class _JournalBuddyPainter extends CustomPainter {
  _JournalBuddyPainter({
    required this.body,
    required this.bodyLight,
    required this.outline,
    required this.glass,
    required this.cheek,
  });

  final Color body;
  final Color bodyLight;
  final Color outline;
  final Color glass;
  final Color cheek;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 100;
    canvas.translate(size.width * 0.1, size.height * 0.02);

    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(52 * scale, 68 * scale),
        width: 88 * scale,
        height: 76 * scale,
      ));
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = body
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * scale,
    );

    final belly = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(52 * scale, 78 * scale),
        width: 44 * scale,
        height: 36 * scale,
      ));
    canvas.drawPath(belly, Paint()..color = bodyLight.withValues(alpha: 0.55));

    final eyeL = Offset(38 * scale, 52 * scale);
    final eyeR = Offset(64 * scale, 52 * scale);
    for (final e in [eyeL, eyeR]) {
      canvas.drawCircle(e, 7 * scale, Paint()..color = Colors.white);
      canvas.drawCircle(
        e + Offset(1.5 * scale, 0),
        3.2 * scale,
        Paint()..color = const Color(0xFF2D1B3D),
      );
    }

    final glassRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(51 * scale, 52 * scale),
        width: 62 * scale,
        height: 22 * scale,
      ),
      Radius.circular(8 * scale),
    );
    canvas.drawRRect(
      glassRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale
        ..color = glass,
    );
    canvas.drawLine(
      Offset(20 * scale, 52 * scale),
      Offset(82 * scale, 52 * scale),
      Paint()
        ..strokeWidth = 2 * scale
        ..color = glass,
    );

    canvas.drawCircle(Offset(30 * scale, 64 * scale), 4 * scale, Paint()..color = cheek);
    canvas.drawCircle(Offset(72 * scale, 64 * scale), 4 * scale, Paint()..color = cheek);

    final smile = Path()
      ..moveTo(40 * scale, 72 * scale)
      ..quadraticBezierTo(51 * scale, 82 * scale, 62 * scale, 72 * scale);
    canvas.drawPath(
      smile,
      Paint()
        ..color = outline.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _JournalBuddyPainter old) =>
      old.body != body ||
      old.bodyLight != bodyLight ||
      old.outline != outline ||
      old.glass != glass ||
      old.cheek != cheek;
}
