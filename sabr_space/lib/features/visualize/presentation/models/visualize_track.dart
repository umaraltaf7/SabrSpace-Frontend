import 'package:flutter/foundation.dart';

enum VisualizeCategory { tilawat, bodyScan }

@immutable
class VisualizeTrack {
  const VisualizeTrack({
    required this.title,
    required this.category,
    required this.audioUrl,
  });

  final String title;
  final VisualizeCategory category;
  final String audioUrl;

  static const List<VisualizeTrack> tilawatTracks = [
    VisualizeTrack(
      title: 'Surah Ar-Rahman',
      category: VisualizeCategory.tilawat,
      audioUrl: 'https://server8.mp3quran.net/afs/055.mp3',
    ),
    VisualizeTrack(
      title: 'Surah Al-Mulk',
      category: VisualizeCategory.tilawat,
      audioUrl: 'https://server8.mp3quran.net/afs/067.mp3',
    ),
    VisualizeTrack(
      title: 'Surah Yaseen',
      category: VisualizeCategory.tilawat,
      audioUrl: 'https://server8.mp3quran.net/afs/036.mp3',
    ),
    VisualizeTrack(
      title: 'Surah Al-Kahf',
      category: VisualizeCategory.tilawat,
      audioUrl: 'https://server8.mp3quran.net/afs/018.mp3',
    ),
    VisualizeTrack(
      title: 'Surah Al-Waqiah',
      category: VisualizeCategory.tilawat,
      audioUrl: 'https://server8.mp3quran.net/afs/056.mp3',
    ),
    VisualizeTrack(
      title: 'Surah Ad-Dukhan',
      category: VisualizeCategory.tilawat,
      audioUrl: 'https://server8.mp3quran.net/afs/044.mp3',
    ),
  ];

  static const List<VisualizeTrack> bodyScanTracks = [
    VisualizeTrack(
      title: '2 Min Body Scan',
      category: VisualizeCategory.bodyScan,
      audioUrl:
          'https://cdn.pixabay.com/audio/2022/02/23/audio_ea70ad08e0.mp3',
    ),
    VisualizeTrack(
      title: '5 Min Body Scan',
      category: VisualizeCategory.bodyScan,
      audioUrl:
          'https://cdn.pixabay.com/audio/2022/08/25/audio_4f3b0a8a47.mp3',
    ),
    VisualizeTrack(
      title: 'Deep Relaxation',
      category: VisualizeCategory.bodyScan,
      audioUrl:
          'https://cdn.pixabay.com/audio/2022/05/27/audio_1808fbf07a.mp3',
    ),
    VisualizeTrack(
      title: 'Gentle Healing',
      category: VisualizeCategory.bodyScan,
      audioUrl:
          'https://cdn.pixabay.com/audio/2021/11/13/audio_cb4b5ec85d.mp3',
    ),
    VisualizeTrack(
      title: '5 Senses Grounding',
      category: VisualizeCategory.bodyScan,
      audioUrl:
          'https://cdn.pixabay.com/audio/2023/09/06/audio_13eab70a4b.mp3',
    ),
    VisualizeTrack(
      title: 'Sleep Body Scan',
      category: VisualizeCategory.bodyScan,
      audioUrl:
          'https://cdn.pixabay.com/audio/2022/01/20/audio_d0a13f69d2.mp3',
    ),
  ];
}
