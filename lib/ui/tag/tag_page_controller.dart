import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/tag.dart';

part 'tag_page_controller.g.dart';

@riverpod
class TagPageController extends _$TagPageController {
  @override
  void build() {}

  void selectTag(Tag? tag) {
    ref.read(tagPageSelectProvider.notifier).state = tag;
  }
}

// 一覧画面で選択したタグをここに設定する
final tagPageSelectProvider = StateProvider<Tag?>((ref) => null);
