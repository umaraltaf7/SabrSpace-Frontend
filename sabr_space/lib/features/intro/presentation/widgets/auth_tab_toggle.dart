import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_typography.dart';


/// Login / Sign Up segmented toggle matching the Stitch tab design.
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
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.palette.surfaceContainerHigh,
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
              child: _tab(context, 'Login', isLoginSelected, onLoginTap)),
          Expanded(
              child: _tab(context, 'Sign Up', !isLoginSelected, onSignUpTap)),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? context.palette.surfaceContainerLowest : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: isActive
              ? [
            BoxShadow(
              color: context.palette.onSurface.withValues(alpha: 0.06),
              blurRadius: 8,
            ),
          ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: isActive ? context.palette.primary : context.palette.outline,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

