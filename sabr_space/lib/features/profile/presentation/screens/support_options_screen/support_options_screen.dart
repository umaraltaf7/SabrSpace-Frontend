import 'package:flutter/material.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

/// Support Options screen — help, FAQ, and contact links.
class SupportOptionsScreen extends StatelessWidget {
  const SupportOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF32143E)
          : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar (stays pinned) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 0,
              ),
              child: Row(
                children: [
                  const ScreenBackButton(),
                  const Spacer(),
                  Text(
                    AppStrings.supportOptions,
                    style: AppTypography.titleMedium(context).copyWith(
                      color: isDark
                          ? const Color(0xFFF4EAFB)
                          : const Color(0xFF3D274E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Content (vertically centered, scrollable if needed) ──
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                      vertical: AppSpacing.lg,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - AppSpacing.lg * 2,
                          maxWidth: 500,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildOptionCard(
                              context,
                              isDark: isDark,
                              icon: Icons.email_outlined,
                              title: 'Email Support',
                              subtitle: 'Get help via email within 24 hours.',
                              onTap: () {},
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildOptionCard(
                              context,
                              isDark: isDark,
                              icon: Icons.chat_bubble_outline_rounded,
                              title: 'Live Chat',
                              subtitle: 'Chat with our support team.',
                              onTap: () {},
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildOptionCard(
                              context,
                              isDark: isDark,
                              icon: Icons.help_outline_rounded,
                              title: 'FAQ',
                              subtitle: 'Find answers to common questions.',
                              onTap: () {},
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildOptionCard(
                              context,
                              isDark: isDark,
                              icon: Icons.feedback_outlined,
                              title: 'Send Feedback',
                              subtitle: 'Help us improve the experience.',
                              onTap: () {},
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              '"And whoever puts their trust in Allah,\nHe will be enough for them."',
                              style: AppTypography.bodySmall(context).copyWith(
                                fontStyle: FontStyle.italic,
                                color: isDark
                                    ? const Color(0xFFE8D4F4)
                                    : const Color(0xFF7C57A0),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF341C49)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? const Color(0xFFCC98E7).withOpacity(0.15)
                : const Color(0xFFBC95D8).withOpacity(0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : const Color(0xFF6E35A3).withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF46275E)
                    : const Color(0xFFE0C9F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark
                    ? const Color(0xFFE0B2F0)
                    : const Color(0xFF6E35A3),
                size: 23,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? const Color(0xFFF4EAFB)
                          : const Color(0xFF3D274E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFCBB5DD)
                          : const Color(0xFF7C57A0),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark
                  ? const Color(0xFFCBB5DD).withOpacity(0.6)
                  : const Color(0xFF6E35A3),
            ),
          ],
        ),
      ),
    );
  }
}
