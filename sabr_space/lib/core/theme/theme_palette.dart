import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/sabr_space_theme_extension.dart';

/// Semantic colors for Sabr Space UI — use [BuildContext.palette] instead of static [AppColors].
class SabrPalette {
  SabrPalette(this._scheme, this._ext);

  final ColorScheme _scheme;
  final SabrSpaceThemeExtension _ext;

  Color get primary => _scheme.primary;
  Color get onPrimary => _scheme.onPrimary;
  Color get primaryContainer => _scheme.primaryContainer;
  Color get onPrimaryContainer => _scheme.onPrimaryContainer;
  Color get primaryFixed => _ext.primaryFixed;
  Color get primaryFixedDim => _ext.primaryFixedDim;
  Color get onPrimaryFixed => _ext.onPrimaryFixed;
  Color get onPrimaryFixedVariant => _ext.onPrimaryFixedVariant;
  Color get inversePrimary => _scheme.inversePrimary;

  Color get secondary => _scheme.secondary;
  Color get onSecondary => _scheme.onSecondary;
  Color get secondaryContainer => _scheme.secondaryContainer;
  Color get onSecondaryContainer => _scheme.onSecondaryContainer;
  Color get secondaryFixed => _ext.secondaryFixed;
  Color get secondaryFixedDim => _ext.secondaryFixedDim;
  Color get onSecondaryFixed => _scheme.onSecondaryFixed;
  Color get onSecondaryFixedVariant => _scheme.onSecondaryFixedVariant;

  Color get tertiary => _scheme.tertiary;
  Color get onTertiary => _scheme.onTertiary;
  Color get tertiaryContainer => _scheme.tertiaryContainer;
  Color get tertiaryFixed => _ext.tertiaryFixed;
  Color get onTertiaryFixed => _scheme.onTertiaryFixed;
  Color get onTertiaryFixedVariant => _scheme.onTertiaryFixedVariant;

  Color get error => _scheme.error;
  Color get onError => _scheme.onError;
  Color get errorContainer => _scheme.errorContainer;
  Color get onErrorContainer => _scheme.onErrorContainer;

  Color get surface => _scheme.surface;
  Color get onSurface => _scheme.onSurface;
  Color get surfaceContainerLowest => _scheme.surfaceContainerLowest;
  Color get surfaceContainerLow => _scheme.surfaceContainerLow;
  Color get surfaceContainer => _scheme.surfaceContainer;
  Color get surfaceContainerHigh => _scheme.surfaceContainerHigh;
  Color get surfaceContainerHighest => _scheme.surfaceContainerHighest;
  Color get surfaceVariant => _scheme.surfaceContainerHighest;
  Color get surfaceBright => _scheme.surface;
  Color get surfaceDim => _scheme.surfaceContainerHighest;
  Color get surfaceTint => _scheme.surfaceTint;
  Color get onSurfaceVariant => _scheme.onSurfaceVariant;
  Color get onBackground => _scheme.onSurface;
  Color get background => _scheme.surface;

  Color get outline => _scheme.outline;
  Color get outlineVariant => _scheme.outlineVariant;

  Color get inverseSurface => _scheme.inverseSurface;
  Color get inverseOnSurface => _scheme.onInverseSurface;

  Color get breatheAccent => _ext.breatheAccent;
  Color get gold => _ext.gold;
  /// Paper / envelope tone (maps to tertiary fixed cream).
  Color get cream => _ext.tertiaryFixed;

  Color get etherealGradientStart => _ext.etherealGradientStart;
  Color get etherealGradientEnd => _ext.etherealGradientEnd;
}

extension SabrPaletteContext on BuildContext {
  SabrPalette get palette {
    final t = Theme.of(this);
    final ext = t.extension<SabrSpaceThemeExtension>();
    assert(ext != null, 'SabrSpaceThemeExtension missing — attach in AppTheme');
    return SabrPalette(t.colorScheme, ext!);
  }

  /// Shorthand for [Theme.of(this).textTheme].
  TextTheme get text => Theme.of(this).textTheme;

  /// Quranic Arabic line style (theme-aware).
  TextStyle get arabicVerse =>
      AppTypography.arabicVerseStyle(Theme.of(this).colorScheme);
}
