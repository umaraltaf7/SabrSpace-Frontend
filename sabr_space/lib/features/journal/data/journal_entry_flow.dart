/// Unified journal entry flow: mood (step 1) + four writing prompts (steps 2–5).
abstract final class JournalEntryFlow {
  JournalEntryFlow._();

  static const int totalSteps = 5;

  /// Mood selection screen.
  static const int moodStep = 1;

  /// Maps zero-based writing step (0..3) to global step (2..5).
  static int globalStepForWritingIndex(int writingStepZeroBased) =>
      2 + writingStepZeroBased;
}
