import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/journal/data/journal_prompts.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/features/journal/data/providers/journal_providers.dart';

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
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final p = context.palette;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: p.primary,
              onPrimary: p.onPrimary,
              surface: p.surface,
              onSurface: p.onSurface,
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

    if (mounted) {
      // Pop back to journal history (remove mood + entry screens from stack)
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ── Top bar ──
                Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      'New Entry',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: context.palette.primary,
                      ),
                    ),
                    const Spacer(),
                    // Save button
                    TextButton(
                      onPressed: _saving ? null : _saveEntry,
                      child: Text(
                        _saving ? 'Saving…' : 'Save',
                        style: AppTypography.labelLarge(context).copyWith(
                          color: context.palette.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Date selector ──
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: context.palette.surfaceContainerLowest,
                      borderRadius: AppSpacing.borderRadiusFull,
                      border: Border.all(
                        color: context.palette.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: context.palette.primary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatDate(_selectedDate),
                          style: AppTypography.labelMedium(context).copyWith(
                            color: context.palette.onSurface,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: context.palette.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Mood chips (read-only display) ──
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _moods
                      .map((mood) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: context.palette.primaryFixed.withValues(alpha: 0.5),
                              borderRadius: AppSpacing.borderRadiusFull,
                            ),
                            child: Text(
                              '${mood.emoji} ${mood.label}',
                              style: AppTypography.labelSmall(context).copyWith(
                                color: context.palette.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Daily Islamic prompt ──
                Container(
                  width: double.infinity,
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x0A625195),
                        Color(0x14E9C349),
                      ],
                    ),
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: context.palette.primaryFixed.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: context.palette.secondary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'DAILY REFLECTION',
                            style: AppTypography.labelSmall(context).copyWith(
                              color: context.palette.secondary,
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
                          color: context.palette.onSurface,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Text input ──
                Expanded(
                  child: Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: context.palette.surfaceContainerLowest,
                      borderRadius: AppSpacing.borderRadiusXl,
                      boxShadow: [
                        BoxShadow(
                          color: context.palette.onSurface.withValues(alpha: 0.03),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      style: AppTypography.bodyLarge(context),
                      cursorColor: context.palette.secondary,
                      decoration: InputDecoration(
                        hintText: 'Begin writing here…',
                        hintStyle: AppTypography.bodyLarge(context).copyWith(
                          color: context.palette.outline.withValues(alpha: 0.4),
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
