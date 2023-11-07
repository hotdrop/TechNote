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
    final tmp = ref.read(homePageFilterTagIdsStateProvider);
    if (isSelect && !tmp.contains(id)) {
      tmp.add(id);
    } else {
      tmp.remove(id);
    }
    ref.read(homePageFilterTagIdsStateProvider.notifier).state = [...tmp];
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

  // 絞り込みとソート
  final filteredEntries = entries //
      .where((e) => e.containKeyword(keyword) && e.containTagIds(filterTagIds))
      .toList()
    ..sort((a, b) => isDescSort ? b.updateAt.compareTo(a.updateAt) : a.updateAt.compareTo(b.updateAt));

  return filteredEntries;
});

// 検索キーワード
final homePageSearchWordStateProvider = StateProvider<String>((_) => '');

// 絞り込みで指定したタグID
final homePageFilterTagIdsStateProvider = StateProvider<List<int>>((_) => []);

// 更新日の降順・昇順
final homePageIsUpdateAtDescStateProvider = StateProvider<bool>((_) => true);

// 更新件数カウント
final homePageUpdateCountByRefreshProvider = FutureProvider<(int, int)>((ref) async {
  final results = await Future.wait<int>([
    ref.read(entryNotifierProvider.notifier).refreshCount(),
    ref.read(tagNotifierProvider.notifier).refreshCount(),
  ]);
  return (results[0], results[1]);
});
