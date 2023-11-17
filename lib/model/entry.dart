import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tech_note/repository/entry_repository.dart';

final entryNotifierProvider = NotifierProvider<EntryNotifier, List<Entry>>(EntryNotifier.new);

class EntryNotifier extends Notifier<List<Entry>> {
  @override
  List<Entry> build() {
    return [];
  }

  Future<void> onLoad() async {
    state = await ref.read(entryRepositoryProvider).findAll();
    final dt = await ref.read(entryRepositoryProvider).getLastUpdateDate();
    ref.read(lastUpdateEntryDateTimeProvider.notifier).state = dt;
  }

  Future<int> refreshCount() async {
    return await ref.read(entryRepositoryProvider).findRefreshCount();
  }

  Future<void> refresh() async {
    await ref.read(entryRepositoryProvider).refresh();
    await onLoad();
  }

  Future<void> delete(Entry target) async {
    await ref.read(entryRepositoryProvider).delete(target);
    state = List.from(state)..remove(target);
  }

  Future<void> save(Entry target) async {
    final newEntry = await ref.read(entryRepositoryProvider).save(target);
    if (target.isUnregistered()) {
      state = [...state, newEntry];
    } else {
      final idx = state.indexWhere((t) => t.id == newEntry.id);
      final newEntries = state;
      newEntries[idx] = newEntry;
      state = [...newEntries];
    }
  }
}

class Entry {
  Entry({
    required this.id,
    required this.title,
    required this.url,
    required this.mainTagId,
    required this.tagIds,
    required this.note,
    required this.createAt,
    required this.updateAt,
  });

  final String id;
  final String title;
  final String? url;
  final String mainTagId;
  final List<String> tagIds;
  final String note;
  final DateTime createAt;
  final DateTime updateAt;

  static const noneEntryId = '';
  static final dateFormat = DateFormat('yyyy/MM/dd');
  static const maxAttachTagCount = 5;

  bool containKeyword(String word) {
    if (word.isEmpty) {
      return true;
    }
    return title.contains(word) || note.contains(word);
  }

  bool containTagIds(List<String> filterTagIds) {
    if (filterTagIds.isEmpty) {
      return true;
    }
    return filterTagIds.every(tagIds.contains);
  }

  bool isUnregistered() {
    return id == noneEntryId;
  }
}

final lastUpdateEntryDateTimeProvider = StateProvider<DateTime?>((ref) => null);
