import 'package:flutter/material.dart';

/// Brand & semantic colors beyond [ColorScheme] (breathe accent, gold, fixed tones).
@immutable
class SabrSpaceThemeExtension extends ThemeExtension<SabrSpaceThemeExtension> {
  const SabrSpaceThemeExtension({
    required this.primaryFixed,
    required this.breatheAccent,
    required this.gold,
    required this.primaryFixedDim,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.tertiaryFixed,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.etherealGradientStart,
    required this.etherealGradientEnd,
  });

  final Color primaryFixed;
  final Color breatheAccent;
  final Color gold;
  final Color primaryFixedDim;
  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color tertiaryFixed;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;
  final Color etherealGradientStart;
  final Color etherealGradientEnd;

  static const SabrSpaceThemeExtension light = SabrSpaceThemeExtension(
    primaryFixed: Color(0xFFE8DDFF),
    breatheAccent: Color(0xFF7567A9),
    gold: Color(0xFFD4AF37),
    primaryFixedDim: Color(0xFFCEBDFF),
    secondaryFixed: Color(0xFFFFE088),
    secondaryFixedDim: Color(0xFFE9C349),
    tertiaryFixed: Color(0xFFEBE2C8),
    onPrimaryFixed: Color(0xFF200B50),
    onPrimaryFixedVariant: Color(0xFF4C3C7E),
    etherealGradientStart: Color(0xFFF8F6FF),
    etherealGradientEnd: Color(0xFFF0EDFA),
  );

  static const SabrSpaceThemeExtension dark = SabrSpaceThemeExtension(
    primaryFixed: Color(0xFF3D2F5C),
    breatheAccent: Color(0xFFB8A5D6),
    gold: Color(0xFFE5C46A),
    primaryFixedDim: Color(0xFF4A3F6A),
    secondaryFixed: Color(0xFF5C4A2A),
    secondaryFixedDim: Color(0xFFC4A03A),
    tertiaryFixed: Color(0xFF4A4458),
    onPrimaryFixed: Color(0xFFE8E0FF),
    onPrimaryFixedVariant: Color(0xFFC9B8E8),
    etherealGradientStart: Color(0xFF16161F),
    etherealGradientEnd: Color(0xFF1A1A28),
  );

  @override
  SabrSpaceThemeExtension copyWith({
    Color? primaryFixed,
    Color? breatheAccent,
    Color? gold,
    Color? primaryFixedDim,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? tertiaryFixed,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? etherealGradientStart,
    Color? etherealGradientEnd,
  }) {
    return SabrSpaceThemeExtension(
      primaryFixed: primaryFixed ?? this.primaryFixed,
      breatheAccent: breatheAccent ?? this.breatheAccent,
      gold: gold ?? this.gold,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      secondaryFixed: secondaryFixed ?? this.secondaryFixed,
      secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant: onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      etherealGradientStart: etherealGradientStart ?? this.etherealGradientStart,
      etherealGradientEnd: etherealGradientEnd ?? this.etherealGradientEnd,
    );
  }

  @override
  SabrSpaceThemeExtension lerp(
    ThemeExtension<SabrSpaceThemeExtension>? other,
    double t,
  ) {
    if (other is! SabrSpaceThemeExtension) return this;
    return SabrSpaceThemeExtension(
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      breatheAccent: Color.lerp(breatheAccent, other.breatheAccent, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      primaryFixedDim: Color.lerp(primaryFixedDim, other.primaryFixedDim, t)!,
      secondaryFixed: Color.lerp(secondaryFixed, other.secondaryFixed, t)!,
      secondaryFixedDim:
          Color.lerp(secondaryFixedDim, other.secondaryFixedDim, t)!,
      tertiaryFixed: Color.lerp(tertiaryFixed, other.tertiaryFixed, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      onPrimaryFixedVariant:
          Color.lerp(onPrimaryFixedVariant, other.onPrimaryFixedVariant, t)!,
      etherealGradientStart:
          Color.lerp(etherealGradientStart, other.etherealGradientStart, t)!,
      etherealGradientEnd:
          Color.lerp(etherealGradientEnd, other.etherealGradientEnd, t)!,
    );
  }
}
