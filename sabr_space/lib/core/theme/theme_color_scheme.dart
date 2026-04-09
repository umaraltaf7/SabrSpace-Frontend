import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/sabr_space_theme_extension.dart';

/// Material 3 color schemes — light (lavender spiritual) & dark (midnight + gold).
abstract final class SabrColorSchemes {
  static ColorScheme get light {
    const primary = Color(0xFF625195);
    const onPrimary = Color(0xFFFFFFFF);
    const primaryContainer = Color(0xFF7B6AAF);
    const secondary = Color(0xFF735C00);
    const onSecondary = Color(0xFFFFFFFF);
    const secondaryContainer = Color(0xFFFED65B);
    const tertiary = Color(0xFF615C47);
    const error = Color(0xFFBA1A1A);
    const surface = Color(0xFFFAF9FC);
    const onSurface = Color(0xFF1B1B1E);
    const onSurfaceVariant = Color(0xFF494550);
    const outline = Color(0xFF7A7581);
    const outlineVariant = Color(0xFFCAC4D1);

    return const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF200B50),
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF745C00),
      tertiary: tertiary,
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF7B745E),
      onTertiaryContainer: Color(0xFFFFFBFF),
      error: error,
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: Color(0xFFE3E2E6),
      surfaceContainerHigh: Color(0xFFE9E7EB),
      surfaceContainer: Color(0xFFEFEDF1),
      surfaceContainerLow: Color(0xFFF5F3F7),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF303033),
      onInverseSurface: Color(0xFFF2F0F4),
      inversePrimary: Color(0xFFCEBDFF),
      surfaceTint: Color(0xFF655497),
    );
  }

  /// Deep navy surfaces, gold primary accent — not a simple inversion of light.
  static ColorScheme get dark {
    const gold = Color(0xFFE5C46A);
    const onGold = Color(0xFF1A1520);

    return ColorScheme(
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: onGold,
      primaryContainer: const Color(0xFF4A3F2A),
      onPrimaryContainer: const Color(0xFFFFE8A8),
      secondary: const Color(0xFFB8A5D6),
      onSecondary: const Color(0xFF1F1A24),
      secondaryContainer: const Color(0xFF4A3F5C),
      onSecondaryContainer: const Color(0xFFE8DDFF),
      tertiary: const Color(0xFF9A8FB0),
      onTertiary: const Color(0xFF1F1A24),
      tertiaryContainer: const Color(0xFF3D3548),
      onTertiaryContainer: const Color(0xFFE8E0F0),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: const Color(0xFF12121A),
      onSurface: const Color(0xFFE8E8ED),
      surfaceContainerHighest: const Color(0xFF353548),
      surfaceContainerHigh: const Color(0xFF2A2A3A),
      surfaceContainer: const Color(0xFF222230),
      surfaceContainerLow: const Color(0xFF1A1A26),
      surfaceContainerLowest: const Color(0xFF16161F),
      onSurfaceVariant: const Color(0xFFB0B0C0),
      outline: const Color(0xFF6F6F80),
      outlineVariant: const Color(0xFF454558),
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: const Color(0xFFE8E8ED),
      onInverseSurface: const Color(0xFF1B1B1E),
      inversePrimary: const Color(0xFF625195),
      surfaceTint: gold,
    );
  }

  static SabrSpaceThemeExtension sabrExtension(Brightness brightness) =>
      brightness == Brightness.dark
          ? SabrSpaceThemeExtension.dark
          : SabrSpaceThemeExtension.light;
}
