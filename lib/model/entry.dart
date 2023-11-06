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
}