import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: AppTypography.titleSmall(context).copyWith(
              color: context.palette.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.body,
            style: AppTypography.bodyMedium(context).copyWith(
              color: context.palette.onSurfaceVariant,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: AppTypography.bodySmall(context).copyWith(
              color: context.palette.outline,
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
                colors: [
                  context.palette.primary.withValues(alpha: 0.3),
                  context.palette.primary,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
