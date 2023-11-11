import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/tags_view_by_area.dart';

class TagsBottomSheet extends StatelessWidget {
  const TagsBottomSheet({super.key, required this.selectTagIds, required this.onSelected});

  final List<int> selectTagIds;
  final void Function(Tag, bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: TagAreaEnum.values.map((area) {
            return TagsViewByArea(
              area,
              selectTagIds: selectTagIds,
              onSelected: onSelected,
            );
          }).toList(),
        ),
      ),
    );
  }
}
