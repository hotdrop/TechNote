import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/entry.dart';

part 'home_page_controller.g.dart';

@riverpod
class HomePageController extends _$HomePageController {
  @override
  void build() {}

  void changeUpdateAtSort() {
    final current = ref.read(homePageIsUpdateAtDescStateProvider);
    ref.read(homePageIsUpdateAtDescStateProvider.notifier).state = !current;
  }

  void selectFilterTag(String id, bool isSelect) {
    final selectTagIds = Set<String>.from(ref.read(homePageFilterTagIdsStateProvider));
    if (isSelect) {
      selectTagIds.add(id);
    } else {
      selectTagIds.remove(id);
    }
    ref.read(homePageFilterTagIdsStateProvider.notifier).state = selectTagIds.toList();
  }

  void inputKeyword(String word) {
    ref.read(homePageSearchWordStateProvider.notifier).state = word;
  }
}

final homePageShowEntriesProvider = Provider((ref) {
  final entries = ref.watch(entryNotifierProvider);
  final keyword = ref.watch(homePageSearchWordStateProvider);
  final filterTagIds = ref.watch(homePageFilterTagIdsStateProvider);
  final isDescSort = ref.watch(homePageIsUpdateAtDescStateProvider);

  final filteredEntries = entries //
      .where((e) => e.containKeyword(keyword) && e.containTagIds(filterTagIds))
      .toList()
    ..sort((a, b) => isDescSort ? b.updateAt.compareTo(a.updateAt) : a.updateAt.compareTo(b.updateAt));

  return filteredEntries;
});

final homePageSearchWordStateProvider = StateProvider<String>((_) => '');

final homePageFilterTagIdsStateProvider = StateProvider<List<String>>((_) => []);

final homePageIsUpdateAtDescStateProvider = StateProvider<bool>((_) => true);
