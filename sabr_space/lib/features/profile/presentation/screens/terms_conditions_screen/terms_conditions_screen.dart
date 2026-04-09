import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/profile/presentation/widgets/legal_document_content.dart';

/// Terms and conditions for using Sabr Space.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static final List<LegalSectionData> _sections = [
    LegalSectionData(
      title: '1. Agreement',
      body:
          'By downloading or using Sabr Space, you agree to these Terms and Conditions and our Privacy Policy. If you do not agree, please do not use the app.',
    ),
    LegalSectionData(
      title: '2. Nature of the service',
      body:
          'Sabr Space provides mindfulness, spiritual reflection, breathing exercises, journaling, and related wellness content for personal use. The app is not a substitute for professional medical, psychological, or crisis care. If you are in danger or experiencing a mental health emergency, contact local emergency services or a qualified professional.',
    ),
    LegalSectionData(
      title: '3. Your account',
      body:
          'You are responsible for maintaining the confidentiality of your account credentials and for activity under your account. Notify us promptly of any unauthorized use.',
    ),
    LegalSectionData(
      title: '4. Acceptable use',
      body:
          'You agree not to misuse the app, attempt to access others\' data, reverse engineer the software except as permitted by law, or use the service in any unlawful or harmful way. We may suspend access for violations.',
    ),
    LegalSectionData(
      title: '5. Content and intellectual property',
      body:
          'Sabr Space, its branding, design, and original content are protected by intellectual property laws. You receive a limited, non-exclusive license to use the app for personal, non-commercial purposes. Quranic and spiritual quotations are presented for reflection; rights in underlying texts remain with their respective holders.',
    ),
    LegalSectionData(
      title: '6. Subscriptions and purchases',
      body:
          'If premium or paid features are offered, pricing and renewal terms will be shown at purchase. Payments are processed by platform providers (e.g. Apple App Store, Google Play) according to their terms.',
    ),
    LegalSectionData(
      title: '7. Disclaimer of warranties',
      body:
          'The app is provided "as is" without warranties of any kind, express or implied. We do not guarantee uninterrupted or error-free operation.',
    ),
    LegalSectionData(
      title: '8. Limitation of liability',
      body:
          'To the fullest extent permitted by law, Sabr Space and its contributors are not liable for indirect, incidental, or consequential damages arising from your use of the app.',
    ),
    LegalSectionData(
      title: '9. Changes',
      body:
          'We may modify these terms or the app. Material changes will be communicated reasonably (for example, in-app). Continued use after changes constitutes acceptance.',
    ),
    LegalSectionData(
      title: '10. Contact',
      body:
          'Questions about these terms can be sent through the in-app Support section.',
    ),
  ];

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
                    const ScreenBackButton(),
                    Expanded(
                      child: Text(
                        AppStrings.termsAndConditions,
                        style: AppTypography.titleLarge(context).copyWith(
                          color: context.palette.primary,
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
