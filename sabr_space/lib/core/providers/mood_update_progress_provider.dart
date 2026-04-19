import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kJournal = 'mood_update_task_journal';
const _kVisualize = 'mood_update_task_visualize';
const _kBreathe = 'mood_update_task_breathe';
const _kDailyStreakDays = 'mood_meter_daily_streak_days';
const _kLastStreakAwardDay = 'mood_meter_last_streak_award_day';

/// Tracks completion of the three “mood update” paths (journal, visualize, breathe)
/// for the profile mood meter. Persisted in [SharedPreferences].
class MoodUpdateTasks {
  const MoodUpdateTasks({
    required this.journalDone,
    required this.visualizeDone,
    required this.breatheDone,
  });

  final bool journalDone;
  final bool visualizeDone;
  final bool breatheDone;

  int get completedCount =>
      (journalDone ? 1 : 0) + (visualizeDone ? 1 : 0) + (breatheDone ? 1 : 0);

  /// 0.0 … 1.0 — each task adds one third.
  double get calmnessFraction => completedCount / 3.0;

  static Future<MoodUpdateTasks> load(SharedPreferences prefs) async {
    return MoodUpdateTasks(
      journalDone: prefs.getBool(_kJournal) ?? false,
      visualizeDone: prefs.getBool(_kVisualize) ?? false,
      breatheDone: prefs.getBool(_kBreathe) ?? false,
    );
  }
}

/// Tasks progress + daily streak (incremented when all three tasks are done in a day).
class MoodMeterState {
  const MoodMeterState({
    required this.tasks,
    required this.dailyStreakDays,
    required this.lastStreakAwardDay,
  });

  final MoodUpdateTasks tasks;
  final int dailyStreakDays;

  /// Calendar key (`yyyy-MM-dd`) when the daily streak was last credited, or null.
  final String? lastStreakAwardDay;

  static Future<MoodMeterState> load(SharedPreferences prefs) async {
    final tasks = await MoodUpdateTasks.load(prefs);
    final streak = prefs.getInt(_kDailyStreakDays) ?? 0;
    final lastAward = prefs.getString(_kLastStreakAwardDay);
    return MoodMeterState(
      tasks: tasks,
      dailyStreakDays: streak,
      lastStreakAwardDay: lastAward,
    );
  }

  /// Streak was already credited today (all three tasks were completed).
  bool get creditedToday {
    final today = _calendarDayKey(DateTime.now());
    return lastStreakAwardDay == today;
  }

  /// Full bar after today’s three tasks are done; per-task flags may reset while streak stays credited.
  double get displayCalmnessFraction {
    if (creditedToday) return 1.0;
    return tasks.calmnessFraction;
  }
}

String _calendarDayKey(DateTime d) {
  return '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class MoodUpdateProgressNotifier extends AsyncNotifier<MoodMeterState> {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<MoodMeterState> build() async {
    final prefs = await _prefs;
    return MoodMeterState.load(prefs);
  }

  Future<void> _emitLatest() async {
    final prefs = await _prefs;
    state = AsyncData(await MoodMeterState.load(prefs));
  }

  /// When all three tasks are done: award +1 day streak (if not already credited today),
  /// then reset the three task flags for the next cycle.
  Future<void> _maybeAwardDailyStreak() async {
    final prefs = await _prefs;
    final tasks = await MoodUpdateTasks.load(prefs);

    if (tasks.completedCount < 3) {
      await _emitLatest();
      return;
    }

    final today = _calendarDayKey(DateTime.now());
    final lastAward = prefs.getString(_kLastStreakAwardDay);

    // Duplicate completion same calendar day — reset tasks without double-counting.
    if (lastAward == today) {
      await prefs.setBool(_kJournal, false);
      await prefs.setBool(_kVisualize, false);
      await prefs.setBool(_kBreathe, false);
      await _emitLatest();
      return;
    }

    final yesterday = _calendarDayKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final previous = prefs.getInt(_kDailyStreakDays) ?? 0;

    final int newStreak;
    if (lastAward == null || lastAward.isEmpty) {
      newStreak = 1;
    } else if (lastAward == yesterday) {
      newStreak = previous + 1;
    } else {
      newStreak = 1;
    }

    await prefs.setInt(_kDailyStreakDays, newStreak);
    await prefs.setString(_kLastStreakAwardDay, today);

    await prefs.setBool(_kJournal, false);
    await prefs.setBool(_kVisualize, false);
    await prefs.setBool(_kBreathe, false);

    await _emitLatest();
  }

  Future<void> completeJournal() async {
    final prefs = await _prefs;
    final current = await MoodUpdateTasks.load(prefs);
    if (current.journalDone) return;
    await prefs.setBool(_kJournal, true);
    await _maybeAwardDailyStreak();
  }

  Future<void> completeVisualize() async {
    final prefs = await _prefs;
    final current = await MoodUpdateTasks.load(prefs);
    if (current.visualizeDone) return;
    await prefs.setBool(_kVisualize, true);
    await _maybeAwardDailyStreak();
  }

  Future<void> completeBreathe() async {
    final prefs = await _prefs;
    final current = await MoodUpdateTasks.load(prefs);
    if (current.breatheDone) return;
    await prefs.setBool(_kBreathe, true);
    await _maybeAwardDailyStreak();
  }
}

final moodUpdateProgressProvider =
    AsyncNotifierProvider<MoodUpdateProgressNotifier, MoodMeterState>(
  MoodUpdateProgressNotifier.new,
);
