import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/features/audio/presentation/models/audio_player_args.dart';

/// Audio hub: search, categories, featured card, recent sessions.
class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen> {
  final _search = TextEditingController();
  int _chipIndex = 0;

  static const _categories = ['Anxiety', 'Sleep', 'Overthinking', 'Focus'];

  static final _sessions = <_SessionTileData>[
    _SessionTileData(
      title: 'Ocean of Calm',
      meta: 'Mindful Awareness • 8:40',
      locked: false,
    ),
    _SessionTileData(
      title: 'Midnight Reflection',
      meta: 'Breath & Dhikr • 12:00',
      locked: true,
    ),
    _SessionTileData(
      title: 'Light After Rain',
      meta: 'Gratitude • 6:15',
      locked: false,
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openPlayer(AudioPlayerArgs args) {
    context.push('/audio-player', extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _ALP.darkBgBottom : _ALP.lightBgBottom,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_ALP.darkBgTop, _ALP.darkBgBottom]
                : const [_ALP.lightBgTop, _ALP.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ScreenBackButton(
                            iconColor: isDark
                                ? _ALP.darkAccent
                                : _ALP.lightAccent,
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // ── Greeting row ──
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? const [
                                        _ALP.darkOrbTop,
                                        _ALP.darkOrbBottom,
                                      ]
                                    : const [
                                        _ALP.lightOrbTop,
                                        _ALP.lightOrbBottom,
                                      ],
                              ),
                              border: Border.all(
                                color: isDark
                                    ? _ALP.darkAccentSoft.withOpacity(0.50)
                                    : Colors.white.withOpacity(0.80),
                                width: 1.6,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Salam, friend',
                                  style: AppTypography.titleMedium(context)
                                      .copyWith(
                                    color: isDark
                                        ? _ALP.darkTextPrimary
                                        : _ALP.lightTextPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Your listening space',
                                  style: AppTypography.bodySmall(context)
                                      .copyWith(
                                    color: isDark
                                        ? _ALP.darkTextSecondary
                                        : _ALP.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? _ALP.darkAccent.withOpacity(0.45)
                                    : _ALP.lightAccent.withOpacity(0.45),
                              ),
                            ),
                            child: Icon(
                              Icons.workspace_premium_rounded,
                              size: 20,
                              color: isDark
                                  ? _ALP.darkAccent
                                  : _ALP.lightAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // ── Search field ──
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    _ALP.darkSurfaceElevated.withOpacity(0.78),
                                    _ALP.darkSurface.withOpacity(0.68),
                                  ]
                                : [
                                    _ALP.lightSurfaceSoft.withOpacity(0.56),
                                    _ALP.lightSurface.withOpacity(0.70),
                                  ],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                          border: Border.all(
                            color: isDark
                                ? _ALP.darkBorder.withOpacity(0.24)
                                : _ALP.lightBorder.withOpacity(0.42),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _search,
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: isDark
                                ? _ALP.darkTextPrimary
                                : _ALP.lightTextPrimary,
                          ),
                          cursorColor:
                              isDark ? _ALP.darkAccent : _ALP.lightAccent,
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'Search sessions…',
                            hintStyle:
                                AppTypography.bodyMedium(context).copyWith(
                              color: isDark
                                  ? _ALP.darkTextSecondary.withOpacity(0.60)
                                  : _ALP.lightTextSecondary.withOpacity(0.70),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: isDark
                                  ? _ALP.darkTextSecondary
                                  : _ALP.lightTextSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: AppSpacing.borderRadiusFull,
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Category chips ──
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, i) {
                            final selected = i == _chipIndex;
                            return GestureDetector(
                              onTap: () => setState(() => _chipIndex = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: selected
                                      ? LinearGradient(
                                          colors: isDark
                                              ? const [
                                                  _ALP.darkOrbTop,
                                                  _ALP.darkOrbBottom,
                                                ]
                                              : const [
                                                  _ALP.lightOrbTop,
                                                  _ALP.lightOrbBottom,
                                                ],
                                        )
                                      : LinearGradient(
                                          colors: isDark
                                              ? [
                                                  _ALP.darkSurfaceElevated
                                                      .withOpacity(0.60),
                                                  _ALP.darkSurface
                                                      .withOpacity(0.50),
                                                ]
                                              : [
                                                  _ALP.lightSurfaceSoft
                                                      .withOpacity(0.50),
                                                  _ALP.lightSurface
                                                      .withOpacity(0.60),
                                                ],
                                        ),
                                  borderRadius: AppSpacing.borderRadiusFull,
                                  border: Border.all(
                                    color: selected
                                        ? (isDark
                                            ? _ALP.darkAccentSoft
                                                .withOpacity(0.52)
                                            : Colors.white.withOpacity(0.70))
                                        : (isDark
                                            ? _ALP.darkBorder.withOpacity(0.26)
                                            : _ALP.lightBorder
                                                .withOpacity(0.46)),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _categories[i],
                                  style: AppTypography.labelLarge(context)
                                      .copyWith(
                                    color: selected
                                        ? Colors.white
                                        : (isDark
                                            ? _ALP.darkTextSecondary
                                            : _ALP.lightTextSecondary),
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      Text(
                        'Featured Wisdom',
                        style:
                            AppTypography.headlineSmall(context).copyWith(
                          color: isDark
                              ? _ALP.darkTextPrimary
                              : _ALP.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),

              // ── Featured card ──
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                sliver: SliverToBoxAdapter(
                  child: _FeaturedCard(
                    isDark: isDark,
                    onListen: () =>
                        _openPlayer(AudioPlayerArgs.featured()),
                  ),
                ),
              ),

              // ── Recent heading ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xxxl,
                  AppSpacing.xxl,
                  AppSpacing.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Sessions',
                        style: AppTypography.headlineSmall(context)
                            .copyWith(
                          color: isDark
                              ? _ALP.darkTextPrimary
                              : _ALP.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View all',
                          style:
                              AppTypography.labelLarge(context).copyWith(
                            color: isDark
                                ? _ALP.darkAccent
                                : _ALP.lightAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Session tiles ──
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final s = _sessions[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _SessionTile(
                          isDark: isDark,
                          data: s,
                          onTap: s.locked
                              ? null
                              : () => _openPlayer(
                                    AudioPlayerArgs.session(
                                      title: s.title,
                                      artist: 'Sabr Space Audio',
                                      collectionTitle: 'Recent',
                                      duration: const Duration(
                                          minutes: 8, seconds: 40),
                                    ),
                                  ),
                          onUpgrade: s.locked
                              ? () => context.push('/premium')
                              : null,
                        ),
                      );
                    },
                    childCount: _sessions.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.jumbo)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Featured card with sound-wave art
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.isDark, required this.onListen});

  final bool isDark;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusXxl,
      child: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [
                          _ALP.darkOrbTop,
                          _ALP.darkOrbBottom,
                          Color(0xFF351A4D),
                        ]
                      : const [
                          _ALP.lightOrbTop,
                          _ALP.lightOrbBottom,
                          Color(0xFF5A2E88),
                        ],
                ),
              ),
            ),
          ),
          // Subtle dark overlay for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.42),
                  ],
                ),
              ),
            ),
          ),
          // Sound wave ornament
          Positioned(
            right: -8,
            bottom: -4,
            width: 140,
            height: 100,
            child: CustomPaint(
              painter: _SoundWaveOrnamentPainter(isDark: isDark),
            ),
          ),
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: AppSpacing.borderRadiusFull,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'DAILY PATH',
                        style:
                            AppTypography.labelSmall(context).copyWith(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '• 12 min',
                      style:
                          AppTypography.labelSmall(context).copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Finding Stillness in the Storm',
                  style:
                      AppTypography.headlineSmall(context).copyWith(
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Slow down, breathe, and return to the present with compassion.',
                  style:
                      AppTypography.bodyMedium(context).copyWith(
                    color: Colors.white.withOpacity(0.90),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Listen button ──
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? const [_ALP.darkAccent, _ALP.darkAccentSoft]
                            : const [
                                _ALP.lightAccent,
                                _ALP.lightAccentSoft
                              ],
                      ),
                      borderRadius: AppSpacing.borderRadiusFull,
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? _ALP.darkAccent.withOpacity(0.40)
                              : _ALP.lightAccent.withOpacity(0.36),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onListen,
                        borderRadius: AppSpacing.borderRadiusFull,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Listen now',
                                style: AppTypography.titleSmall(context)
                                    .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sound-wave ornament — decorative equalizer bars in the featured card
// ─────────────────────────────────────────────────────────────────────────────

class _SoundWaveOrnamentPainter extends CustomPainter {
  final bool isDark;
  _SoundWaveOrnamentPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final barColor = Colors.white.withOpacity(isDark ? 0.14 : 0.18);
    final barCount = 12;
    final barWidth = size.width / (barCount * 2);
    final maxH = size.height * 0.85;

    for (int i = 0; i < barCount; i++) {
      final x = (i * 2 + 0.5) * barWidth;
      final h = maxH * (0.25 + rng.nextDouble() * 0.75);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - h, barWidth * 0.8, h),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, Paint()..color = barColor);
    }
  }

  @override
  bool shouldRepaint(covariant _SoundWaveOrnamentPainter old) =>
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Session tile
// ─────────────────────────────────────────────────────────────────────────────

