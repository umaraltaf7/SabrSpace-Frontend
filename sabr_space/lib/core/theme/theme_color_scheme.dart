import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/sabr_space_theme_extension.dart';

/// Material 3 color schemes — purple-pink palette for both light & dark.
abstract final class SabrColorSchemes {
  static ColorScheme get light {
    const primary = Color(0xFF6E35A3);
    const onPrimary = Color(0xFFFFFFFF);
    const primaryContainer = Color(0xFF9B4DC8);
    const secondary = Color(0xFF7C57A0);
    const onSecondary = Color(0xFFFFFFFF);
    const secondaryContainer = Color(0xFFE0C9F0);
    const tertiary = Color(0xFF615C47);
    const error = Color(0xFFBA1A1A);
    const surface = Color(0xFFFFFFFF);
    const onSurface = Color(0xFF3D274E);
    const onSurfaceVariant = Color(0xFF7C57A0);
    const outline = Color(0xFFBC95D8);
    const outlineVariant = Color(0xFFE0C9F0);

    return const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF200B3A),
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF3D274E),
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
      surfaceContainerHighest: Color(0xFFE0C9F0),
      surfaceContainerHigh: Color(0xFFEDE0F8),
      surfaceContainer: Color(0xFFF3ECF9),
      surfaceContainerLow: Color(0xFFF8F4FC),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF32143E),
      onInverseSurface: Color(0xFFF4EAFB),
      inversePrimary: Color(0xFFBC80DE),
      surfaceTint: Color(0xFF6E35A3),
    );
  }

  static ColorScheme get dark {
    const primary = Color(0xFFBC80DE);
    const onPrimary = Color(0xFF200D2E);

    return ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: const Color(0xFF5A2F79),
      onPrimaryContainer: const Color(0xFFF4EAFB),
      secondary: const Color(0xFFE0B2F0),
      onSecondary: const Color(0xFF1A0E24),
      secondaryContainer: const Color(0xFF46275E),
      onSecondaryContainer: const Color(0xFFE8D4F4),
      tertiary: const Color(0xFF9A8FB0),
      onTertiary: const Color(0xFF1F1A24),
      tertiaryContainer: const Color(0xFF3D3548),
      onTertiaryContainer: const Color(0xFFE8E0F0),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: const Color(0xFF1A0D28),
      onSurface: const Color(0xFFF4EAFB),
      surfaceContainerHighest: const Color(0xFF3E1E50),
      surfaceContainerHigh: const Color(0xFF32143E),
      surfaceContainer: const Color(0xFF261538),
      surfaceContainerLow: const Color(0xFF1E1030),
      surfaceContainerLowest: const Color(0xFF150A20),
      onSurfaceVariant: const Color(0xFFCBB5DD),
      outline: const Color(0xFF7A5A96),
      outlineVariant: const Color(0xFF46275E),
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: const Color(0xFFF4EAFB),
      onInverseSurface: const Color(0xFF3D274E),
      inversePrimary: const Color(0xFF6E35A3),
      surfaceTint: primary,
    );
  }

  static SabrSpaceThemeExtension sabrExtension(Brightness brightness) =>
      brightness == Brightness.dark
          ? SabrSpaceThemeExtension.dark
          : SabrSpaceThemeExtension.light;
}
