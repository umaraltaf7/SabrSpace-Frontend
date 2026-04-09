// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return JournalEntry(
      id: fields[0] as String,
      content: fields[1] as String,
      entryDate: fields[2] as DateTime,
      createdAt: fields[3] as DateTime,
      moods: (fields[4] as List).cast<JournalMood>(),
      prompt: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.entryDate)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.moods)
      ..writeByte(5)
      ..write(obj.prompt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JournalMoodAdapter extends TypeAdapter<JournalMood> {
  @override
  final int typeId = 1;

  @override
  JournalMood read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JournalMood.gratitude;
      case 1:
        return JournalMood.anxiety;
      case 2:
        return JournalMood.reflection;
      case 3:
        return JournalMood.dua;
      case 4:
        return JournalMood.peace;
      case 5:
        return JournalMood.sadness;
      default:
        return JournalMood.reflection;
    }
  }

  @override
  void write(BinaryWriter writer, JournalMood obj) {
    switch (obj) {
      case JournalMood.gratitude:
        writer.writeByte(0);
      case JournalMood.anxiety:
        writer.writeByte(1);
      case JournalMood.reflection:
        writer.writeByte(2);
      case JournalMood.dua:
        writer.writeByte(3);
      case JournalMood.peace:
        writer.writeByte(4);
      case JournalMood.sadness:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalMoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
