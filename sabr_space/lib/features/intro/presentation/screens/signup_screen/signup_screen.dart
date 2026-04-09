import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/intro/presentation/widgets/auth_text_field.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';


/// Sign Up screen with registration form.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.huge),

                // ── Branding header ──
                Text(
                  AppStrings.appName,
                  style: AppTypography.headlineMedium(context).copyWith(
                    color: context.palette.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.jumbo),

                // ── White card container ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: context.palette.surfaceContainerLowest,
                    borderRadius: AppSpacing.borderRadiusXxl,
                    boxShadow: [
                      BoxShadow(
                        color: context.palette.onSurface.withValues(alpha: 0.06),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Tab toggle (Sign Up active) ──
                      _buildTabToggle(context, isLogin: false),
                      const SizedBox(height: AppSpacing.xxl),

                      // ── Heading ──
                      Text(
                        AppStrings.beginJourney,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: context.palette.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppStrings.joinSanctuary,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: context.palette.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      // ── Form fields ──
                      const AuthTextField(
                        label: AppStrings.fullName,
                        hint: 'Your name',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const AuthTextField(
                        label: AppStrings.email,
                        hint: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const AuthTextField(
                        label: AppStrings.password,
                        hint: '••••••••',
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const AuthTextField(
                        label: AppStrings.confirmPassword,
                        hint: '••••••••',
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      // ── Create Account button ──
                      GradientButton(
                        text: AppStrings.createAccount,
                        onPressed: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Footer link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: AppTypography.bodySmall(context),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        AppStrings.login,
                        style: AppTypography.labelMedium(context).copyWith(
                          color: context.palette.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle(BuildContext context, {required bool isLogin}) {
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
            child: _tab(context, 'Login', isLogin, () => context.go('/login')),
          ),
          Expanded(
            child: _tab(context, 'Sign Up', !isLogin, () {}),
          ),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
          active ? context.palette.surfaceContainerLowest : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: active
              ? [
            BoxShadow(
              color: context.palette.onSurface.withValues(alpha: 0.06),
              blurRadius: 8,
            )
          ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: active ? context.palette.primary : context.palette.outline,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

