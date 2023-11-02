import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/tag_controller.dart';

part 'tag_edit_controller.g.dart';

@riverpod
class TagEditController extends _$TagEditController {
  @override
  void build() {}

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
    // TODO 登録処理を行う
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) {
  final tag = ref.watch(tagPageSelectProvider);
  return (tag == null) ? _UiState.create() : _UiState.createFromTag(tag);
});

class _UiState {
  _UiState._({
    required this.inputName,
    required this.inputColor,
    required this.inputIsTextColorBlack,
    required this.inputTagArea,
    required this.inputImageBytes,
    this.currentThumbnailUrl,
  });

  final String inputName;
  final Color inputColor;
  final bool inputIsTextColorBlack;
  final TagAreaEnum? inputTagArea;
  final Uint8List? inputImageBytes;
  final String? currentThumbnailUrl;

  factory _UiState.create() {
    return _UiState._(
      inputName: '',
      inputColor: AppTheme.defaultTagColor,
      inputIsTextColorBlack: true,
      inputTagArea: null,
      inputImageBytes: null,
    );
  }

  factory _UiState.createFromTag(Tag tag) {
    return _UiState._(
      inputName: tag.name,
      inputColor: tag.tagColor,
      inputIsTextColorBlack: tag.isTextColorBlack,
      inputTagArea: tag.tagArea,
      inputImageBytes: null,
      currentThumbnailUrl: tag.thumbnailUrl,
    );
  }

  _UiState copyWith({
    String? inputName,
    Color? inputColor,
    bool? inputIsTextColorBlack,
    TagAreaEnum? inputTagArea,
    Uint8List? inputImageBytes,
  }) {
    return _UiState._(
      inputName: inputName ?? this.inputName,
      inputColor: inputColor ?? this.inputColor,
      inputIsTextColorBlack: inputIsTextColorBlack ?? this.inputIsTextColorBlack,
      inputTagArea: inputTagArea ?? this.inputTagArea,
      inputImageBytes: inputImageBytes ?? this.inputImageBytes,
      currentThumbnailUrl: currentThumbnailUrl,
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
