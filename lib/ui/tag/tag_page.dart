import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/tag_edit_dialog.dart';
import 'package:tech_note/ui/tag/tag_page_controller.dart';
import 'package:tech_note/ui/widgets/tags_view_by_area.dart';

class TagPage extends ConsumerWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTheme.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: TagAreaEnum.values.map((area) {
            return TagsViewByArea(
              area,
              onSelected: (tag, isSelect) {
                ref.read(tagPageSelectProvider.notifier).state = tag;
                TagEditDialog.show(context);
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ref.read(tagPageSelectProvider.notifier).state = null;
          TagEditDialog.show(context);
        },
      ),
    );
  }
}
