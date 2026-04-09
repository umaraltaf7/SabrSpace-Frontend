import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/intro/presentation/widgets/auth_text_field.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/social_login_button.dart';


/// Login screen with email/password form, Google login, and link to sign up.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      // ── Tab toggle (Login active) ──
                      _buildTabToggle(context, isLogin: true),
                      const SizedBox(height: AppSpacing.xxxl),

                      // ── Form fields ──
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
                      const SizedBox(height: AppSpacing.md),

                      // ── Forgot password ──
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.forgotPassword,
                            style: AppTypography.bodySmall(context).copyWith(
                              color: context.palette.secondary,
                              decoration: TextDecoration.underline,
                              decorationColor: context.palette.secondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Login button ──
                      GradientButton(
                        text: AppStrings.login,
                        onPressed: () => context.go('/home'),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // ── OR divider ──
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: context.palette.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg),
                            child: Text(
                              AppStrings.or,
                              style: AppTypography.labelSmall(context),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: context.palette.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // ── Google login ──
                      SocialLoginButton(onPressed: () {}),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Footer link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: AppTypography.bodySmall(context),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        AppStrings.signUp,
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
            child: _tab(context, 'Login', isLogin, () {}),
          ),
          Expanded(
            child: _tab(context, 'Sign Up', !isLogin, () => context.go('/signup')),
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

