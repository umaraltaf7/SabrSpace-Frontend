import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sabr_space/core/theme/sabr_space_theme_extension.dart';

/// Typography — Noto Serif (spiritual headlines) + Plus Jakarta Sans (UI).
///
/// Built from [ColorScheme] so light/dark stay accessible.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(ColorScheme cs, SabrSpaceThemeExtension ext) {
    final onSurf = cs.onSurface;
    final onVar = cs.onSurfaceVariant;

    return TextTheme(
      displayLarge: GoogleFonts.notoSerif(
        fontSize: 56,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: onSurf,
      ),
      displayMedium: GoogleFonts.notoSerif(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: onSurf,
      ),
      displaySmall: GoogleFonts.notoSerif(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: onSurf,
      ),
      headlineLarge: GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02 * 32,
        color: onSurf,
      ),
      headlineMedium: GoogleFonts.notoSerif(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: onSurf,
      ),
      headlineSmall: GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: onSurf,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onSurf,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: onSurf,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurf,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.6,
        color: onSurf,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
        color: onSurf,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: onVar,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurf,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5 * 0.12,
        color: onSurf,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: onVar,
      ),
    );
  }

  /// Arabic Quranic text style (uses theme [ColorScheme.onSurface]).
  static TextStyle arabicVerseStyle(ColorScheme cs) => GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 2.0,
        color: cs.onSurface,
      );

  // ── Theme-aware styles (prefer from widgets with [BuildContext]) ──
  static TextStyle displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!;
  static TextStyle displayMedium(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!;
  static TextStyle displaySmall(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!;
  static TextStyle headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!;
  static TextStyle headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!;
  static TextStyle headlineSmall(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!;
  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!;
  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;
  static TextStyle titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!;
  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;
  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle bodySmall(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;
  static TextStyle labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!;
  static TextStyle labelMedium(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!;
  static TextStyle labelSmall(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!;
  static TextStyle arabicVerse(BuildContext context) =>
      arabicVerseStyle(Theme.of(context).colorScheme);
}
