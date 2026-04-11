import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/sabr_space_theme_extension.dart';

/// Theme-aware gradients — call with [BuildContext] so light/dark match the palette.
class AppGradients {
  AppGradients._();

  static LinearGradient primaryGradient(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [cs.primary, cs.primaryContainer],
    );
  }

  static LinearGradient primaryGradientReversed(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [cs.primary, cs.primaryContainer],
    );
  }

  /// Gold accent — subtle shift; works on both themes.
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9B4DC8), Color(0xFF6E35A3)],
  );

  static LinearGradient backgroundGradient(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<SabrSpaceThemeExtension>()!;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ext.etherealGradientStart,
        cs.surface,
      ],
    );
  }

  /// Screen background wash (ethereal).
  static LinearGradient etherealBackground(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<SabrSpaceThemeExtension>()!;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ext.etherealGradientStart,
        cs.surface,
        ext.etherealGradientEnd,
      ],
      stops: const [0.0, 0.55, 1.0],
    );
  }

  static LinearGradient cardHighlight(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        cs.primary.withValues(alpha: 0.04),
        cs.primaryContainer.withValues(alpha: 0.12),
      ],
    );
  }
}
