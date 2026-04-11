import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// Primary CTA button with the purple-pinkish gradient.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.height = 56,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFFBC80DE), Color(0xFFE0B2F0)]
                : const [Color(0xFF6E35A3), Color(0xFFB786D6)],
          ),
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? const Color(0xFFBC80DE).withOpacity(0.36)
                  : const Color(0xFF6E35A3).withOpacity(0.30),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: isDark
                  ? const Color(0xFFE0B2F0).withOpacity(0.18)
                  : const Color(0xFFCCA8E2).withOpacity(0.22),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusFull,
            ),
          ),
          child: Text(
            text,
            style: AppTypography.labelLarge(context).copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
