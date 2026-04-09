import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

/// Available mood tags for journal entries.
@HiveType(typeId: 1)
enum JournalMood {
  @HiveField(0)
  gratitude,

  @HiveField(1)
  anxiety,

  @HiveField(2)
  reflection,

  @HiveField(3)
  dua,

  @HiveField(4)
  peace,

  @HiveField(5)
  sadness;

  /// Human-readable label.
  String get label {
    switch (this) {
      case JournalMood.gratitude:
        return 'Gratitude';
      case JournalMood.anxiety:
        return 'Anxiety';
      case JournalMood.reflection:
        return 'Reflection';
      case JournalMood.dua:
        return 'Dua';
      case JournalMood.peace:
        return 'Peace';
      case JournalMood.sadness:
        return 'Sadness';
    }
  }

  /// Emoji icon for visual display.
  String get emoji {
    switch (this) {
      case JournalMood.gratitude:
        return '🤲';
      case JournalMood.anxiety:
        return '😔';
      case JournalMood.reflection:
        return '🪞';
      case JournalMood.dua:
        return '🤲';
      case JournalMood.peace:
        return '☮️';
      case JournalMood.sadness:
        return '💧';
    }
  }
}

/// A single journal entry stored locally via Hive.
@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  JournalEntry({
    required this.id,
    required this.content,
    required this.entryDate,
    required this.createdAt,
    required this.moods,
    this.prompt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  String content;

  /// The date the user selected (possibly back-dated).
  @HiveField(2)
  final DateTime entryDate;

  /// Actual creation timestamp.
  @HiveField(3)
  final DateTime createdAt;

  /// Mood tags the user selected.
  @HiveField(4)
  final List<JournalMood> moods;

  /// The Islamic prompt that was shown (nullable if user skipped).
  @HiveField(5)
  String? prompt;

  /// Preview text: first two lines or 120 chars.
  String get preview {
    final cleaned = content.trim();
    if (cleaned.isEmpty) return 'No content';
    final lines = cleaned.split('\n');
    final twoLines = lines.take(2).join(' ');
    return twoLines.length > 120 ? '${twoLines.substring(0, 120)}…' : twoLines;
  }
}
