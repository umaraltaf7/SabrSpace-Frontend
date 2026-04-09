/// Arguments for [BreatheSessionScreen] from the breathe setup flow.
class BreatheSessionArgs {
  const BreatheSessionArgs({
    required this.durationMinutes,
    this.techniqueIndex = 0,
    this.pairWithDhikr = false,
  });

  /// Selected duration on the setup screen (2, 5, or 10).
  final int durationMinutes;

  /// Selected technique: 0 = box 4-4-4, 1 = 4-7-8, 2 = simple calm 5-5-5.
  final int techniqueIndex;

  /// When true, show dhikr phrases and allow cycling with "Change word".
  final bool pairWithDhikr;

  /// Default when opening the session without setup (e.g. mindfulness hub).
  static const BreatheSessionArgs defaultArgs = BreatheSessionArgs(
    durationMinutes: 5,
    techniqueIndex: 0,
    pairWithDhikr: false,
  );

  int get durationSeconds => durationMinutes * 60;

  /// Inhale, hold, exhale seconds per technique.
  (int inhale, int hold, int exhale) get breathPattern {
    switch (techniqueIndex.clamp(0, 2)) {
      case 0:
        return (4, 4, 4);
      case 1:
        return (4, 7, 8);
      case 2:
      default:
        return (5, 5, 5);
    }
  }
}
