import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sabr_space/features/journal/data/models/journal_entry.dart';
import 'package:sabr_space/features/journal/data/services/journal_storage_service.dart';

/// Singleton provider for the [JournalStorageService].
final journalStorageProvider = Provider<JournalStorageService>((ref) {
  return JournalStorageService();
});

/// Notifier that manages the reactive list of journal entries.
class JournalEntriesNotifier extends Notifier<List<JournalEntry>> {
  late JournalStorageService _storage;
  bool _initialized = false;

  @override
  List<JournalEntry> build() {
    _storage = ref.watch(journalStorageProvider);
    return [];
  }

  /// Load entries from Hive. Call once on first access.
  Future<void> loadEntries() async {
    if (_initialized) return;
    await _storage.init();
    state = _storage.getAllEntries();
    _initialized = true;
  }

  /// Add a new entry and refresh state.
  Future<void> addEntry(JournalEntry entry) async {
    await _storage.saveEntry(entry);
    state = _storage.getAllEntries();
  }

  /// Update content of an existing entry.
  Future<void> updateContent(String id, String newContent) async {
    await _storage.updateContent(id, newContent);
    state = _storage.getAllEntries();
  }

  /// Delete an entry and refresh state.
  Future<void> deleteEntry(String id) async {
    await _storage.deleteEntry(id);
    state = _storage.getAllEntries();
  }
}

/// Provider for the reactive list of journal entries.
final journalEntriesProvider =
    NotifierProvider<JournalEntriesNotifier, List<JournalEntry>>(
  JournalEntriesNotifier.new,
);
