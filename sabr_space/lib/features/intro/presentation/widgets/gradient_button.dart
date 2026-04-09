import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';


/// Primary CTA button with the signature soul gradient (primary → primaryContainer).
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
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGradient(context),
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: [
            BoxShadow(
              color: context.palette.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: context.palette.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusFull,
            ),
          ),
          child: Text(
            text,
            style: AppTypography.labelLarge(context).copyWith(
              color: context.palette.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

