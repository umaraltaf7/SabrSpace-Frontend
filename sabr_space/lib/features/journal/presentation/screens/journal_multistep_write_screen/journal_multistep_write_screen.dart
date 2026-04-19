import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/features/journal/data/journal_entry_flow.dart';
import 'package:sabr_space/features/journal/data/journal_prompts.dart';
import 'package:sabr_space/features/journal/data/services/journal_bravery_points.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/features/journal/data/providers/journal_providers.dart';
import 'package:sabr_space/features/journal/presentation/widgets/journal_flow_progress_bar.dart';

const _kMaxChars = 4000;

const _kStepTitles = <String>[
  '3 things you accomplished today, big or small:',
  'Is something weighing you down? Write it down and let it go.',
  'What are you feeling grateful for?',
  'Additional Notes:',
];

const _kSectionHeaders = <String>[
  'Today I accomplished',
  'Letting go',
  'Gratitude',
  'Additional notes',
];

const _kMotivations = <String>[
  'Indeed, with hardship comes ease. (Qur\'an 94:6)',
  'Allah does not burden a soul beyond that it can bear. (Qur\'an 2:286)',
  'So be patient. Indeed, the promise of Allah is truth. (Qur\'an 30:60)',
  'Taking time to write is a gentle act of care for your heart.',
  'Your feelings are safe here — there is no rush and no wrong answer.',
  'Small steps of reflection can soften a heavy day.',
  'Allah sees your effort, even when no one else does.',
  'Let this space be for honesty; Allah is the Most Merciful.',
];

/// Guided journal writing after mood selection — four prompts, shared header, save at end.
class JournalMultistepWriteScreen extends ConsumerStatefulWidget {
  const JournalMultistepWriteScreen({
    super.key,
    required this.moodIndices,
  });

  final String moodIndices;

  @override
  ConsumerState<JournalMultistepWriteScreen> createState() =>
      _JournalMultistepWriteScreenState();
}

