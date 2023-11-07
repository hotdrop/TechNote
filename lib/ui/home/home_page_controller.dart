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

  Future<void> refresh() async {
    await Future.wait([
      ref.read(entryNotifierProvider.notifier).refresh(),
      ref.read(tagNotifierProvider.notifier).refresh(),
    ]);
  }
}

final homePageShowEntriesProvider = Provider((ref) {
  // TODO 表示数を絞った方がいいか・・？
  List<Entry> entries = ref.watch(entryNotifierProvider);
  final isDescSort = ref.watch(homePageIsUpdateAtDescStateProvider);

  // TODO キーワード検索

  // タグ絞り込み
  final filterTagIds = ref.watch(homePageFilterTagIdsStateProvider);
  entries = entries.where((e) => e.containTagIds(filterTagIds)).toList();

  // 更新日でのソート
  if (isDescSort) {
    entries.sort((a, b) => b.updateAt.compareTo(a.updateAt));
  } else {
    entries.sort((a, b) => a.updateAt.compareTo(b.updateAt));
  }
  return [...entries];
});

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
