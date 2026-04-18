import 'package:flutter/foundation.dart';

/// Hard-coded verse entry for the Quran screen (Arabic, transliteration, English).
@immutable
class QuranVerseItem {
  const QuranVerseItem({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.surah,
    required this.ayah,
  });

  final String id;
  final String title;
  final String arabic;
  final String transliteration;
  final String english;
  final int surah;
  final int ayah;

  /// Mishary Alafasy 128kbps (everyayah.com).
  String get audioUrl =>
      'https://everyayah.com/data/Alafasy_128kbps/'
      '${surah.toString().padLeft(3, '0')}'
      '${ayah.toString().padLeft(3, '0')}.mp3';

  static const List<QuranVerseItem> sampleVerses = [
    QuranVerseItem(
      id: '2_286',
      title: 'Al-Baqarah 2:286',
      surah: 2,
      ayah: 286,
      arabic:
          'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
      transliteration:
          'Lā yukallifu Allāhu nafsan illā wus\'ahā… Rabbanā lā tu\'uākhidhnā in nasīnā aw akhta\'nā…',
      english:
          'Allah does not charge a soul except [with that within] its capacity. It will have [the consequence of] what [good] it has gained, and it will bear [the consequence of] what [evil] it has earned. "Our Lord, do not impose blame upon us if we forget or make a mistake. Our Lord, and lay not upon us a burden like that which You laid upon those before us. Our Lord, and burden us not with that which we have no ability to bear. And pardon us; and forgive us; and have mercy upon us. You are our protector, so give us victory over the disbelieving people."',
    ),
    QuranVerseItem(
      id: '2_152',
      title: 'Al-Baqarah 2:152',
      surah: 2,
      ayah: 152,
      arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
      transliteration: 'Fadhkurūnī adhkurkum washkurū lī wa lā takfurūn',
      english:
          'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
    ),
    QuranVerseItem(
      id: '39_53',
      title: 'Az-Zumar 39:53',
      surah: 39,
      ayah: 53,
      arabic:
          'قُلْ يَا عِبَادِي الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا ۚ إِنَّهُ هُوَ الْغَفُورُ الرَّحِيمُ',
      transliteration:
          'Qul yā \'ibādī alladhīna asrafū \'alá anfusihim lā taqnaṭū min raḥmatillāh…',
      english:
          'Say, "O My servants who have transgressed against themselves [by sinning], do not despair of the mercy of Allah. Indeed, Allah forgives all sins. Indeed, it is He who is the Forgiving, the Merciful."',
    ),
    QuranVerseItem(
      id: '94_5',
      title: 'Ash-Sharh 94:5–6',
      surah: 94,
      ayah: 5,
      arabic:
          'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾ إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      transliteration: 'Fa-inna ma\'al \'usri yusrā • Inna ma\'al \'usri yusrā',
      english:
          'For indeed, with hardship [will be] ease. Indeed, with hardship [will be] ease.',
    ),
    QuranVerseItem(
      id: '3_139',
      title: 'Al \'Imran 3:139',
      surah: 3,
      ayah: 139,
      arabic:
          'وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنتُمُ الْأَعْلَوْنَ إِن كُنتُم مُّؤْمِنِينَ',
      transliteration:
          'Wa lā tahinū wa lā taḥzanū wa antumu l-a\'lawna in kuntum mu\'minīn',
      english:
          'So do not weaken and do not grieve, and you will be superior if you are [true] believers.',
    ),
  ];
}
