import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag, required this.isSelected, required this.onSelected, this.imageByteData});

  final Tag tag;
  final Uint8List? imageByteData;
  final bool isSelected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container();
    // return ChoiceChip(
    //   avatar: Image.network(tag.thumbnailUrl),
    //   label: Text(tag.name),
    //   selectedColor: tag.color,
    //   backgroundColor: Theme.of(context).disabledColor,
    //   selected: true,
    //   onSelected: onSelected
    // );
  }
}
