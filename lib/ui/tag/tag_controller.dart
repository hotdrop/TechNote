import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/tag.dart';

part 'tag_controller.g.dart';

@riverpod
class TagController extends _$TagController {
  @override
  Future<void> build() async {
    await ref.read(tagNotifierProvider.notifier).onLoad();
  }

  void selectTag(Tag? tag) {
    ref.read(tagPageSelectProvider.notifier).state = tag;
  }
}

// 一覧画面で選択したタグをここに設定する
final tagPageSelectProvider = StateProvider<Tag?>((ref) => null);