class _JournalMultistepWriteScreenState
    extends ConsumerState<JournalMultistepWriteScreen> {
  static final _random = Random();

  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  int _step = 0;
  bool _saving = false;

  late final List<JournalMood> _moods;

  @override
  void initState() {
    super.initState();
    final parsed = widget.moodIndices
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) {
          final i = int.tryParse(s);
          if (i == null ||
              i < 0 ||
              i >= JournalMood.values.length) {
            return JournalMood.reflection;
          }
          return JournalMood.values[i];
        })
        .toList();
    _moods = parsed.isEmpty ? [JournalMood.reflection] : parsed;
    for (final c in _controllers) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _currentFilled =>
      _controllers[_step].text.trim().isNotEmpty;

  bool get _canSubmit =>
      _controllers[0].text.trim().isNotEmpty &&
      _controllers[1].text.trim().isNotEmpty &&
      _controllers[2].text.trim().isNotEmpty;

  bool get _anyText =>
      _controllers.any((c) => c.text.trim().isNotEmpty);

  void _showMotivation(BuildContext context) {
    final palette = context.palette;
    final quote = _kMotivations[_random.nextInt(_kMotivations.length)];
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: palette.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: palette.gold, size: 26),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'A note for you',
                style: AppTypography.titleLarge(ctx).copyWith(
                  color: palette.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          quote,
          style: AppTypography.bodyLarge(ctx).copyWith(
            color: palette.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Thank you',
              style: TextStyle(
                color: palette.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmExit() async {
    if (!_anyText) {
      if (mounted) context.go('/journal');
      return;
    }
    final palette = context.palette;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Discard entry?',
          style: AppTypography.titleMedium(ctx).copyWith(
            color: palette.onSurface,
          ),
        ),
        content: Text(
          'Your writing will not be saved.',
          style: AppTypography.bodyMedium(ctx).copyWith(
            color: palette.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Keep writing',
              style: TextStyle(color: palette.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Discard',
              style: TextStyle(
                color: palette.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (ok == true && mounted) context.go('/journal');
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step -= 1);
    } else {
      context.pop();
    }
  }

  void _next() {
    if (!_currentFilled) return;
    if (_step < 3) {
      setState(() => _step += 1);
    }
  }

  String _composeContent() {
    final b = StringBuffer();
    for (var i = 0; i < 4; i++) {
      b.writeln('— ${_kSectionHeaders[i]} —');
      b.writeln(_controllers[i].text.trim());
      if (i < 3) b.writeln();
    }
    return b.toString();
  }

  Future<void> _save() async {
    if (!_canSubmit || _saving) return;
    setState(() => _saving = true);
    final entry = JournalEntry(
      id: const Uuid().v4(),
      content: _composeContent(),
      entryDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      createdAt: DateTime.now(),
      moods: _moods,
      prompt: JournalPrompts.todayPrompt(),
    );
    await ref.read(journalEntriesProvider.notifier).addEntry(entry);
    final total = await JournalBraveryPoints.addJournalCompletionReward();
    if (mounted) {
      context.go('/journal/reward', extra: total);
    }
  }

  void _micTapped() {
    context.push('/journal/voice-premium');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLast = _step == 3;
    final forwardEnabled =
        isLast ? _canSubmit && !_saving : _currentFilled;

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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _RoundHeaderIcon(
                      palette: palette,
                      onPressed: _confirmExit,
                      child: Icon(
                        Icons.close_rounded,
                        size: 22,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: JournalFlowProgressBar(
                          currentStep:
                              JournalEntryFlow.globalStepForWritingIndex(
                            _step,
                          ),
                          stepCount: JournalEntryFlow.totalSteps,
                        ),
                      ),
                    ),
                    _RoundHeaderIcon(
                      palette: palette,
                      onPressed: () => _showMotivation(context),
                      child: Icon(
                        Icons.star_rounded,
                        size: 22,
                        color: palette.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  _kStepTitles[_step],
                  style: AppTypography.headlineSmall(context).copyWith(
                    color: palette.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        top: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: palette.surface,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: palette.outlineVariant
                                  .withValues(alpha: 0.45),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: palette.primary.withValues(
                                  alpha: isDark ? 0.14 : 0.10,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      AppSpacing.xl,
                                      AppSpacing.xxl,
                                      AppSpacing.xl,
                                      40,
                                    ),
                                    child: TextField(
                                      key: ValueKey(_step),
                                      controller: _controllers[_step],
                                      maxLength: _kMaxChars,
                                      maxLines: null,
                                      expands: true,
                                      textAlignVertical:
                                          TextAlignVertical.top,
                                      style:
                                          AppTypography.bodyLarge(context)
                                              .copyWith(
                                        color: palette.onSurface,
                                        height: 1.45,
                                      ),
                                      cursorColor: palette.primary,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Start writing…',
                                        hintStyle: AppTypography.bodyLarge(
                                          context,
                                        ).copyWith(
                                          color: palette.onSurfaceVariant
                                              .withValues(alpha: 0.45),
                                        ),
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: AppSpacing.lg,
                                  bottom: AppSpacing.md,
                                  child: ValueListenableBuilder<
                                      TextEditingValue>(
                                    valueListenable: _controllers[_step],
                                    builder: (context, value, _) {
                                      return Text(
                                        '${value.text.length}/$_kMaxChars',
                                        style: AppTypography.labelSmall(
                                          context,
                                        ).copyWith(
                                          color: palette.onSurfaceVariant
                                              .withValues(alpha: 0.75),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: AppSpacing.xl,
                        child: IgnorePointer(
                          child: CustomPaint(
                            size: const Size(92, 76),
                            painter: _WriterBuddyPainter(
                              body: palette.breatheAccent,
                              bodySoft: palette.primaryFixed,
                              book: palette.secondaryFixedDim,
                              ink: palette.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: palette.surfaceContainerLow,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _micTapped,
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.mic_none_rounded,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _FooterPill(
                        palette: palette,
                        icon: Icons.chevron_left_rounded,
                        enabled: true,
                        onTap: _back,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _FooterPill(
                        palette: palette,
                        icon: isLast
                            ? Icons.check_rounded
                            : Icons.chevron_right_rounded,
                        enabled: forwardEnabled,
                        onTap: isLast
                            ? (_canSubmit && !_saving ? _save : null)
                            : (_currentFilled ? _next : null),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundHeaderIcon extends StatelessWidget {
  const _RoundHeaderIcon({
    required this.palette,
    required this.onPressed,
    required this.child,
  });

  final SabrPalette palette;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _FooterPill extends StatelessWidget {
  const _FooterPill({
    required this.palette,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final SabrPalette palette;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? palette.primary
          : palette.onSurface.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Center(
            child: Icon(
              icon,
              size: 28,
              color: enabled
                  ? palette.onPrimary
                  : palette.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small mascot writing in a book — Sabr purples (replaces reference teal art).
class _WriterBuddyPainter extends CustomPainter {
  _WriterBuddyPainter({
    required this.body,
    required this.bodySoft,
    required this.book,
    required this.ink,
  });

  final Color body;
  final Color bodySoft;
  final Color book;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide / 76;
    canvas.translate(size.width * 0.08, size.height * 0.06);

    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(40 * s, 48 * s),
        width: 58 * s,
        height: 48 * s,
      ));
    canvas.drawPath(bodyPath, Paint()..color = body);
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = bodySoft.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * s,
    );

    final bookRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(52 * s, 44 * s),
        width: 22 * s,
        height: 18 * s,
      ),
      Radius.circular(3 * s),
    );
    canvas.drawRRect(bookRect, Paint()..color = book.withValues(alpha: 0.9));
    canvas.drawLine(
      Offset(42 * s, 44 * s),
      Offset(58 * s, 42 * s),
      Paint()
        ..color = ink.withValues(alpha: 0.5)
        ..strokeWidth = 1.4 * s
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(28 * s, 42 * s),
      3.2 * s,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );
    canvas.drawCircle(
      Offset(28.8 * s, 42 * s),
      1.4 * s,
      Paint()..color = const Color(0xFF2D1B3D),
    );
    canvas.drawCircle(
      Offset(38 * s, 40 * s),
      3 * s,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );
    canvas.drawCircle(
      Offset(38.8 * s, 40 * s),
      1.2 * s,
      Paint()..color = const Color(0xFF2D1B3D),
    );

    final smile = Path()
      ..moveTo(26 * s, 52 * s)
      ..quadraticBezierTo(34 * s, 58 * s, 42 * s, 52 * s);
    canvas.drawPath(
      smile,
      Paint()
        ..color = ink.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _WriterBuddyPainter old) =>
      old.body != body ||
      old.bodySoft != bodySoft ||
      old.book != book ||
      old.ink != ink;
}
