import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/core/widgets/screen_back_button.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/audio/presentation/models/audio_player_args.dart';

/// Audio hub: search, categories, featured card, recent sessions.
/// Light background; accents from [AppColors].
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
    final bg = context.palette.surface;
    final onSurf = context.palette.onSurface;
    final onVar = context.palette.onSurfaceVariant;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
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
                    const Row(
                      children: [
                        ScreenBackButton(),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: context.palette.primary,
                          child: Icon(
                            Icons.person_rounded,
                            color: context.palette.onPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Salam, friend',
                                style: AppTypography.titleMedium(context).copyWith(
                                  color: onSurf,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Your listening space',
                                style: AppTypography.bodySmall(context).copyWith(
                                  color: onVar,
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
                              color: context.palette.secondaryFixed
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            size: 20,
                            color: context.palette.secondaryFixed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    TextField(
                      controller: _search,
                      style: AppTypography.bodyMedium(context).copyWith(color: onSurf),
                      cursorColor: context.palette.primary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.palette.surfaceContainerHigh,
                        hintText: 'Search sessions…',
                        hintStyle: AppTypography.bodyMedium(context).copyWith(
                          color: onVar,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: onVar,
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
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final selected = i == _chipIndex;
                          return FilterChip(
                            label: Text(_categories[i]),
                            selected: selected,
                            onSelected: (_) => setState(() => _chipIndex = i),
                            backgroundColor:
                                context.palette.primary.withValues(alpha: 0.42),
                            selectedColor: context.palette.secondaryContainer,
                            labelStyle: AppTypography.labelLarge(context).copyWith(
                              color: selected
                                  ? context.palette.onSecondaryContainer
                                  : context.palette.primaryFixed
                                      .withValues(alpha: 0.95),
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            side: BorderSide(
                              color: selected
                                  ? context.palette.secondary
                                  : context.palette.primary.withValues(alpha: 0.65),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusFull,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(
                      'Featured Wisdom',
                      style: AppTypography.headlineSmall(context).copyWith(
                        color: onSurf,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              sliver: SliverToBoxAdapter(
                child: _FeaturedCard(
                  onListen: () => _openPlayer(AudioPlayerArgs.featured()),
                ),
              ),
            ),
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
                      style: AppTypography.headlineSmall(context).copyWith(
                        color: onSurf,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: AppTypography.labelLarge(context).copyWith(
                          color: context.palette.secondaryFixed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final s = _sessions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _SessionTile(
                        data: s,
                        onTap: s.locked
                            ? null
                            : () => _openPlayer(
                                  AudioPlayerArgs.session(
                                    title: s.title,
                                    artist: 'Sabr Space Audio',
                                    collectionTitle: 'Recent',
                                    duration: const Duration(minutes: 8, seconds: 40),
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
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.jumbo)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.onListen});

  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    const onCard = Colors.white;
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusXxl,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.palette.primary.withValues(alpha: 0.55),
                    context.palette.primaryContainer.withValues(alpha: 0.45),
                    context.palette.tertiary.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
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
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Text(
                        'DAILY PATH',
                        style: AppTypography.labelSmall(context).copyWith(
                          color: onCard,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '• 12 min',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: onCard.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Finding Stillness in the Storm',
                  style: AppTypography.headlineSmall(context).copyWith(
                    color: onCard,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Slow down, breathe, and return to the present with compassion.',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: onCard.withValues(alpha: 0.9),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppGradients.goldGradient,
                      borderRadius: AppSpacing.borderRadiusFull,
                      boxShadow: [
                        BoxShadow(
                          color: context.palette.secondary.withValues(alpha: 0.35),
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
                              Icon(
                                Icons.play_arrow_rounded,
                                color: context.palette.onSecondaryFixed,
                                size: 28,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Listen now',
                                style: AppTypography.titleSmall(context).copyWith(
                                  color: context.palette.onSecondaryFixed,
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
    required this.data,
    required this.onTap,
    required this.onUpgrade,
  });

  final _SessionTileData data;
  final VoidCallback? onTap;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final onSurf = context.palette.onSurface;
    final onVar = context.palette.onSurfaceVariant;
    return Material(
      color: context.palette.surfaceContainerHigh,
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
                  gradient: AppGradients.primaryGradient(context),
                ),
                child: Icon(
                  data.locked ? Icons.lock_rounded : Icons.graphic_eq_rounded,
                  color: context.palette.onPrimary,
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
                        color: onSurf,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.meta,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: onVar,
                      ),
                    ),
                  ],
                ),
              ),
              if (data.locked && onUpgrade != null)
                OutlinedButton(
                  onPressed: onUpgrade,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.palette.secondaryFixed,
                    side: BorderSide(
                      color: context.palette.secondaryFixed.withValues(alpha: 0.8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                  child: Text(
                    'Upgrade',
                    style: AppTypography.labelSmall(context).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.more_vert_rounded,
                  color: onVar,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
