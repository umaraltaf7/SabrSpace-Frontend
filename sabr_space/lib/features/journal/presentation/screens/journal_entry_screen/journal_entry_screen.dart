import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/journal/data/journal_prompts.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/core/providers/mood_update_progress_provider.dart';
import 'package:sabr_space/features/journal/data/providers/journal_providers.dart';
import 'package:sabr_space/features/journal/data/journal_entry_flow.dart';
import 'package:sabr_space/features/journal/presentation/widgets/journal_flow_progress_bar.dart';

/// Step 2+3 combined: date picker + writing screen.
///
/// Receives mood indices via query parameter. Shows date picker at top,
/// daily Islamic prompt, and a large text input.
class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({
    super.key,
    required this.moodIndices,
  });

  /// Comma-separated mood enum indices (e.g., "0,3,4").
  final String moodIndices;

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final TextEditingController _textController = TextEditingController();
  late DateTime _selectedDate;
  late String _prompt;
  late List<JournalMood> _moods;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _prompt = JournalPrompts.todayPrompt();
    _moods = widget.moodIndices
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) => JournalMood.values[int.parse(s)])
        .toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: _JP.darkAccent,
                    onPrimary: Colors.white,
                    surface: _JP.darkSurface,
                    onSurface: _JP.darkTextPrimary,
                  )
                : const ColorScheme.light(
                    primary: _JP.lightAccent,
                    onPrimary: Colors.white,
                    surface: _JP.lightSurface,
                    onSurface: _JP.lightTextPrimary,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveEntry() async {
    final content = _textController.text.trim();
    if (content.isEmpty) return;

    setState(() => _saving = true);

    final entry = JournalEntry(
      id: const Uuid().v4(),
      content: content,
      entryDate: _selectedDate,
      createdAt: DateTime.now(),
      moods: _moods,
      prompt: _prompt,
    );

    await ref.read(journalEntriesProvider.notifier).addEntry(entry);
    await ref.read(moodUpdateProgressProvider.notifier).completeJournal();

    if (mounted) {
      context.go('/journal');
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final isToday = _isToday(date);
    final prefix = isToday ? 'Today, ' : '';
    return '$prefix${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _JP.darkBgBottom : _JP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_JP.darkBgTop, _JP.darkBgBottom]
                : const [_JP.lightBgTop, _JP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),

                // ── Top bar (flow progress + save) ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ScreenBackButton(
                      iconColor:
                          isDark ? _JP.darkAccent : _JP.lightAccent,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: JournalFlowProgressBar(
                          currentStep: JournalEntryFlow.totalSteps,
                          stepCount: JournalEntryFlow.totalSteps,
                        ),
                      ),
                    ),
                    _SaveButton(
                      saving: _saving,
                      onPressed: _saving ? null : _saveEntry,
                      isDark: isDark,
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      'New Entry',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: isDark
                            ? _JP.darkTextPrimary
                            : _JP.lightAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Decorative quill header ──
                Center(
                  child: SizedBox(
                    height: 48,
                    child: CustomPaint(
                      size: const Size(200, 48),
                      painter: _QuillOrnamentPainter(isDark: isDark),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Date selector ──
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? const [
                                _JP.darkSurfaceElevated,
                                _JP.darkSurface,
                              ]
                            : const [
                                _JP.lightSurfaceSoft,
                                _JP.lightSurface,
                              ],
                      ),
                      borderRadius: AppSpacing.borderRadiusFull,
                      border: Border.all(
                        color: isDark
                            ? _JP.darkBorder.withOpacity(0.50)
                            : _JP.lightBorder,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? _JP.darkShadow.withOpacity(0.40)
                              : _JP.lightShadow.withOpacity(0.36),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: isDark
                              ? _JP.darkAccent
                              : _JP.lightAccent,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatDate(_selectedDate),
                          style: AppTypography.labelMedium(context).copyWith(
                            color: isDark
                                ? _JP.darkTextPrimary
                                : _JP.lightTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: isDark
                              ? _JP.darkTextSecondary
                              : _JP.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Mood chips (read-only display) ──
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _moods
                      .map((mood) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs + 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        _JP.darkAccent.withOpacity(0.28),
                                        _JP.darkAccentSoft.withOpacity(0.16),
                                      ]
                                    : [
                                        _JP.lightAccentSoft.withOpacity(0.52),
                                        _JP.lightAccent.withOpacity(0.12),
                                      ],
                              ),
                              borderRadius: AppSpacing.borderRadiusFull,
                              border: Border.all(
                                color: isDark
                                    ? _JP.darkAccent.withOpacity(0.32)
                                    : _JP.lightBorder.withOpacity(0.60),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${mood.emoji} ${mood.label}',
                              style:
                                  AppTypography.labelSmall(context).copyWith(
                                color: isDark
                                    ? _JP.darkTextPrimary
                                    : _JP.lightAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Daily Islamic prompt (frosted-glass card) ──
                Container(
                  width: double.infinity,
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              _JP.darkSurfaceElevated.withOpacity(0.85),
                              _JP.darkSurface.withOpacity(0.70),
                            ]
                          : [
                              _JP.lightSurfaceSoft.withOpacity(0.72),
                              _JP.lightSurface.withOpacity(0.80),
                            ],
                    ),
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: isDark
                          ? _JP.darkBorder.withOpacity(0.38)
                          : _JP.lightBorder.withOpacity(0.72),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _JP.darkShadow.withOpacity(0.42)
                            : _JP.lightShadow.withOpacity(0.32),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                      if (!isDark)
                        BoxShadow(
                          color: _JP.lightAccent.withOpacity(0.06),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? _JP.darkAccent.withOpacity(0.26)
                                  : _JP.lightAccentSoft.withOpacity(0.60),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: isDark
                                  ? _JP.darkAccentSoft
                                  : _JP.lightAccent,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'DAILY REFLECTION',
                            style:
                                AppTypography.labelSmall(context).copyWith(
                              color: isDark
                                  ? _JP.darkAccentSoft
                                  : _JP.lightAccent,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _prompt,
                        style: AppTypography.bodyLarge(context).copyWith(
                          color: isDark
                              ? _JP.darkTextPrimary
                              : _JP.lightTextPrimary,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Text input ──
                Expanded(
                  child: Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                _JP.darkSurface.withOpacity(0.80),
                                _JP.darkSurfaceElevated.withOpacity(0.50),
                              ]
                            : const [
                                _JP.lightSurface,
                                _JP.lightSurfaceSoft,
                              ],
                      ),
                      borderRadius: AppSpacing.borderRadiusXl,
                      border: Border.all(
                        color: isDark
                            ? _JP.darkBorder.withOpacity(0.28)
                            : _JP.lightBorder.withOpacity(0.48),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? _JP.darkShadow.withOpacity(0.36)
                              : _JP.lightShadow.withOpacity(0.28),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      style: AppTypography.bodyLarge(context).copyWith(
                        color: isDark
                            ? _JP.darkTextPrimary
                            : _JP.lightTextPrimary,
                      ),
                      cursorColor:
                          isDark ? _JP.darkAccent : _JP.lightAccent,
                      decoration: InputDecoration(
                        hintText: 'Begin writing here…',
                        hintStyle:
                            AppTypography.bodyLarge(context).copyWith(
                          color: isDark
                              ? _JP.darkTextSecondary.withOpacity(0.40)
                              : _JP.lightTextSecondary.withOpacity(0.50),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Save button with gradient pill style
// ─────────────────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.saving,
    required this.onPressed,
    required this.isDark,
  });

  final bool saving;
  final VoidCallback? onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [_JP.darkAccent, _JP.darkAccentSoft]
                : const [_JP.lightAccent, _JP.lightOrbTop],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? _JP.darkAccent.withOpacity(0.36)
                  : _JP.lightAccent.withOpacity(0.32),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          saving ? 'Saving…' : 'Save',
          style: AppTypography.labelLarge(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative quill ornament — a tiny crescent, feather quill, and sparkles
// ─────────────────────────────────────────────────────────────────────────────

class _QuillOrnamentPainter extends CustomPainter {
  final bool isDark;

  _QuillOrnamentPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Horizontal line ornament
    final lineColor = isDark
        ? _JP.darkBorder.withOpacity(0.36)
        : _JP.lightBorder.withOpacity(0.56);
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(cx - 80, cy),
      Offset(cx - 20, cy),
      linePaint,
    );
    canvas.drawLine(
      Offset(cx + 20, cy),
      Offset(cx + 80, cy),
      linePaint,
    );

    // Central diamond
    final accentColor =
        isDark ? _JP.darkAccentSoft : _JP.lightAccent;
    final diamondPath = Path()
      ..moveTo(cx, cy - 7)
      ..lineTo(cx + 7, cy)
      ..lineTo(cx, cy + 7)
      ..lineTo(cx - 7, cy)
      ..close();
    canvas.drawPath(
      diamondPath,
      Paint()..color = accentColor.withOpacity(isDark ? 0.72 : 0.58),
    );

    // Small dots along the lines
    final dotColor = accentColor.withOpacity(isDark ? 0.48 : 0.36);
    for (final dx in [-60.0, -40.0, 40.0, 60.0]) {
      canvas.drawCircle(
        Offset(cx + dx, cy),
        1.8,
        Paint()..color = dotColor,
      );
    }

    // Tiny sparkles at ends
    _drawSparkle(canvas, Offset(cx - 85, cy), 3.5, accentColor);
    _drawSparkle(canvas, Offset(cx + 85, cy), 3.5, accentColor);
  }

  void _drawSparkle(Canvas canvas, Offset c, double r, Color color) {
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
    canvas.drawPath(
      path,
      Paint()..color = color.withOpacity(isDark ? 0.60 : 0.48),
    );
  }

  @override
  bool shouldRepaint(covariant _QuillOrnamentPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Journal palette — mirrors the home screen's purple-pinkish scheme
// ─────────────────────────────────────────────────────────────────────────────

class _JP {
  // ── Light mode (exact home screen palette) ──
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);
  static const Color lightSurfaceElevated = Color(0xFFC9A7E2);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);

  static const Color lightBorder = Color(0xFFBC95D8);

  static const Color lightOrbTop = Color(0xFFB786D6);

  static const Color lightShadow = Color(0xFF6F39AF);

  // ── Dark mode (exact home screen palette) ──
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
