import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/thumbnail_image.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag, required this.isSelected, required this.onSelected});

  final Tag tag;
  final bool isSelected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected
        ? tag.isTextColorBlack
            ? Colors.black
            : Colors.white
        : Colors.black;
    return ChoiceChip(
      avatar: ThumbnailImage.tag(imageUrl: tag.thumbnailUrl),
      label: AppText.normal(tag.name, color: textColor),
      backgroundColor: Theme.of(context).disabledColor,
      selectedColor: tag.color,
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
