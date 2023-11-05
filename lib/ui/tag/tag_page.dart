import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/tag_edit_dialog.dart';
import 'package:tech_note/ui/tag/tag_page_controller.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/tag_chip.dart';

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
          children: TagAreaEnum.values.map((t) => _ViewTagArea(t)).toList(),
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

class _ViewTagArea extends ConsumerWidget {
  const _ViewTagArea(this.tagArea);

  final TagAreaEnum tagArea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsByAreaProvider(tagArea));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(tagArea.name, color: Colors.grey, isBold: true),
        const Divider(),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: tags
              .map((e) => TagChip(
                    tag: e,
                    isSelected: true,
                    onSelected: (bool isSelect) {
                      ref.read(tagPageSelectProvider.notifier).state = e;
                      TagEditDialog.show(context);
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
