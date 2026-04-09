import 'package:flutter/material.dart';

import 'package:sabr_space/core/theme/theme_palette.dart';

/// Brand logo image (circular mark) for Sabr Space.
///
/// Used anywhere the intro moon icon appeared; now the provided asset.
class SanctuaryLogo extends StatelessWidget {
  const SanctuaryLogo({
    super.key,
    this.size = 80,
    this.showDropShadow = true,
  });

  final double size;
  final bool showDropShadow;

  static const String _assetPath = 'assets/images/app_logo.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showDropShadow
            ? [
                BoxShadow(
                  color: context.palette.primaryFixedDim.withValues(alpha: 0.35),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        _assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: context.palette.surface,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: size * 0.35,
                color: context.palette.outline,
              ),
            ),
          );
        },
      ),
    );
  }
}
