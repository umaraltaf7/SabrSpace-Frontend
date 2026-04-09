import 'package:flutter/material.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';


/// Styled text field matching the Stitch login/signup design:
/// bottom-border only, uppercase label, gold focus highlight.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
  });

  final String label;
  final String? hint;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall(context).copyWith(
            letterSpacing: 1.5,
            color: context.palette.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyLarge(context),
          cursorColor: context.palette.secondaryFixedDim,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: context.palette.outline)
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }
}

