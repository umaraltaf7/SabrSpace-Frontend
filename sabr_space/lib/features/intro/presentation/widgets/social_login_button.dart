import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// "Continue with Google" button matching the themed design.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              const Color(0xFF46275E).withOpacity(0.78),
              const Color(0xFF341C49).withOpacity(0.66),
            ]
          : [
              const Color(0xFFE0C9F0).withOpacity(0.52),
              const Color(0xFFFFFFFF).withOpacity(0.68),
            ],
    );
    final borderColor = isDark
        ? const Color(0xFFCC98E7).withOpacity(0.28)
        : const Color(0xFFBC95D8).withOpacity(0.46);
    final textColor = isDark
        ? const Color(0xFFF4EAFB)
        : const Color(0xFF3D274E);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? const Color(0xFF0C0515).withOpacity(0.30)
                  : const Color(0xFF6F39AF).withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppSpacing.borderRadiusFull,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppSpacing.borderRadiusFull,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'G',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Continue with Google',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
