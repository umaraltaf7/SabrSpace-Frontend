import 'package:flutter/material.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// Styled text field matching the auth design:
/// bottom-border only, uppercase label, purple focus highlight.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? const Color(0xFFE8D4F4)
        : const Color(0xFF7C57A0);
    final iconColor = isDark
        ? const Color(0xFFBC80DE).withOpacity(0.60)
        : const Color(0xFF7C57A0).withOpacity(0.55);
    final cursorColor = isDark
        ? const Color(0xFFBC80DE)
        : const Color(0xFF6E35A3);
    final borderColor = isDark
        ? const Color(0xFFCC98E7).withOpacity(0.28)
        : const Color(0xFFBC95D8).withOpacity(0.46);
    final focusBorderColor = isDark
        ? const Color(0xFFBC80DE)
        : const Color(0xFF6E35A3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall(context).copyWith(
            letterSpacing: 1.5,
            color: labelColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyLarge(context).copyWith(
            color: isDark
                ? const Color(0xFFF4EAFB)
                : const Color(0xFF3D274E),
          ),
          cursorColor: cursorColor,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyLarge(context).copyWith(
              color: labelColor.withOpacity(0.50),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: iconColor)
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 0,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: focusBorderColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
