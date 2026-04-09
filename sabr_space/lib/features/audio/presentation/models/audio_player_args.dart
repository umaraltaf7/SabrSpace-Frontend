import 'package:flutter/foundation.dart';

@immutable
class AudioPlayerArgs {
  const AudioPlayerArgs({
    required this.trackTitle,
    required this.artist,
    required this.collectionTitle,
    this.subtitle,
    this.duration = const Duration(minutes: 18, seconds: 45),
    this.position = Duration.zero,
    this.isLocked = false,
  });

  final String trackTitle;
  final String artist;
  final String collectionTitle;
  final String? subtitle;
  final Duration duration;
  final Duration position;
  final bool isLocked;

  static AudioPlayerArgs featured() => const AudioPlayerArgs(
        trackTitle: 'Finding Stillness in the Storm',
        artist: 'Sabr Space Audio',
        collectionTitle: 'The Night Journey',
        subtitle:
            'A gentle guided reflection for when the mind feels crowded.',
      );

  static AudioPlayerArgs session({
    required String title,
    required String artist,
    required String collectionTitle,
    Duration duration = const Duration(minutes: 8, seconds: 40),
  }) =>
      AudioPlayerArgs(
        trackTitle: title,
        artist: artist,
        collectionTitle: collectionTitle,
        duration: duration,
      );
}
