import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class TagAreaDropdown extends StatelessWidget {
  const TagAreaDropdown({super.key, this.currentTagArea, required this.onChanged});

  final TagAreaEnum? currentTagArea;
  final void Function(TagAreaEnum) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButton<TagAreaEnum>(
        value: currentTagArea,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 8,
        underline: Container(color: Colors.transparent),
        onChanged: (TagAreaEnum? selectVal) {
          if (selectVal != null) {
            onChanged(selectVal);
          }
        },
        items: TagAreaEnum.values.map((e) {
          return DropdownMenuItem<TagAreaEnum>(
            value: e,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppText.normal(e.name),
            ),
          );
        }).toList(),
      ),
    );
  }
}
