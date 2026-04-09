import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
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
    final entries = ref.watch(journalEntriesProvider);
    final entry = entries.where((e) => e.id == entryId).firstOrNull;

    if (entry == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Entry not found', style: AppTypography.titleMedium(context)),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => context.go('/journal'),
                child: const Text('Return to Journal'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Top bar ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      'Entry',
                      style: AppTypography.titleMedium(context).copyWith(
                        color: context.palette.primary,
                      ),
                    ),
                    const Spacer(),
                    // Delete button
                    IconButton(
                      onPressed: () async {
                        final confirmed = await _confirmDelete(context);
                        if (confirmed && context.mounted) {
                          ref
                              .read(journalEntriesProvider.notifier)
                              .deleteEntry(entryId);
                          context.go('/journal');
                        }
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 22,
                        color: context.palette.error.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date + time
                      Text(
                        _formatFullDate(entry.entryDate),
                        style: AppTypography.labelSmall(context).copyWith(
                          color: context.palette.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
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
                                    color: context.palette.primaryFixed
                                        .withValues(alpha: 0.4),
                                    borderRadius: AppSpacing.borderRadiusFull,
                                  ),
                                  child: Text(
                                    '${mood.emoji} ${mood.label}',
                                    style: AppTypography.labelMedium(context).copyWith(
                                      color: context.palette.primary,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      // Prompt (if present)
                      if (entry.prompt != null && entry.prompt!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0x0A625195),
                                Color(0x14E9C349),
                              ],
                            ),
                            borderRadius: AppSpacing.borderRadiusMd,
                            border: Border.all(
                              color: context.palette.primaryFixed
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: context.palette.secondary
                                        .withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'PROMPT',
                                    style: AppTypography.labelSmall(context).copyWith(
                                      color: context.palette.secondary,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                entry.prompt!,
                                style: AppTypography.bodyMedium(context).copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: context.palette.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],

                      // Full content
                      Text(
                        entry.content,
                        style: AppTypography.bodyLarge(context).copyWith(
                          height: 1.8,
                          color: context.palette.onSurface,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.huge),

                      // Created at timestamp
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Created ${_formatFullDate(entry.createdAt)}',
                          style: AppTypography.labelSmall(context).copyWith(
                            color: context.palette.outline.withValues(alpha: 0.5),
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
