import 'dart:math' as math;

/// Islamic reflection prompts shown at the top of each journal entry.
///
/// One prompt is selected per entry based on a daily rotation or random pick.
class JournalPrompts {
  JournalPrompts._();

  static const List<String> prompts = [
    'What is one thing you are grateful to Allah for today?',
    'Where did you feel Allah\'s presence this week?',
    'What is weighing on your heart right now?',
    'What dua is in your heart today?',
    'How did you practice sabr (patience) recently?',
    'What moment today reminded you of Allah\'s mercy?',
    'Is there someone you need to forgive? Reflect on letting go.',
    'What blessing have you overlooked recently?',
    'How can you be more present in your salah tomorrow?',
    'What lesson has your struggle taught you?',
    'Write a letter to your future self. What would you say?',
    'What does "trust in Allah\'s plan" mean to you right now?',
    'Describe a moment of peace you experienced today.',
    'What fear is holding you back from growing?',
    'How has your relationship with Allah changed this month?',
    'What act of kindness can you do tomorrow?',
    'Reflect on a hardship that later became a blessing.',
    'What does your heart need to hear right now?',
    'Who in your life are you most grateful for and why?',
    'What would your life look like if you truly let go of worry?',
  ];

  /// Get today's prompt (rotates daily by day-of-year).
  static String todayPrompt() {
    final dayOfYear = _dayOfYear(DateTime.now());
    return prompts[dayOfYear % prompts.length];
  }

  /// Get a random prompt.
  static String randomPrompt() {
    return prompts[math.Random().nextInt(prompts.length)];
  }

  /// Get a prompt by index (wraps around).
  static String promptAt(int index) {
    return prompts[index % prompts.length];
  }

  static int _dayOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    return date.difference(startOfYear).inDays;
  }
}
