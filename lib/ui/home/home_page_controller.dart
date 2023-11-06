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

  void selectFilterTag(int id, bool isSelect) {
    final tmp = ref.read(homePageFilterTagIdsStateProvider);
    if (isSelect && !tmp.contains(id)) {
      tmp.add(id);
    } else {
      tmp.remove(id);
    }
    ref.read(homePageFilterTagIdsStateProvider.notifier).state = [...tmp];
  }
}

final homePageShowEntriesProvider = Provider((ref) {
  final entries = ref.watch(entryNotifierProvider);
  final isDescSort = ref.watch(homePageIsUpdateAtDescStateProvider);
  // TODO キーワード検索
  // TODO タグ絞り込み
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
