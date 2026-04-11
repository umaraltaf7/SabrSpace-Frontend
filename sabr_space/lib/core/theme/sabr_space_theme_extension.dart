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
    primaryFixed: Color(0xFFE0C9F0),
    breatheAccent: Color(0xFF7C57A0),
    gold: Color(0xFFD4AF37),
    primaryFixedDim: Color(0xFFCCA8E2),
    secondaryFixed: Color(0xFFF3ECF9),
    secondaryFixedDim: Color(0xFFBC95D8),
    tertiaryFixed: Color(0xFFEBE2C8),
    onPrimaryFixed: Color(0xFF3D274E),
    onPrimaryFixedVariant: Color(0xFF552688),
    etherealGradientStart: Color(0xFFFFFFFF),
    etherealGradientEnd: Color(0xFFF7EEFF),
  );

  static const SabrSpaceThemeExtension dark = SabrSpaceThemeExtension(
    primaryFixed: Color(0xFF46275E),
    breatheAccent: Color(0xFFBC80DE),
    gold: Color(0xFFD4AF37),
    primaryFixedDim: Color(0xFF5A2F79),
    secondaryFixed: Color(0xFF32143E),
    secondaryFixedDim: Color(0xFFBC80DE),
    tertiaryFixed: Color(0xFF4A4458),
    onPrimaryFixed: Color(0xFFF4EAFB),
    onPrimaryFixedVariant: Color(0xFFE0B2F0),
    etherealGradientStart: Color(0xFF1A0D28),
    etherealGradientEnd: Color(0xFF261538),
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
