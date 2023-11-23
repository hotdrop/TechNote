import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/repository/local/entity/entry_entity.dart';

final entryDaoProvider = Provider((ref) => const EntryDao());

class EntryDao {
  const EntryDao();

  Future<List<Entry>> findAll() async {
    final box = await Hive.openBox<EntryEntity>(EntryEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    final entities = box.values;
    return entities
        .map((e) => Entry(
              id: e.id,
              title: e.title,
              url: e.url,
              mainTagId: e.mainTagId,
              tagIds: e.tagIds,
              note: e.note,
              createAt: e.createAt,
              updateAt: e.updateAt,
            ))
        .toList();
  }

  Future<void> refresh(List<Entry> entries) async {
    final box = await Hive.openBox<EntryEntity>(EntryEntity.boxName);
    for (var entry in entries) {
      final newEntry = EntryEntity(
        id: entry.id,
        title: entry.title,
        url: entry.url,
        mainTagId: entry.mainTagId,
        tagIds: entry.tagIds,
        note: entry.note,
        createAt: entry.createAt,
        updateAt: entry.updateAt,
      );
      await box.put(entry.id, newEntry);
    }
  }

  Future<void> save(Entry entry) async {
    final entity = EntryEntity(
      id: entry.id,
      title: entry.title,
      url: entry.url,
      mainTagId: entry.mainTagId,
      tagIds: entry.tagIds,
      note: entry.note,
      createAt: entry.createAt,
      updateAt: entry.updateAt,
    );
    final box = await Hive.openBox<EntryEntity>(EntryEntity.boxName);
    await box.put(entity.id, entity);
  }

  Future<void> delete(Entry entry) async {
    final box = await Hive.openBox<EntryEntity>(EntryEntity.boxName);
    await box.delete(entry.id);
  }
}
