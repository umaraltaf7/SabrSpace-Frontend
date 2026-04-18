import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/theme/app_typography.dart';
import 'package:sabr_space/features/quran/presentation/models/quran_verse_item.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final AudioPlayer _player = AudioPlayer();
  final Set<String> _favorites = {};

  String? _playingId;
  bool _loadingAudio = false;

  late final StreamSubscription<PlayerState> _stateSub;
  late final StreamSubscription<void> _completeSub;

  @override
  void initState() {
    super.initState();
    _stateSub = _player.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
    _completeSub = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingId = null);
    });
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _completeSub.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(QuranVerseItem item) async {
    if (_playingId == item.id && !_loadingAudio) {
      final state = _player.state;
      if (state == PlayerState.playing) {
        await _player.pause();
        setState(() {});
        return;
      }
      if (state == PlayerState.paused) {
        await _player.resume();
        setState(() => _playingId = item.id);
        return;
      }
    }

    setState(() {
      _loadingAudio = true;
      _playingId = item.id;
    });
    try {
      await _player.stop();
      await _player.play(UrlSource(item.audioUrl));
    } finally {
      if (mounted) {
        setState(() => _loadingAudio = false);
      }
    }
  }

  bool _isPlaying(QuranVerseItem item) =>
      _playingId == item.id &&
      _player.state == PlayerState.playing &&
      !_loadingAudio;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? _QPalette.darkBgBottom : _QPalette.lightBgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [_QPalette.darkBgTop, _QPalette.darkBgBottom]
                : const [_QPalette.lightBgTop, _QPalette.lightBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  0,
                ),
                child: Text(
                  'Qur\'an',
                  style: AppTypography.headlineMedium(context).copyWith(
                    color: isDark
                        ? _QPalette.darkTextPrimary
                        : _QPalette.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  children: [
                    _HeroIllustration(isDark: isDark),
                    const SizedBox(height: AppSpacing.lg),
                    _QuranPill(isDark: isDark),
                    const SizedBox(height: AppSpacing.xxl),
                    ...QuranVerseItem.sampleVerses.map(
                      (v) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: _VerseCard(
                          item: v,
                          isDark: isDark,
                          isFavorite: _favorites.contains(v.id),
                          onFavorite: () => setState(() {
                            if (_favorites.contains(v.id)) {
                              _favorites.remove(v.id);
                            } else {
                              _favorites.add(v.id);
                            }
                          }),
                          isPlaying: _isPlaying(v),
                          loading: _loadingAudio && _playingId == v.id,
                          onPlay: () => _togglePlay(v),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF3D1D5C), Color(0xFF5A2F79)]
              : const [Color(0xFF8B5CBC), Color(0xFFB786D6)],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.45)
                : _QPalette.lightShadow.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDark
              ? _QPalette.darkBorder.withOpacity(0.25)
              : Colors.white.withOpacity(0.35),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _QuranHeroPainter(isDark: isDark),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: Colors.white.withOpacity(0.92),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Recite & reflect',
                    style: AppTypography.titleSmall(context).copyWith(
                      color: Colors.white.withOpacity(0.88),
                      fontWeight: FontWeight.w600,
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

class _QuranPill extends StatelessWidget {
  const _QuranPill({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isDark
            ? _QPalette.darkCard.withOpacity(0.85)
            : _QPalette.lightCard.withOpacity(0.95),
        border: Border.all(
          color: isDark
              ? _QPalette.darkBorder.withOpacity(0.35)
              : _QPalette.lightBorder.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 20,
            color: isDark ? _QPalette.darkAccent : _QPalette.lightAccent,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Qur\'an',
            style: AppTypography.titleMedium(context).copyWith(
              color: isDark
                  ? _QPalette.darkTextPrimary
                  : _QPalette.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  const _VerseCard({
    required this.item,
    required this.isDark,
    required this.isFavorite,
    required this.onFavorite,
    required this.isPlaying,
    required this.loading,
    required this.onPlay,
  });

  final QuranVerseItem item;
  final bool isDark;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final bool isPlaying;
  final bool loading;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  _QPalette.darkCard,
                  _QPalette.darkCard.withOpacity(0.92),
                ]
              : [
                  _QPalette.lightCard,
                  const Color(0xFFF5E8FC),
                ],
        ),
        border: Border.all(
          color: isDark
              ? _QPalette.darkBorder.withOpacity(0.22)
              : _QPalette.lightBorder.withOpacity(0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _CardStarsPainter(isDark: isDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.titleSmall(context).copyWith(
                            color: isDark
                                ? _QPalette.darkTextPrimary
                                : _QPalette.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        onPressed: onFavorite,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 22,
                          color: isFavorite
                              ? const Color(0xFFE573A3)
                              : (isDark
                                  ? _QPalette.darkTextSecondary
                                  : _QPalette.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    item.arabic,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: AppTypography.titleLarge(context).copyWith(
                      height: 1.8,
                      color: isDark
                          ? _QPalette.darkTextPrimary
                          : _QPalette.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.transliteration,
                    style: AppTypography.bodySmall(context).copyWith(
                      color: isDark
                          ? _QPalette.darkTextSecondary
                          : _QPalette.lightTextSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDark
                          ? const Color(0xFF1E0F2E).withOpacity(0.75)
                          : Colors.white.withOpacity(0.65),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : _QPalette.lightBorder.withOpacity(0.35),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.english,
                            style: AppTypography.bodyMedium(context).copyWith(
                              color: isDark
                                  ? _QPalette.darkTextPrimary.withOpacity(0.92)
                                  : _QPalette.lightTextPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Material(
                          color: isDark
                              ? _QPalette.darkAccent.withOpacity(0.35)
                              : _QPalette.lightAccent.withOpacity(0.2),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onPlay,
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: loading
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: isDark
                                            ? _QPalette.darkAccentSoft
                                            : _QPalette.lightAccent,
                                      ),
                                    )
                                  : Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: isDark
                                          ? _QPalette.darkAccentSoft
                                          : _QPalette.lightAccent,
                                      size: 28,
                                    ),
                            ),
                          ),
                        ),
                      ],
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

class _QuranHeroPainter extends CustomPainter {
  _QuranHeroPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final moon = isDark
        ? const Color(0xFFE8C4F5).withOpacity(0.35)
        : Colors.white.withOpacity(0.25);
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.22),
      size.width * 0.12,
      Paint()
        ..color = moon
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    final dune = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.55,
        size.width * 0.55,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.88,
        size.width,
        size.height * 0.62,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      dune,
      Paint()
        ..color = isDark
            ? const Color(0xFF2D1650).withOpacity(0.55)
            : const Color(0xFF6E35A3).withOpacity(0.25),
    );

    final bookLeft = size.width * 0.38;
    final bookTop = size.height * 0.38;
    final bookW = size.width * 0.24;
    final bookH = size.height * 0.22;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(bookLeft, bookTop, bookW, bookH),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      r,
      Paint()..color = Colors.white.withOpacity(isDark ? 0.14 : 0.22),
    );
    canvas.drawLine(
      Offset(bookLeft + bookW / 2, bookTop + 4),
      Offset(bookLeft + bookW / 2, bookTop + bookH - 4),
      Paint()
        ..color = Colors.white.withOpacity(0.25)
        ..strokeWidth = 1,
    );

    final rng = math.Random(7);
    for (int i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(
          rng.nextDouble() * size.width,
          rng.nextDouble() * size.height * 0.55,
        ),
        rng.nextDouble() * 1.2 + 0.3,
        Paint()..color = Colors.white.withOpacity(0.15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _QuranHeroPainter old) => old.isDark != isDark;
}

class _CardStarsPainter extends CustomPainter {
  _CardStarsPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(11);
    final c = Colors.white.withOpacity(isDark ? 0.04 : 0.06);
    for (int i = 0; i < 18; i++) {
      canvas.drawCircle(
        Offset(
          rng.nextDouble() * size.width,
          rng.nextDouble() * size.height,
        ),
        rng.nextDouble() * 1.0 + 0.2,
        Paint()..color = c,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CardStarsPainter old) =>
      old.isDark != isDark;
}

class _QPalette {
  static const Color lightBgTop = Color(0xFFFFFFFF);
  static const Color lightBgBottom = Color(0xFFF3E6FB);
  static const Color darkBgTop = Color(0xFF32143E);
  static const Color darkBgBottom = Color(0xFF4D255A);

  static const Color lightTextPrimary = Color(0xFF3D274E);
  static const Color lightTextSecondary = Color(0xFF7C57A0);
  static const Color darkTextPrimary = Color(0xFFF4EAFB);
  static const Color darkTextSecondary = Color(0xFFE8D4F4);

  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF341C49);

  static const Color lightBorder = Color(0xFFBC95D8);
  static const Color darkBorder = Color(0xFFCC98E7);

  static const Color lightAccent = Color(0xFF6E35A3);
  static const Color darkAccent = Color(0xFFBC80DE);
  static const Color darkAccentSoft = Color(0xFFE0B2F0);

  static const Color lightShadow = Color(0xFF6F39AF);
}
