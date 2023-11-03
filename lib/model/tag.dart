import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/repository/tag_repository.dart';

final tagNotifierProvider = NotifierProvider<TagNotifier, List<Tag>>(TagNotifier.new);

class TagNotifier extends Notifier<List<Tag>> {
  @override
  List<Tag> build() {
    return [];
  }

  Future<void> onLoad() async {
    state = await ref.read(tagRepositoryProvider).findAll();
  }

  Future<void> save(Tag tag) async {
    await ref.read(tagRepositoryProvider).save(tag);
    switch (tag) {
      case RegisteredTag():
        // TODO stateを置き換える
        break;
      case UnregisterdTag():
        // TODO stateに追加
        break;
    }
  }
}

sealed class Tag {
  Tag(this.name, this.tagColor, this.isTextColorBlack, this.tagArea);

  final String name;
  final Color tagColor;
  final bool isTextColorBlack;
  final TagAreaEnum tagArea;

  static const defaultIcon = Icons.label;
  static const noneId = '';

  String get id;
  String? get thumbnailUrl;

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  static Color hexToColor(String hexColor) {
    final String cleanedHex = hexColor.replaceAll('#', '');
    final int hexNumber = int.parse(cleanedHex, radix: 16);
    return Color(hexNumber).withOpacity(1.0);
  }
}

class RegisteredTag extends Tag {
  RegisteredTag({
    required String name,
    required Color tagColor,
    required bool isTextColorBlack,
    required TagAreaEnum tagArea,
    required this.tagId,
    required this.thumbnailImageUrl,
  }) : super(name, tagColor, isTextColorBlack, tagArea);

  final String tagId;
  final String? thumbnailImageUrl;

  @override
  String get id => tagId;

  @override
  String? get thumbnailUrl => thumbnailImageUrl;
}

class UnregisterdTag extends Tag {
  UnregisterdTag({
    required String name,
    required Color tagColor,
    required bool isTextColorBlack,
    required TagAreaEnum tagArea,
    this.imageBytes,
  }) : super(name, tagColor, isTextColorBlack, tagArea);

  final Uint8List? imageBytes;

  @override
  String get id => Tag.noneId;

  @override
  String? get thumbnailUrl => null;
}

enum TagAreaEnum {
  langAndFw('Language & Framework'),
  technique('Technique'),
  platform('Platform&Tool'),
  media('Media');

  final String name;

  const TagAreaEnum(this.name);

  // static TagArea toModel(int index) {
  //   // TODO
  // }
}
