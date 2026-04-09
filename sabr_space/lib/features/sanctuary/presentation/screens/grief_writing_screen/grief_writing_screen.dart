import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/intro/presentation/widgets/gradient_button.dart';

/// Grief Burner – Writing state: text input for releasing grief.
class GriefWritingScreen extends StatefulWidget {
  const GriefWritingScreen({super.key});

  @override
  State<GriefWritingScreen> createState() => _GriefWritingScreenState();
}

class _GriefWritingScreenState extends State<GriefWritingScreen> {
  final TextEditingController _textController = TextEditingController();
  bool get _hasText => _textController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.etherealBackground(context),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // ── Top bar ──
                Row(
                  children: [
                    const ScreenBackButton(),
                    const Spacer(),
                    Text(
                      AppStrings.griefBurner,
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
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.palette.error.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: context.palette.error.withValues(alpha: 0.7),
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                Text(
                  'Write what weighs on your heart.',
                  style: AppTypography.headlineSmall(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Let go of what you cannot hold. These words are only for you.',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: context.palette.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Text input (scrollable so it stays visible when keyboard opens) ──
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Container(
                            padding: AppSpacing.cardPadding,
                            decoration: BoxDecoration(
                              color: context.palette.surfaceContainerLowest,
                              borderRadius: AppSpacing.borderRadiusXl,
                              boxShadow: [
                                BoxShadow(
                                  color: context.palette.onSurface
                                      .withValues(alpha: 0.03),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            alignment: Alignment.topCenter,
                            child: TextField(
                              controller: _textController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 8,
                              maxLines: null,
                              style: AppTypography.bodyLarge(context),
                              cursorColor: context.palette.secondary,
                              scrollPadding: const EdgeInsets.only(bottom: 120),
                              decoration: InputDecoration(
                                hintText: 'Begin writing here...',
                                hintStyle:
                                    AppTypography.bodyLarge(context).copyWith(
                                  color: context.palette.outline
                                      .withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Burn button ──
                GradientButton(
                  text: _hasText ? 'Release & Burn 🔥' : 'Write something first',
                  onPressed: _hasText
                      ? () => context.pushReplacement('/grief-burn')
                      : () {},
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

