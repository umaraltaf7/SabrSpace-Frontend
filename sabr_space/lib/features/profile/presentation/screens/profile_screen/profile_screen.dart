import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/providers/theme_mode_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: isDark
          ? _ProfilePalette.darkBackgroundBottom
          : _ProfilePalette.lightBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    _ProfilePalette.darkBackgroundTop,
                    _ProfilePalette.darkBackgroundBottom,
                  ]
                : const [
                    _ProfilePalette.lightBackgroundTop,
                    _ProfilePalette.lightBackgroundBottom,
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              children: [
                _ProfileHero(isDark: isDark),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: _buildMenuPanel(context, ref, isDark, themeMode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuPanel(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    ThemeMode themeMode,
  ) {
    final panelColor = isDark
        ? _ProfilePalette.darkSurface.withOpacity(0.94)
        : _ProfilePalette.lightSurfaceSoft;
    final dividerColor = isDark
        ? Colors.white.withOpacity(0.08)
        : _ProfilePalette.lightBorder.withOpacity(0.42);

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark
              ? _ProfilePalette.darkBorder.withOpacity(0.42)
              : _ProfilePalette.lightBorder.withOpacity(0.72),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? _ProfilePalette.darkShadow.withOpacity(0.58)
                : _ProfilePalette.lightShadow.withOpacity(0.24),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: isDark
                      ? _ProfilePalette.darkAccentSoft
                      : _ProfilePalette.lightAccent,
                ),
                const SizedBox(width: 10),
                Text(
                  'Theme',
                  style: TextStyle(
                    color: isDark
                        ? _ProfilePalette.darkTextPrimary
                        : _ProfilePalette.lightTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _ThemeChip(
                  label: 'Light',
                  selected: themeMode == ThemeMode.light,
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  label: 'Dark',
                  selected: themeMode == ThemeMode.dark,
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                  isDark: isDark,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dividerColor),
          _ProfileMenuItem(
            isDark: isDark,
            icon: Icons.diamond_outlined,
            label: 'Upgrade to Premium',
            onTap: () => context.push('/premium'),
          ),
          Divider(height: 1, color: dividerColor),
          _ProfileMenuItem(
            isDark: isDark,
            icon: Icons.help_outline_rounded,
            label: 'Support',
            onTap: () => context.push('/support'),
          ),
          Divider(height: 1, color: dividerColor),
          _ProfileMenuItem(
            isDark: isDark,
            icon: Icons.star_border_rounded,
            label: 'Milestones',
            onTap: () => context.push('/milestone'),
          ),
          Divider(height: 1, color: dividerColor),
          _ProfileMenuItem(
            isDark: isDark,
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            color: const Color(0xFFD35A6E),
            onTap: () => context.go('/'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  _ProfilePalette.darkHeroTop,
                  _ProfilePalette.darkHeroBottom,
                ]
              : const [
                  _ProfilePalette.lightHeroTop,
                  _ProfilePalette.lightHeroBottom,
                ],
        ),
        border: Border.all(
          color: isDark
              ? _ProfilePalette.darkBorder.withOpacity(0.55)
              : _ProfilePalette.lightBorder.withOpacity(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? _ProfilePalette.darkShadow.withOpacity(0.70)
                : _ProfilePalette.lightShadow.withOpacity(0.28),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _HeroBackgroundPainter(isDark: isDark))),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.05,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(isDark ? 0.26 : 0.16),
                      ],
                      stops: const [0.62, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? const [_ProfilePalette.darkOrbTop, _ProfilePalette.darkOrbBottom]
                            : const [_ProfilePalette.lightOrbTop, _ProfilePalette.lightOrbBottom],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(isDark ? 0.74 : 0.82),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/220?img=47',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white.withOpacity(0.10),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aisha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'aisha@example.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.86),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final bool isDark;
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: color ?? (isDark ? _ProfilePalette.darkAccentSoft : _ProfilePalette.lightAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? (color ?? _ProfilePalette.darkTextPrimary)
                      : (color ?? _ProfilePalette.lightTextPrimary),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark
                  ? _ProfilePalette.darkTextSecondary.withOpacity(0.75)
                  : _ProfilePalette.lightTextSecondary.withOpacity(0.75),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? _ProfilePalette.darkAccent : _ProfilePalette.lightAccent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? activeColor.withOpacity(isDark ? 0.40 : 0.16)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? activeColor.withOpacity(0.80)
                : (isDark
                    ? _ProfilePalette.darkBorder.withOpacity(0.42)
                    : _ProfilePalette.lightBorder.withOpacity(0.62)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? _ProfilePalette.darkTextPrimary : _ProfilePalette.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}

class _HeroBackgroundPainter extends CustomPainter {
  _HeroBackgroundPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    _paintClouds(canvas, size);
    _paintHills(canvas, size);
    _paintBranches(canvas, size);
    _paintMoon(canvas, size);
    _paintStars(canvas, size);
  }

  void _paintMoon(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.28, size.height * 0.30);
    final radius = size.width * 0.18;
    final moonColor = (isDark ? const Color(0xFFF8DEAA) : const Color(0xFFF9E9C9))
        .withOpacity(isDark ? 0.92 : 0.96);
    canvas.drawCircle(
      center,
      radius * 2.0,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.10 : 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11),
    );
    canvas.drawCircle(
      center,
      radius * 1.35,
      Paint()
        ..color = moonColor.withOpacity(isDark ? 0.16 : 0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    final moonPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final cutPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(radius * 0.38, -radius * 0.15),
          radius: radius * 0.90,
        ),
      );
    final crescent = Path.combine(PathOperation.difference, moonPath, cutPath);
    canvas.drawPath(
      crescent,
      Paint()..color = moonColor.withOpacity(isDark ? 0.94 : 1.0),
    );
  }

  void _paintClouds(Canvas canvas, Size size) {
    final cloudColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.18);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.52, size.height * 0.14),
        width: size.width * 0.54,
        height: size.height * 0.14,
      ),
      Paint()
        ..color = cloudColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.20, size.height * 0.60),
        width: size.width * 0.44,
        height: size.height * 0.10,
      ),
      Paint()
        ..color = cloudColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );
  }

  void _paintHills(Canvas canvas, Size size) {
    final farColor = isDark
        ? const Color(0xFF7A4B95).withOpacity(0.38)
        : const Color(0xFFD2B6E8).withOpacity(0.40);
    final nearColor = isDark
        ? const Color(0xFF4B285F).withOpacity(0.76)
        : const Color(0xFFA978CC).withOpacity(0.38);
    final far = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.70)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.58,
        size.width * 0.50,
        size.height * 0.70,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.80,
        size.width,
        size.height * 0.62,
      )
      ..lineTo(size.width, size.height)
      ..close();
    final near = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.84)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.74,
        size.width * 0.60,
        size.height * 0.84,
      )
      ..quadraticBezierTo(
        size.width * 0.84,
        size.height * 0.92,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(far, Paint()..color = farColor);
    canvas.drawPath(near, Paint()..color = nearColor);
  }

  void _paintStars(Canvas canvas, Size size) {
    final bright = Colors.white.withOpacity(isDark ? 0.92 : 0.96);
    final dim = Colors.white.withOpacity(isDark ? 0.54 : 0.68);
    final rng = Random(9);
    for (int i = 0; i < 20; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.48;
      canvas.drawCircle(
        Offset(x, y),
        rng.nextDouble() * 1.4 + 0.3,
        Paint()..color = i % 3 == 0 ? bright : dim,
      );
    }
  }

  void _paintBranches(Canvas canvas, Size size) {
    final leafA = isDark
        ? const Color(0xFF6C3D83).withOpacity(0.88)
        : const Color(0xFFB785D5).withOpacity(0.56);
    final leafB = isDark
        ? const Color(0xFF48285A).withOpacity(0.92)
        : const Color(0xFFDCC4EE).withOpacity(0.54);
    final leafC = isDark
        ? const Color(0xFF8D59AA).withOpacity(0.72)
        : const Color(0xFFC898DF).withOpacity(0.50);

    _drawStem(
      canvas,
      Offset(size.width + 2, size.height * 0.05),
      Offset(size.width * 0.78, size.height * 0.38),
      leafA,
    );
    _drawLeaf(canvas, Offset(size.width * 0.97, size.height * 0.04), -0.5, 36, leafA);
    _drawLeaf(canvas, Offset(size.width * 0.94, size.height * 0.10), -0.8, 32, leafC);
    _drawLeaf(canvas, Offset(size.width * 0.91, size.height * 0.17), -1.1, 30, leafB);
    _drawLeaf(canvas, Offset(size.width * 0.88, size.height * 0.24), -1.4, 26, leafA);
    _drawLeaf(canvas, Offset(size.width * 0.85, size.height * 0.30), -1.6, 22, leafC);
    _drawLeaf(canvas, Offset(size.width * 0.82, size.height * 0.36), -1.9, 20, leafB);
    _drawLeaf(canvas, Offset(size.width * 0.98, size.height * 0.16), -0.2, 22, leafB);
    _drawLeaf(canvas, Offset(size.width * 0.96, size.height * 0.26), -0.4, 18, leafC);
    _drawLeaf(canvas, Offset(size.width * 0.86, size.height * 0.08), -0.3, 26, leafB);

    _drawStem(
      canvas,
      Offset(size.width + 2, size.height * 0.65),
      Offset(size.width * 0.88, size.height * 0.80),
      leafA,
    );
    _drawLeaf(canvas, Offset(size.width * 0.97, size.height * 0.66), -2.0, 24, leafA);
    _drawLeaf(canvas, Offset(size.width * 0.94, size.height * 0.72), -2.3, 20, leafC);
    _drawLeaf(canvas, Offset(size.width * 0.91, size.height * 0.78), -2.6, 18, leafB);

    _drawStem(
      canvas,
      Offset(-2, size.height * 0.50),
      Offset(size.width * 0.16, size.height * 0.72),
      leafA,
    );
    _drawLeaf(canvas, Offset(size.width * 0.02, size.height * 0.50), 0.5, 30, leafA);
    _drawLeaf(canvas, Offset(size.width * 0.05, size.height * 0.56), 0.2, 26, leafC);
    _drawLeaf(canvas, Offset(size.width * 0.08, size.height * 0.63), -0.1, 22, leafB);
    _drawLeaf(canvas, Offset(size.width * 0.11, size.height * 0.69), -0.4, 20, leafA);
    _drawLeaf(canvas, Offset(size.width * 0.01, size.height * 0.44), 0.9, 24, leafB);
    _drawLeaf(canvas, Offset(size.width * 0.14, size.height * 0.74), -0.6, 16, leafC);
    _drawLeaf(canvas, Offset(size.width * 0.03, size.height * 0.06), 0.4, 20, leafB);
    _drawLeaf(canvas, Offset(size.width * 0.01, size.height * 0.14), 0.7, 16, leafC);
  }

  void _drawStem(Canvas canvas, Offset from, Offset to, Color color) {
    canvas.drawLine(
      from,
      to,
      Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawLeaf(
    Canvas canvas,
    Offset base,
    double angle,
    double len,
    Color color,
  ) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(len * 0.35, -len * 0.24, len, 0)
      ..quadraticBezierTo(len * 0.35, len * 0.24, 0, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HeroBackgroundPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _ProfilePalette {
  static const Color lightBackgroundTop = Color(0xFFFFFFFF);
  static const Color lightBackgroundBottom = Color(0xFFFFFFFF);

  static const Color darkBackgroundTop = Color(0xFF32143E);
  static const Color darkBackgroundBottom = Color(0xFF4D255A);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);

  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightSurfaceSoft = Color(0xFFE7D6F4);
  static const Color darkSurface = Color(0xFF341C49);

  static const Color lightBorder = Color(0xFFC6A3DE);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF7C44AE);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightHeroTop = Color(0xFF7F45B3);
  static const Color lightHeroBottom = Color(0xFF562C8B);

  static const Color darkHeroTop = Color(0xFF4E266C);
  static const Color darkHeroBottom = Color(0xFF673889);

  static const Color lightOrbTop = Color(0xFFC99EE4);
  static const Color lightOrbBottom = Color(0xFF7A43A9);

  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);

  static const Color lightShadow = Color(0xFFA064CB);
  static const Color darkShadow = Color(0xFF0C0515);
}