class _SessionTileData {
  const _SessionTileData({
    required this.title,
    required this.meta,
    required this.locked,
  });

  final String title;
  final String meta;
  final bool locked;
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.isDark,
    required this.data,
    required this.onTap,
    required this.onUpgrade,
  });

  final bool isDark;
  final _SessionTileData data;
  final VoidCallback? onTap;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  _ALP.darkSurfaceElevated.withOpacity(0.78),
                  _ALP.darkSurface.withOpacity(0.66),
                ]
              : [
                  _ALP.lightSurfaceSoft.withOpacity(0.58),
                  _ALP.lightSurface.withOpacity(0.72),
                ],
        ),
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color: isDark
              ? _ALP.darkBorder.withOpacity(0.24)
              : _ALP.lightBorder.withOpacity(0.46),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? _ALP.darkShadow.withOpacity(0.34)
                : _ALP.lightShadow.withOpacity(0.14),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppSpacing.borderRadiusXl,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusXl,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? const [_ALP.darkOrbTop, _ALP.darkOrbBottom]
                          : const [
                              _ALP.lightOrbTop,
                              _ALP.lightOrbBottom
                            ],
                    ),
                    border: Border.all(
                      color: isDark
                          ? _ALP.darkAccentSoft.withOpacity(0.42)
                          : Colors.white.withOpacity(0.70),
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? _ALP.darkAccent.withOpacity(0.26)
                            : _ALP.lightAccent.withOpacity(0.22),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    data.locked
                        ? Icons.lock_rounded
                        : Icons.graphic_eq_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: AppTypography.titleSmall(context).copyWith(
                          color: isDark
                              ? _ALP.darkTextPrimary
                              : _ALP.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.meta,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: isDark
                              ? _ALP.darkTextSecondary
                              : _ALP.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (data.locked && onUpgrade != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? const [_ALP.darkOrbTop, _ALP.darkOrbBottom]
                            : const [
                                _ALP.lightOrbTop,
                                _ALP.lightOrbBottom
                              ],
                      ),
                      borderRadius: AppSpacing.borderRadiusFull,
                      border: Border.all(
                        color: isDark
                            ? _ALP.darkAccentSoft.withOpacity(0.44)
                            : Colors.white.withOpacity(0.66),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppSpacing.borderRadiusFull,
                      child: InkWell(
                        onTap: onUpgrade,
                        borderRadius: AppSpacing.borderRadiusFull,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            'Upgrade',
                            style: AppTypography.labelSmall(context)
                                .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.more_vert_rounded,
                    color: isDark
                        ? _ALP.darkTextSecondary
                        : _ALP.lightTextSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Palette — exact home screen colors
// ─────────────────────────────────────────────────────────────────────────────

class _ALP {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSoft = Color(0xFFE0C9F0);
  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color lightAccentSoft = Color(0xFFCCA8E2);
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
  static const Color darkAccentSoft = Color(0xFFE0B2F0);
  static const Color darkBorder = Color(0xFFCC98E7);
  static const Color darkOrbTop = Color(0xFFA265C9);
  static const Color darkOrbBottom = Color(0xFF4F286F);
  static const Color darkShadow = Color(0xFF0C0515);
}
