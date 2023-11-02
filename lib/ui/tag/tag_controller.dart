import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/tag.dart';

part 'tag_controller.g.dart';

@riverpod
class TagController extends _$TagController {
  @override
  void build() {
    // TODO ここでタグ一覧を取得してくる
  }

  void selectTag(Tag? tag) {
    ref.read(tagPageSelectProvider.notifier).state = tag;
  }
}

// 一覧で選択したタグをここに設定する
final tagPageSelectProvider = StateProvider<Tag?>((ref) => null);
