import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/repository/local/entry_dao.dart';
import 'package:tech_note/repository/local/shared_prefs.dart';
import 'package:tech_note/repository/remote/entry_api.dart';

final entryRepositoryProvider = Provider((ref) => EntryRepository(ref));

class EntryRepository {
  const EntryRepository(this._ref);

  final Ref _ref;

  Future<List<Entry>> findAll() async {
    return await _ref.read(entryDaoProvider).findAll();
  }

  Future<int> getRefreshCount() async {
    final lastUpdateAt = await _ref.read(sharedPrefsProvider).getLastRefreshEntryDateTime();
    return _ref.read(entryApiProvider).getUpdateCount(lastUpdateAt);
  }

  Future<void> refresh() async {
    final lastUpdateAt = await _ref.read(sharedPrefsProvider).getLastRefreshEntryDateTime();
    final entries = await _ref.read(entryApiProvider).findEntires(lastUpdateAt);

    await _ref.read(entryDaoProvider).refresh(entries);
    await _ref.read(sharedPrefsProvider).saveLastRefreshEntryDateTime(DateTime.now());
  }

  Future<Entry> save(Entry entry) async {
    final id = await _ref.read(entryApiProvider).save(entry);
    final newEntry = entry.copyId(id);
    await _ref.read(entryDaoProvider).save(newEntry);
    return entry;
  }

  Future<void> delete(Entry entry) async {
    await _ref.read(entryApiProvider).delete(entry);
    await _ref.read(entryDaoProvider).delete(entry);
  }

  Future<DateTime?> getLastUpdateDate() async {
    return _ref.read(sharedPrefsProvider).getLastRefreshEntryDateTime();
  }
}
