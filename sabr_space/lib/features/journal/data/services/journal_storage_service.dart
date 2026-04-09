import 'package:hive/hive.dart';

import 'package:sabr_space/features/journal/data/models/journal_entry.dart';

/// Manages CRUD operations for [JournalEntry] using Hive local storage.
class JournalStorageService {
  static const String _boxName = 'journal_entries';

  Box<JournalEntry>? _box;

  /// Open the Hive box. Must be called before any read/write.
  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<JournalEntry>(_boxName);
  }

  Box<JournalEntry> get _safeBox {
    assert(_box != null && _box!.isOpen, 'Call init() before using storage.');
    return _box!;
  }

  /// Save a new entry or update an existing one (upsert by id).
  Future<void> saveEntry(JournalEntry entry) async {
    await _safeBox.put(entry.id, entry);
  }

  /// Get all entries sorted by entry date (newest first).
  List<JournalEntry> getAllEntries() {
    final entries = _safeBox.values.toList();
    entries.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    return entries;
  }

  /// Get a single entry by id.
  JournalEntry? getEntry(String id) {
    return _safeBox.get(id);
  }

  /// Delete an entry by id.
  Future<void> deleteEntry(String id) async {
    await _safeBox.delete(id);
  }

  /// Update an existing entry's content.
  Future<void> updateContent(String id, String newContent) async {
    final entry = _safeBox.get(id);
    if (entry != null) {
      entry.content = newContent;
      await entry.save();
    }
  }

  /// Number of saved entries.
  int get entryCount => _safeBox.length;
}
