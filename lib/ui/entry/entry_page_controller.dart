import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';

part 'entry_page_controller.g.dart';

@riverpod
class EntryPageController extends _$EntryPageController {
  @override
  void build() {}

  String? getThumbnailUrl(int? tagId) {
    if (tagId != null) {
      return ref.read(tagNotifierProvider.notifier).getTag(tagId)?.thumbnailUrl;
    } else {
      return null;
    }
  }

  List<Tag> getTags(List<int> tagIds) {
    return ref.read(tagNotifierProvider.notifier).getTags(ids: tagIds);
  }

  Future<void> delete() async {
    // TODO
  }
}

final selectEntryStateProvider = StateProvider<Entry?>((ref) => null);
