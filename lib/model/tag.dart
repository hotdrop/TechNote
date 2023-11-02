import 'package:flutter/material.dart';

class Tag {
  Tag({required this.name, required this.thumbnailUrl, required this.tagColor, required this.isTextColorBlack, required this.tagArea});

  final String name;
  final String? thumbnailUrl;
  final Color tagColor;
  final bool isTextColorBlack;
  final TagAreaEnum tagArea;

  static const defaultIcon = Icons.label;
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
