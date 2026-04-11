import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? _GP.darkBgBottom : _GP.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_GP.darkBgTop, _GP.darkBgBottom]
                : const [_GP.lightBgTop, _GP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),

                // ── Top bar ──
                Row(
                  children: [
                    ScreenBackButton(
                      iconColor:
                          isDark ? _GP.darkAccent : _GP.lightAccent,
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.griefBurner,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: isDark
                            ? _GP.darkTextPrimary
                            : _GP.lightAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Flame orb with glow ──
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? const [_GP.darkOrbTop, _GP.darkOrbBottom]
                            : const [_GP.lightOrbTop, _GP.lightOrbBottom],
                      ),
                      border: Border.all(
                        color: isDark
                            ? _GP.darkAccentSoft.withOpacity(0.62)
                            : Colors.white.withOpacity(0.84),
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? _GP.darkFlame.withOpacity(0.40)
                              : _GP.lightFlame.withOpacity(0.30),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: isDark
                              ? _GP.darkAccent.withOpacity(0.30)
                              : _GP.lightAccent.withOpacity(0.22),
                          blurRadius: 48,
                          spreadRadius: 14,
                        ),
                        if (isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.22),
                            blurRadius: 18,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                Center(
                  child: Text(
                    'Write what weighs on your heart.',
                    style: AppTypography.headlineSmall(context).copyWith(
                      color: isDark
                          ? _GP.darkTextPrimary
                          : _GP.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text(
                    'Let go of what you cannot hold. These words are only for you.',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: isDark
                          ? _GP.darkTextSecondary
                          : _GP.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Decorative ember divider ──
                Center(
                  child: SizedBox(
                    height: 20,
                    child: CustomPaint(
                      size: const Size(180, 20),
                      painter: _EmberDividerPainter(isDark: isDark),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Text input ──
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
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? [
                                        _GP.darkSurface.withOpacity(0.80),
                                        _GP.darkSurfaceElevated
                                            .withOpacity(0.50),
                                      ]
                                    : const [
                                        _GP.lightSurface,
                                        _GP.lightSurfaceSoft,
                                      ],
                              ),
                              borderRadius: AppSpacing.borderRadiusXl,
                              border: Border.all(
                                color: isDark
                                    ? _GP.darkBorder.withOpacity(0.28)
                                    : _GP.lightBorder.withOpacity(0.48),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? _GP.darkShadow.withOpacity(0.36)
                                      : _GP.lightShadow.withOpacity(0.22),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
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
                              style:
                                  AppTypography.bodyLarge(context).copyWith(
                                color: isDark
                                    ? _GP.darkTextPrimary
                                    : _GP.lightTextPrimary,
                              ),
                              cursorColor: isDark
                                  ? _GP.darkAccent
                                  : _GP.lightAccent,
                              scrollPadding:
                                  const EdgeInsets.only(bottom: 120),
                              decoration: InputDecoration(
                                hintText: 'Begin writing here...',
                                hintStyle: AppTypography.bodyLarge(context)
                                    .copyWith(
                                  color: isDark
                                      ? _GP.darkTextSecondary
                                          .withOpacity(0.40)
                                      : _GP.lightTextSecondary
                                          .withOpacity(0.50),
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
                const SizedBox(height: AppSpacing.xl),

                // ── Burn button ──
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _hasText ? 1.0 : 0.40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [_GP.darkFlame, _GP.darkAccent]
                              : [_GP.lightFlame, _GP.lightAccent],
                        ),
                        borderRadius: AppSpacing.borderRadiusFull,
                        boxShadow: _hasText
                            ? [
                                BoxShadow(
                                  color: isDark
                                      ? _GP.darkFlame.withOpacity(0.40)
                                      : _GP.lightFlame.withOpacity(0.36),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: isDark
                                      ? _GP.darkAccent.withOpacity(0.22)
                                      : _GP.lightAccent.withOpacity(0.22),
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: ElevatedButton(
                        onPressed: _hasText
                            ? () =>
                                context.pushReplacement('/grief-burn')
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.transparent,
                          disabledForegroundColor:
                              Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                        ),
                        child: Text(
                          _hasText
                              ? 'Release & Burn 🔥'
                              : 'Write something first',
                          style:
                              AppTypography.labelLarge(context).copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Ember divider — tiny flame-tinted sparkles
// ─────────────────────────────────────────────────────────────────────────────

class _EmberDividerPainter extends CustomPainter {
  final bool isDark;
  _EmberDividerPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final lineColor = isDark
        ? _GP.darkBorder.withOpacity(0.30)
        : _GP.lightBorder.withOpacity(0.50);

    canvas.drawLine(
      Offset(cx - 75, cy),
      Offset(cx - 14, cy),
      Paint()
        ..color = lineColor
        ..strokeWidth = 0.8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(cx + 14, cy),
      Offset(cx + 75, cy),
      Paint()
        ..color = lineColor
        ..strokeWidth = 0.8
        ..strokeCap = StrokeCap.round,
    );

    // Central flame-tinted diamond
    final flameColor = isDark ? _GP.darkFlame : _GP.lightFlame;
    final diamond = Path()
      ..moveTo(cx, cy - 6)
      ..lineTo(cx + 6, cy)
      ..lineTo(cx, cy + 6)
      ..lineTo(cx - 6, cy)
      ..close();
    canvas.drawPath(
      diamond,
      Paint()..color = flameColor.withOpacity(isDark ? 0.72 : 0.58),
    );

    // Glow around the diamond
    canvas.drawCircle(
      Offset(cx, cy),
      10,
      Paint()
        ..color = flameColor.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Ember dots
    final accent = isDark ? _GP.darkAccentSoft : _GP.lightAccent;
    final dotColor = accent.withOpacity(isDark ? 0.40 : 0.30);
    for (final dx in [-55.0, -35.0, 35.0, 55.0]) {
      canvas.drawCircle(
        Offset(cx + dx, cy),
        1.5,
        Paint()..color = dotColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EmberDividerPainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors + warm flame accent
// ─────────────────────────────────────────────────────────────────────────────

class _GP {
  // ── Light mode ──
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightBorder = Color(0xFFBC95D8);

  static const Color lightOrbTop = Color(0xFFB786D6);
  static const Color lightOrbBottom = Color(0xFF69329B);

  static const Color lightFlame = Color(0xFFC25A8E);

  static const Color lightShadow = Color(0xFF6F39AF);

  // ── Dark mode ──
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color darkSurface = Color(0xFF341C49);
  static const Color darkSurfaceElevated = Color(0xFF46275E);

  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);

  static const Color darkFlame = Color(0xFFE07AA8);

  static const Color darkShadow = Color(0xFF0C0515);
}

