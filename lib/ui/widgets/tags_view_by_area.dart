import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/tag_chip.dart';

class TagsViewByArea extends ConsumerWidget {
  const TagsViewByArea(this.tagArea, {super.key, this.selectTagIds, required this.onSelected});

  final TagAreaEnum tagArea;
  final List<int>? selectTagIds;
  final void Function(Tag, bool) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsByAreaProvider(tagArea));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(tagArea.name, color: Colors.grey, isBold: true),
        const Divider(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((e) {
            return TagChip(
              tag: e,
              isSelected: (selectTagIds == null) ? true : selectTagIds!.contains(e.id),
              onSelected: (bool isSelect) => onSelected(e, isSelect),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
