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
    final entry = ref.read(selectEntryStateProvider);
    if (entry != null) {
      await ref.read(entryNotifierProvider.notifier).delete(entry);
    }
  }

  void inputTitle(String newVal) {
    ref.read(_editUiStateProvider.notifier).update((state) => state.copyWith(inputTitle: newVal));
  }

  void inputUrl(String? newVal) {
    ref.read(_editUiStateProvider.notifier).update((state) => state.copyWith(inputUrl: newVal));
  }

  void selectMainTag(int tagId) {
    ref.read(_editUiStateProvider.notifier).update((state) => state.copyMainTagId(tagId));
  }

  void selectTag(int id, bool isSelect) {
    final selectTagIds = Set<int>.from(ref.read(_editUiStateProvider).tagIds);
    if (isSelect) {
      selectTagIds.add(id);
    } else {
      selectTagIds.remove(id);
    }
    ref.read(_editUiStateProvider.notifier).update((state) => state.copyWith(tagIds: selectTagIds.toList()));
  }

  void inputNote(String newVal) {
    ref.read(_editUiStateProvider.notifier).update((state) => state.copyWith(inputNote: newVal));
  }

  Future<void> edit() async {
    final uiState = ref.read(_editUiStateProvider);
    if (uiState.originalEntry != null) {
      // TODO 既存Entryのアップデート
    } else {
      // TODO 新規登録
    }
  }
}

final selectEntryStateProvider = StateProvider<Entry?>((ref) => null);

final _editUiStateProvider = StateProvider((ref) {
  final selectEntry = ref.watch(selectEntryStateProvider);
  return (selectEntry != null) ? _EditUiState.createFromEntry(selectEntry) : _EditUiState.create();
});

class _EditUiState {
  _EditUiState._({
    required this.inputTitle,
    required this.inputUrl,
    required this.mainTagId,
    required this.tagIds,
    required this.inputNote,
    required this.originalEntry,
  });

  final String inputTitle;
  final String? inputUrl;
  final int? mainTagId;
  final List<int> tagIds;
  final String inputNote;
  final Entry? originalEntry;

  factory _EditUiState.create() {
    return _EditUiState._(
      inputTitle: '',
      inputUrl: null,
      mainTagId: null,
      tagIds: [],
      inputNote: '',
      originalEntry: null,
    );
  }

  factory _EditUiState.createFromEntry(Entry entry) {
    return _EditUiState._(
      inputTitle: entry.title,
      inputUrl: entry.url,
      mainTagId: entry.mainTagId,
      tagIds: entry.tagIds,
      inputNote: entry.note,
      originalEntry: entry,
    );
  }

  _EditUiState copyMainTagId(int? newId) {
    return _EditUiState._(
      inputTitle: inputTitle,
      inputUrl: inputUrl,
      mainTagId: newId,
      tagIds: tagIds,
      inputNote: inputNote,
      originalEntry: originalEntry,
    );
  }

  _EditUiState copyWith({
    String? inputTitle,
    String? inputUrl,
    List<int>? tagIds,
    String? inputNote,
  }) {
    return _EditUiState._(
      inputTitle: inputTitle ?? this.inputTitle,
      inputUrl: inputUrl ?? this.inputUrl,
      mainTagId: mainTagId,
      tagIds: tagIds ?? this.tagIds,
      inputNote: inputNote ?? this.inputNote,
      originalEntry: originalEntry,
    );
  }
}

final entryEditPageTitleProvider = Provider<String>((ref) {
  return ref.watch(_editUiStateProvider.select((value) => value.inputTitle));
});

final entryEditPageUrlProvider = Provider<String?>((ref) {
  return ref.watch(_editUiStateProvider.select((value) => value.inputUrl));
});

final entryEditPageSelectTagIdsProvider = Provider<List<int>>((ref) {
  return ref.watch(_editUiStateProvider.select((value) => value.tagIds));
});

final entryEditPageSelectTagsProvider = Provider<List<Tag>>((ref) {
  final selectTagIds = ref.watch(_editUiStateProvider.select((value) => value.tagIds));
  return ref.read(tagNotifierProvider.notifier).getTags(ids: selectTagIds);
});

final entryEditPageSelectMainTagProvider = Provider<int?>((ref) {
  return ref.watch(_editUiStateProvider.select((value) => value.mainTagId));
});

final entryEditPageNoteProvider = Provider<String>((ref) {
  return ref.watch(_editUiStateProvider.select((value) => value.inputNote));
});

final entryEditPagePreparedSaveProvider = Provider<bool>((ref) {
  final inputTitle = ref.watch(_editUiStateProvider.select((value) => value.inputTitle));
  final selectTagIds = ref.watch(_editUiStateProvider.select((value) => value.tagIds));
  final inputNote = ref.watch(_editUiStateProvider.select((value) => value.inputNote));
  return inputTitle.isNotEmpty && selectTagIds.isNotEmpty && inputNote.isNotEmpty;
});
