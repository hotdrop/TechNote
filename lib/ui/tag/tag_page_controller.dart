import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';

part 'tag_page_controller.g.dart';

@riverpod
class TagPageController extends _$TagPageController {
  @override
  void build() {}

  void selectTag(Tag? tag) {
    ref.read(tagPageSelectTagProvider.notifier).state = tag;
  }

  void inputImageByte(Uint8List newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputImageBytes: newVal));
  }

  void inputColor(Color newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputColor: newVal));
  }

  void inputTagName(String newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputName: newVal));
  }

  void inputIsTextColorBlack(bool newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputIsTextColorBlack: newVal));
  }

  void inputTagArea(TagAreaEnum newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(inputTagArea: newVal));
  }

  Future<void> save() async {
    final selectTag = ref.read(tagPageSelectTagProvider);
    final tag = Tag(
      id: (selectTag != null) ? selectTag.id : Tag.noneTagId,
      name: ref.read(tagEditNameProvider),
      color: ref.read(tagEditColorProvider),
      isTextColorBlack: ref.read(tagEditIsTextColorBlackProvider),
      tagArea: ref.read(tagEditSelectTagAreaProvider)!,
      thumbnailUrl: (selectTag != null) ? selectTag.thumbnailUrl : null,
    );
    await ref.read(tagNotifierProvider.notifier).save(tag, ref.read(tagEditImageByteProvider));
  }

  void clear() {
    ref.read(tagPageSelectTagProvider.notifier).state = null;
  }
}

final tagPageSelectTagProvider = StateProvider<Tag?>((ref) => null);

final _uiStateProvider = StateProvider<_EditDialogUiState>((ref) {
  final tag = ref.watch(tagPageSelectTagProvider);
  return (tag == null) ? _EditDialogUiState.create() : _EditDialogUiState.createFromTag(tag);
});

class _EditDialogUiState {
  _EditDialogUiState._({
    required this.inputName,
    required this.inputColor,
    required this.inputIsTextColorBlack,
    required this.inputTagArea,
    required this.inputImageBytes,
  });

  final String inputName;
  final Color inputColor;
  final bool inputIsTextColorBlack;
  final TagAreaEnum? inputTagArea;
  final Uint8List? inputImageBytes;

  factory _EditDialogUiState.create() {
    return _EditDialogUiState._(
      inputName: '',
      inputColor: AppTheme.defaultTagColor,
      inputIsTextColorBlack: true,
      inputTagArea: null,
      inputImageBytes: null,
    );
  }

  factory _EditDialogUiState.createFromTag(Tag tag) {
    return _EditDialogUiState._(
      inputName: tag.name,
      inputColor: tag.color,
      inputIsTextColorBlack: tag.isTextColorBlack,
      inputTagArea: tag.tagArea,
      inputImageBytes: null,
    );
  }

  _EditDialogUiState copyWith({
    String? inputName,
    Color? inputColor,
    bool? inputIsTextColorBlack,
    TagAreaEnum? inputTagArea,
    Uint8List? inputImageBytes,
  }) {
    return _EditDialogUiState._(
      inputName: inputName ?? this.inputName,
      inputColor: inputColor ?? this.inputColor,
      inputIsTextColorBlack: inputIsTextColorBlack ?? this.inputIsTextColorBlack,
      inputTagArea: inputTagArea ?? this.inputTagArea,
      inputImageBytes: inputImageBytes ?? this.inputImageBytes,
    );
  }
}

final tagEditNameProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputName));
});

final tagEditColorProvider = Provider<Color>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputColor));
});

final tagEditImageByteProvider = Provider<Uint8List?>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputImageBytes));
});

final tagEditIsTextColorBlackProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputIsTextColorBlack));
});

final tagEditSelectTagAreaProvider = Provider<TagAreaEnum?>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputTagArea));
});

final tagEditPreparedSaveProvider = Provider<bool>((ref) {
  final tagName = ref.watch(tagEditNameProvider);
  final tagArea = ref.watch(tagEditSelectTagAreaProvider);
  return tagName.isNotEmpty && tagArea != null;
});
