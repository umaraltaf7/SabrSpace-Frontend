import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/intro/presentation/widgets/auth_text_field.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/social_login_button.dart';

/// Login screen with email/password form, Google login, and link to sign up.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _LP.darkBgBottom : _LP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_LP.darkBgTop, _LP.darkBgBottom]
                : const [_LP.lightBgTop, _LP.lightBgBottom],
          ),
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
                    color: isDark
                        ? _LP.darkTextPrimary
                        : _LP.lightAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.jumbo),

                // ── Card container ──
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              _LP.darkSurfaceElevated.withOpacity(0.82),
                              _LP.darkSurface.withOpacity(0.68),
                            ]
                          : [
                              _LP.lightSurfaceSoft.withOpacity(0.56),
                              _LP.lightSurface.withOpacity(0.78),
                            ],
                    ),
                    borderRadius: AppSpacing.borderRadiusXxl,
                    border: Border.all(
                      color: isDark
                          ? _LP.darkBorder.withOpacity(0.22)
                          : _LP.lightBorder.withOpacity(0.42),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _LP.darkShadow.withOpacity(0.46)
                            : _LP.lightShadow.withOpacity(0.14),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Tab toggle (Login active) ──
                      _buildTabToggle(context, isLogin: true, isDark: isDark),
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
                            style: AppTypography.bodySmall(context)
                                .copyWith(
                              color: isDark
                                  ? _LP.darkAccent
                                  : _LP.lightAccent,
                              decoration: TextDecoration.underline,
                              decorationColor: isDark
                                  ? _LP.darkAccent
                                  : _LP.lightAccent,
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
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    isDark
                                        ? _LP.darkBorder.withOpacity(0.30)
                                        : _LP.lightBorder.withOpacity(0.40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg),
                            child: Text(
                              AppStrings.or,
                              style: AppTypography.labelSmall(context)
                                  .copyWith(
                                color: isDark
                                    ? _LP.darkTextSecondary
                                        .withOpacity(0.55)
                                    : _LP.lightTextSecondary
                                        .withOpacity(0.60),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    isDark
                                        ? _LP.darkBorder.withOpacity(0.30)
                                        : _LP.lightBorder.withOpacity(0.40),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
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
                      style: AppTypography.bodySmall(context).copyWith(
                        color: isDark
                            ? _LP.darkTextSecondary
                            : _LP.lightTextSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        AppStrings.signUp,
                        style: AppTypography.labelMedium(context)
                            .copyWith(
                          color: isDark
                              ? _LP.darkAccent
                              : _LP.lightAccent,
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

  Widget _buildTabToggle(BuildContext context,
      {required bool isLogin, required bool isDark}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  _LP.darkSurface.withOpacity(0.60),
                  _LP.darkSurfaceElevated.withOpacity(0.40),
                ]
              : [
                  _LP.lightSurfaceSoft.withOpacity(0.46),
                  _LP.lightSurface.withOpacity(0.54),
                ],
        ),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(
          color: isDark
              ? _LP.darkBorder.withOpacity(0.18)
              : _LP.lightBorder.withOpacity(0.32),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _tab(context, 'Login', isLogin, () {}, isDark),
          ),
          Expanded(
            child: _tab(context, 'Sign Up', !isLogin,
                () => context.go('/signup'), isDark),
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
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(
                  colors: isDark
                      ? const [_LP.darkOrbTop, _LP.darkOrbBottom]
                      : const [_LP.lightOrbTop, _LP.lightOrbBottom],
                )
              : null,
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: isDark
                        ? _LP.darkAccent.withOpacity(0.28)
                        : _LP.lightAccent.withOpacity(0.22),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: active
                ? Colors.white
                : (isDark
                    ? _LP.darkTextSecondary.withOpacity(0.58)
                    : _LP.lightTextSecondary.withOpacity(0.62)),
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _LP {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);
  static const Color lightShadow = Color(0xFF6F39AF);

  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);
  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkBorder = Color(0xFFCC98E7);
  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);
  static const Color darkShadow = Color(0xFF0C0515);
}
