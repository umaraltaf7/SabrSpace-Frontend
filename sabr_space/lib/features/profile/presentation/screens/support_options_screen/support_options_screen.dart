import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Support Options screen — help, FAQ, and contact links.
class SupportOptionsScreen extends StatelessWidget {
  const SupportOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ── Top bar ──
                Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      AppStrings.supportOptions,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: context.palette.primary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Icon ──
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.palette.primaryFixed.withValues(alpha: 0.3),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    size: 36,
                    color: context.palette.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                Text(
                  'How can we help?',
                  style: AppTypography.headlineSmall(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'We\'re here to support your journey.',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: context.palette.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Support options ──
                _supportItem(
                  context,
                  icon: Icons.email_outlined,
                  label: 'Email Support',
                  subtitle: 'Get help via email within 24 hours.',
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.md),
                _supportItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: 'Live Chat',
                  subtitle: 'Chat with our support team.',
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.md),
                _supportItem(
                  context,
                  icon: Icons.help_outline,
                  label: 'FAQ',
                  subtitle: 'Find answers to common questions.',
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.md),
                _supportItem(
                  context,
                  icon: Icons.feedback_outlined,
                  label: 'Send Feedback',
                  subtitle: 'Help us improve the experience.',
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Inspirational footer ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Text(
                    '"And whoever puts their trust in Allah, He will be enough for them."',
                    style: AppTypography.bodySmall(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.palette.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _supportItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: context.palette.surfaceContainerLowest,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.palette.primaryFixed.withValues(alpha: 0.3),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(icon, color: context.palette.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.titleSmall(context)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall(context).copyWith(
                      color: context.palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: context.palette.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}
