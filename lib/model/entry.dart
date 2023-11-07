import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/repository/entry_repository.dart';

final entryNotifierProvider = NotifierProvider<EntryNotifier, List<Entry>>(EntryNotifier.new);

class EntryNotifier extends Notifier<List<Entry>> {
  @override
  List<Entry> build() {
    return [];
  }

  Future<void> onLoad() async {
    state = await ref.read(entryRepositoryProvider).findAll();
  }

  Future<int> refreshCount() async {
    return await ref.read(entryRepositoryProvider).findRefreshCount();
  }

  Future<void> refresh() async {
    await ref.read(entryRepositoryProvider).refresh();
    await onLoad();
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
  final int mainTagId;
  final List<int> tagIds;
  final String note;
  final DateTime createAt;
  final DateTime updateAt;

  bool containKeyword(String word) {
    if (word.isEmpty) {
      return true;
    }
    return title.contains(word) || note.contains(word);
  }

  bool containTagIds(List<int> filterTagIds) {
    if (filterTagIds.isEmpty) {
      return true;
    }
    final tagIdWithMain = mergeMainAndSubTagIds();
    return filterTagIds.every(tagIdWithMain.contains);
  }

  List<int> mergeMainAndSubTagIds() {
    final tmp = tagIds;
    if (!tmp.contains(mainTagId)) {
      tmp.add(mainTagId);
    }
    tmp.sort();
    return tmp;
  }
}
