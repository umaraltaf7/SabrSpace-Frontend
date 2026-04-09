import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
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
                        'Journal',
                        style: AppTypography.titleMedium(context).copyWith(
                          color: context.palette.primary,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.huge),

                  // ── Heading ──
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.palette.primaryFixed.withValues(alpha: 0.3),
                      ),
                      child: Icon(
                        Icons.self_improvement,
                        color: context.palette.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  Text(
                    'How are you feeling?',
                    style: AppTypography.headlineSmall(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Select the moods that resonate with you right now.',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: context.palette.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // ── Mood chips ──
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: JournalMood.values
                        .map((mood) => _MoodChip(
                              mood: mood,
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
                          gradient: AppGradients.primaryGradient(context),
                          borderRadius: AppSpacing.borderRadiusFull,
                          boxShadow: _selected.isNotEmpty
                              ? [
                                  BoxShadow(
                                    color: context.palette.primary
                                        .withValues(alpha: 0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton(
                          onPressed: _selected.isNotEmpty
                              ? () {
                                  // Pass selected moods as comma-separated string via query
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
                            foregroundColor: context.palette.onPrimary,
                            disabledBackgroundColor: Colors.transparent,
                            disabledForegroundColor:
                                context.palette.onPrimary.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusFull,
                            ),
                          ),
                          child: Text(
                            _selected.isNotEmpty
                                ? 'Continue'
                                : 'Select a mood to continue',
                            style: AppTypography.labelLarge(context).copyWith(
                              color: context.palette.onPrimary,
                              fontSize: 16,
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
    required this.isSelected,
    required this.onTap,
  });

  final JournalMood mood;
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
          color: isSelected
              ? context.palette.primaryFixed
              : context.palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: isSelected
                ? context.palette.primary
                : context.palette.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.palette.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: AppSpacing.sm),
            Text(
              mood.label,
              style: AppTypography.labelLarge(context).copyWith(
                color:
                    isSelected ? context.palette.primary : context.palette.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
