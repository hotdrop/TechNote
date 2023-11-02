import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class TagPreviewChip extends StatelessWidget {
  const TagPreviewChip({super.key, required this.name, this.url, this.imageByteData, required this.tagColor, required this.isTextColorBlack});

  final String name;
  final String? url;
  final Uint8List? imageByteData;
  final Color tagColor;
  final bool isTextColorBlack;

  factory TagPreviewChip.createFromTag(Tag tag) {
    return TagPreviewChip(name: tag.name, tagColor: tag.tagColor, url: tag.thumbnailUrl, isTextColorBlack: tag.isTextColorBlack);
  }

  @override
  Widget build(BuildContext context) {
    final label = (name.isEmpty) ? 'no name' : name;
    return ChoiceChip(
      avatar: _avatar(),
      label: AppText.normal(label, textColor: isTextColorBlack ? Colors.black : Colors.white),
      backgroundColor: Theme.of(context).disabledColor,
      selectedColor: tagColor,
      selected: true,
      onSelected: (value) {},
    );
  }

  Widget _avatar() {
    if (imageByteData != null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(imageByteData!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (url != null) {
      // TODO cacheイメージを使うURL
      return CircleAvatar(child: Image.network(url!));
    } else {
      return const CircleAvatar(child: Icon(Tag.defaultIcon));
    }
  }

  TagPreviewChip copy({
    String? name,
    Uint8List? imageByteData,
    Color? tagColor,
    bool? isTextColorBlack,
  }) {
    return TagPreviewChip(
      name: name ?? this.name,
      tagColor: tagColor ?? this.tagColor,
      isTextColorBlack: isTextColorBlack ?? this.isTextColorBlack,
      imageByteData: imageByteData ?? this.imageByteData,
    );
  }
}
