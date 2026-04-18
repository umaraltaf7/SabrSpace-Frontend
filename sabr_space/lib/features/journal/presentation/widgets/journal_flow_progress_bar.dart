import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/theme_palette.dart';

/// Pill progress track for the journal entry flow (mood → write).
///
/// [currentStep] is 1-based. With two steps, step 1 shows half fill, step 2 full.
class JournalFlowProgressBar extends StatelessWidget {
  const JournalFlowProgressBar({
    super.key,
    required this.currentStep,
    this.stepCount = 2,
  }) : assert(currentStep >= 1),
       assert(stepCount >= 1);

  final int currentStep;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final t = (currentStep / stepCount).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 10,
            width: constraints.maxWidth,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: palette.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * t,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [
                          palette.breatheAccent,
                          palette.primary,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
