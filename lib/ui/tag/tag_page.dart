import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/tag_edit_dialog.dart';
import 'package:tech_note/ui/tag/tag_page_controller.dart';
import 'package:tech_note/ui/widgets/tags_view_by_area.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTheme.appName),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: _ViewBody(),
      ),
      floatingActionButton: const _RegisterNewTagFab(),
    );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: TagAreaEnum.values.map((area) {
        return TagsViewByArea(
          area,
          onSelected: (tag, isSelect) {
            ref.read(tagPageSelectTagProvider.notifier).state = tag;
            TagEditDialog.show(context);
          },
        );
      }).toList(),
    );
  }
}

class _RegisterNewTagFab extends ConsumerWidget {
  const _RegisterNewTagFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        ref.read(tagPageSelectTagProvider.notifier).state = null;
        TagEditDialog.show(context);
      },
    );
  }
}
