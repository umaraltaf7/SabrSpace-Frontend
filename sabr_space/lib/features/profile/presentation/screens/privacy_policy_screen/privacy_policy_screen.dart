import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/profile/presentation/widgets/legal_document_content.dart';

/// Privacy policy for Sabr Space — wellness & spiritual content.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static final List<LegalSectionData> _sections = [
    LegalSectionData(
      title: '1. Introduction',
      body:
          'Sabr Space ("we," "our," or "us") respects your privacy. This policy explains how we collect, use, and protect information when you use our mobile application. By using Sabr Space, you agree to this Privacy Policy.',
    ),
    LegalSectionData(
      title: '2. Information we collect',
      body:
          'We may collect information you provide directly, such as account details you choose to share, journal entries stored on your device, and preferences you set within the app. We may also collect limited technical data (such as device type and app version) to improve stability and security. We do not sell your personal information.',
    ),
    LegalSectionData(
      title: '3. How we use your information',
      body:
          'We use your information to provide and improve features such as guided breathing, journaling, audio content, and reminders. Journal content you create is intended to stay private on your device unless you explicitly choose to sync or share it in a future version of the app.',
    ),
    LegalSectionData(
      title: '4. Data storage and security',
      body:
          'We apply reasonable safeguards to protect your data. No method of transmission over the internet is completely secure; we encourage you to use a secure device and keep your account credentials confidential.',
    ),
    LegalSectionData(
      title: '5. Third-party services',
      body:
          'If we integrate analytics, crash reporting, or sign-in providers, those services are governed by their own privacy policies. We select providers that align with our commitment to user privacy.',
    ),
    LegalSectionData(
      title: '6. Children\'s privacy',
      body:
          'Sabr Space is not directed at children under 13 (or the minimum age required in your region). We do not knowingly collect personal information from children.',
    ),
    LegalSectionData(
      title: '7. Your choices',
      body:
          'You may update or delete certain data within the app where such controls are available. You may also contact us to ask questions about your data or to request deletion, subject to applicable law.',
    ),
    LegalSectionData(
      title: '8. Changes to this policy',
      body:
          'We may update this Privacy Policy from time to time. We will notify you of material changes through the app or by other reasonable means. Continued use after changes constitutes acceptance of the updated policy.',
    ),
    LegalSectionData(
      title: '9. Contact',
      body:
          'If you have questions about this Privacy Policy or your data, please reach us through the in-app Support options.',
    ),
  ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.xxl,
                  0,
                ),
                child: Row(
                  children: [
                    ScreenBackButton(
                      iconColor:
                          isDark ? _LP.darkAccent : _LP.lightAccent,
                    ),
                    Expanded(
                      child: Text(
                        AppStrings.privacyPolicy,
                        style: AppTypography.titleLarge(context).copyWith(
                          color: isDark
                              ? _LP.darkTextPrimary
                              : _LP.lightAccent,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxl,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                    AppSpacing.jumbo,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LegalDocumentMeta(text: AppStrings.legalLastUpdated),
                          ..._sections.map((s) => LegalSection(data: s)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LP {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkAccent = Color(0xFFBC80DE);
}
