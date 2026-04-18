import 'package:shared_preferences/shared_preferences.dart';

/// Local “Bravery Points” total for journal completions (premium-style gamification).
abstract final class JournalBraveryPoints {
  JournalBraveryPoints._();

  static const _key = 'journal_bravery_points_total';
  static const int pointsPerJournalEntry = 5;

  static Future<int> getTotal() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_key) ?? 0;
  }

  /// Adds [pointsPerJournalEntry] and returns the new total.
  static Future<int> addJournalCompletionReward() async {
    final p = await SharedPreferences.getInstance();
    final prev = p.getInt(_key) ?? 0;
    final next = prev + pointsPerJournalEntry;
    await p.setInt(_key, next);
    return next;
  }
}
