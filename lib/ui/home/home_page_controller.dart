import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';

part 'home_page_controller.g.dart';

@riverpod
class HomePageController extends _$HomePageController {
  @override
  void build() {}

  void changeUpdateAtSort() {
    final current = ref.read(homePageIsUpdateAtDescStateProvider);
    ref.read(homePageIsUpdateAtDescStateProvider.notifier).state = !current;
  }

  void selectFilterTag(int id, bool isSelect) {
    final selectTagIds = Set<int>.from(ref.read(homePageFilterTagIdsStateProvider));
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

  Future<void> refresh() async {
    await Future.wait([
      ref.read(entryNotifierProvider.notifier).refresh(),
      ref.read(tagNotifierProvider.notifier).refresh(),
    ]);
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

final homePageFilterTagIdsStateProvider = StateProvider<List<int>>((_) => []);

final homePageIsUpdateAtDescStateProvider = StateProvider<bool>((_) => true);

final homePageUpdateCountByRefreshProvider = FutureProvider<(int, int)>((ref) async {
  final results = await Future.wait<int>([
    ref.read(entryNotifierProvider.notifier).refreshCount(),
    ref.read(tagNotifierProvider.notifier).refreshCount(),
  ]);
  return (results[0], results[1]);
});
