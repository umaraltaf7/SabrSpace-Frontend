/// Arguments for [MoodQuotesCarouselScreen] — which English quote set to show.
class MoodQuotesArgs {
  const MoodQuotesArgs({required this.isPositiveMood});

  /// True when user checked in as feeling good; false for "not good".
  final bool isPositiveMood;

  static const MoodQuotesArgs defaultPositive = MoodQuotesArgs(isPositiveMood: true);
}
