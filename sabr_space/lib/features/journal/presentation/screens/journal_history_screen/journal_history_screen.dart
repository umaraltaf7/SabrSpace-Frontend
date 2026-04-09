import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
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
    // Load entries on first build
    Future.microtask(() {
      ref.read(journalEntriesProvider.notifier).loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(journalEntriesProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      'Journal',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: context.palette.primary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Heading ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Reflections',
                      style: AppTypography.headlineSmall(context),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${entries.length} ${entries.length == 1 ? 'entry' : 'entries'}',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: context.palette.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Entry list or empty state ──
              Expanded(
                child: entries.isEmpty
                    ? _EmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                        ),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return _JournalEntryCard(
                            entry: entries[index],
                            onTap: () => context.push(
                              '/journal/detail/${entries[index].id}',
                            ),
                            onDelete: () async {
                              final confirmed = await _confirmDelete(context);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/journal/mood'),
        backgroundColor: context.palette.primary,
        foregroundColor: context.palette.onPrimary,
        elevation: 4,
        icon: const Icon(Icons.edit_note_rounded),
        label: Text(
          'New Entry',
          style: AppTypography.labelLarge(context).copyWith(
            color: context.palette.onPrimary,
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Entry'),
            content: const Text(
              'This entry will be permanently removed. Are you sure?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: context.palette.error,
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.palette.primaryFixed.withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.book_outlined,
                size: 36,
                color: context.palette.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Your journal is empty',
              style: AppTypography.titleMedium(context).copyWith(
                color: context.palette.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Begin your first reflection.\nTap "New Entry" to start writing.',
              style: AppTypography.bodySmall(context).copyWith(
                color: context.palette.outline,
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
    required this.onTap,
    required this.onDelete,
  });

  final JournalEntry entry;
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
          color: context.palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: context.palette.outlineVariant.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: context.palette.onSurface.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date + delete
            Row(
              children: [
                Text(
                  _formatDate(entry.entryDate),
                  style: AppTypography.labelSmall(context).copyWith(
                    color: context.palette.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: context.palette.outline.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Preview
            Text(
              entry.preview,
              style: AppTypography.bodyMedium(context).copyWith(
                color: context.palette.onSurface,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),

            // Mood chips
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: entry.moods
                  .map((mood) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.palette.primaryFixed.withValues(alpha: 0.35),
                          borderRadius: AppSpacing.borderRadiusFull,
                        ),
                        child: Text(
                          '${mood.emoji} ${mood.label}',
                          style: AppTypography.labelSmall(context).copyWith(
                            color: context.palette.primary,
                            fontSize: 10,
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
