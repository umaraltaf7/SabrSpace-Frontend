import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// Login / Sign Up segmented toggle with themed palette.
class AuthTabToggle extends StatelessWidget {
  const AuthTabToggle({
    super.key,
    required this.isLoginSelected,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  final bool isLoginSelected;
  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF46275E).withOpacity(0.60),
                  const Color(0xFF341C49).withOpacity(0.50),
                ]
              : [
                  const Color(0xFFE0C9F0).withOpacity(0.50),
                  const Color(0xFFFFFFFF).withOpacity(0.60),
                ],
        ),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(
          color: isDark
              ? const Color(0xFFCC98E7).withOpacity(0.20)
              : const Color(0xFFBC95D8).withOpacity(0.38),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
              child: _tab(context, 'Login', isLoginSelected, onLoginTap,
                  isDark)),
          Expanded(
              child: _tab(context, 'Sign Up', !isLoginSelected,
                  onSignUpTap, isDark)),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: isDark
                      ? const [Color(0xFFA265C9), Color(0xFF4F286F)]
                      : const [Color(0xFFB786D6), Color(0xFF69329B)],
                )
              : null,
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFFBC80DE).withOpacity(0.28)
                        : const Color(0xFF6E35A3).withOpacity(0.22),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: isActive
                ? Colors.white
                : (isDark
                    ? const Color(0xFFE8D4F4).withOpacity(0.60)
                    : const Color(0xFF7C57A0).withOpacity(0.65)),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
