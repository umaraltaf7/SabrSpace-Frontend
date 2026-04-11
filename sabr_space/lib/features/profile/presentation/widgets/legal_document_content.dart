import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';

/// One block in a privacy / terms document.
class LegalSectionData {
  const LegalSectionData({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

/// Heading + body paragraph for legal screens.
class LegalSection extends StatelessWidget {
  const LegalSection({
    super.key,
    required this.data,
  });

  final LegalSectionData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: AppTypography.titleSmall(context).copyWith(
              color: isDark
                  ? const Color(0xFFBC80DE)
                  : const Color(0xFF6E35A3),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.body,
            style: AppTypography.bodyMedium(context).copyWith(
              color: isDark
                  ? const Color(0xFFE8D4F4)
                  : const Color(0xFF7C57A0),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

/// Intro line under the title (e.g. last updated).
class LegalDocumentMeta extends StatelessWidget {
  const LegalDocumentMeta({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: AppTypography.bodySmall(context).copyWith(
              color: isDark
                  ? const Color(0xFFE8D4F4).withOpacity(0.60)
                  : const Color(0xFF7C57A0).withOpacity(0.60),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            height: 3,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFFBC80DE).withOpacity(0.3),
                        const Color(0xFFBC80DE),
                      ]
                    : [
                        const Color(0xFF6E35A3).withOpacity(0.3),
                        const Color(0xFF6E35A3),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
