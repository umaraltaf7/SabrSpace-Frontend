import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/features/journal/data/journal_entry_flow.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/features/journal/presentation/widgets/journal_flow_progress_bar.dart';

/// Step 1 of the new-entry flow: pick how you feel (single mood), then write.
///
/// Layout mirrors a card-style mood picker; colors come from [SabrPalette].
class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  JournalMood? _selected;

  void _goNext() {
    final m = _selected;
    if (m == null) return;
    context.push('/journal/write?moods=${m.index}');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: palette.outlineVariant.withValues(alpha: 0.45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: palette.primary.withValues(
                            alpha: isDark ? 0.12 : 0.08,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _RoundHeaderIcon(
                                palette: palette,
                                onPressed: () => context.pop(),
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
                                    currentStep: JournalEntryFlow.moodStep,
                                    stepCount: JournalEntryFlow.totalSteps,
                                  ),
                                ),
                              ),
                              _RoundHeaderIcon(
                                palette: palette,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          palette.inverseSurface,
                                      content: Text(
                                        'Your feelings are valid. Take the time you need.',
                                        style: AppTypography.bodyMedium(
                                          context,
                                        ).copyWith(
                                          color: palette.inverseOnSurface,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 22,
                                  color: palette.gold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Text(
                            'How are you feeling?',
                            textAlign: TextAlign.center,
                            style: AppTypography.headlineSmall(context)
                                .copyWith(
                              color: palette.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: AppSpacing.xl,
                                crossAxisSpacing: AppSpacing.md,
                                childAspectRatio: 0.78,
                              ),
                              itemCount: JournalMood.values.length,
                              itemBuilder: (context, index) {
                                final mood = JournalMood.values[index];
                                final isOn = _selected == mood;
                                return _MoodOrbTile(
                                  mood: mood,
                                  selected: isOn,
                                  palette: palette,
                                  onTap: () => setState(() {
                                    _selected = isOn ? null : mood;
                                  }),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _NextPillButton(
                            enabled: _selected != null,
                            palette: palette,
                            onPressed: _goNext,
                          ),
                        ],
                      ),
                    ),
                  ),
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
      color: palette.surfaceContainerLow,
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

class _MoodOrbTile extends StatelessWidget {
  const _MoodOrbTile({
    required this.mood,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final JournalMood mood;
  final bool selected;
  final SabrPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: palette.primary.withValues(alpha: 0.12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? palette.primaryContainer.withValues(alpha: 0.45)
                  : palette.surfaceContainerLow,
              border: Border.all(
                color: selected
                    ? palette.primary
                    : palette.outlineVariant.withValues(alpha: 0.5),
                width: selected ? 2.5 : 1.2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: palette.primary.withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              mood.emoji,
              style: const TextStyle(fontSize: 34),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            mood.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall(context).copyWith(
              color: selected ? palette.primary : palette.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextPillButton extends StatelessWidget {
  const _NextPillButton({
    required this.enabled,
    required this.palette,
    required this.onPressed,
  });

  final bool enabled;
  final SabrPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: enabled
            ? palette.primary
            : palette.onSurface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Center(
            child: Icon(
              Icons.chevron_right_rounded,
              size: 30,
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
