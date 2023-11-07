import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/repository/tag_repository.dart';

final tagNotifierProvider = NotifierProvider<TagNotifier, List<Tag>>(TagNotifier.new);

// エリアごとのタグ情報が欲しい場合はこのProviderをwatchする
final tagsByAreaProvider = Provider.family((ref, TagAreaEnum tagArea) {
  return ref.watch(tagNotifierProvider).where((e) => e.tagArea == tagArea).toList();
});

class TagNotifier extends Notifier<List<Tag>> {
  @override
  List<Tag> build() {
    return [];
  }

  Future<void> onLoad() async {
    state = await ref.read(tagRepositoryProvider).findAll();
  }

  Future<int> refreshCount() async {
    return await ref.read(tagRepositoryProvider).findRefreshCount();
  }

  Future<void> refresh() async {
    await ref.read(tagRepositoryProvider).refresh();
    await onLoad();
  }

  List<Tag> getTags({required List<int> ids, int? maxLength}) {
    final results = state.where((tag) => ids.contains(tag.id)).toList();
    if (maxLength == null || results.length <= maxLength) {
      return results;
    }
    return results.getRange(0, maxLength).toList();
  }

  Tag? getTag(int id) {
    return state.where((tag) => tag.id == id).firstOrNull;
  }

  Future<void> save(Tag tag, Uint8List? imageBytes) async {
    await ref.read(tagRepositoryProvider).save(tag, imageBytes);
    if (tag.isUnregistered()) {
      state = [...state, tag];
    } else {
      final idx = state.indexWhere((t) => t.id == tag.id);
      final newTags = state;
      newTags[idx] = tag;
      state = [...newTags];
    }
  }
}

class Tag {
  Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.isTextColorBlack,
    required this.tagArea,
    this.thumbnailUrl,
  });

  static const defaultIcon = Icons.label;
  static const noneId = -1;

  final int id;
  final String name;
  final Color color;
  final bool isTextColorBlack;
  final TagAreaEnum tagArea;
  final String? thumbnailUrl;

  bool isUnregistered() {
    return id == noneId;
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  static Color hexToColor(String hexColor) {
    final String cleanedHex = hexColor.replaceAll('#', '');
    final int hexNumber = int.parse(cleanedHex, radix: 16);
    return Color(hexNumber).withOpacity(1.0);
  }
}

enum TagAreaEnum {
  langAndFw('Language & Framework'),
  technique('Technique'),
  platform('Platform&Tool'),
  media('Media');

  final String name;

  const TagAreaEnum(this.name);
}
