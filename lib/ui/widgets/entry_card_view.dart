import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/tag_chip.dart';
import 'package:tech_note/ui/widgets/thumbnail_image.dart';

class EntryCardView extends StatelessWidget {
  const EntryCardView(this.entry, {super.key});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ViewImage(entry.mainTagId),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ViewTitleAndDateTime(title: entry.title, updateAt: entry.updateAt),
                  const SizedBox(height: 8),
                  _ViewTagChips(mainTagId: entry.mainTagId, tagIds: entry.tagIds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewImage extends ConsumerWidget {
  const _ViewImage(this.mainTagId);

  final int mainTagId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tag = ref.watch(tagNotifierProvider.notifier).getTag(mainTagId);
    return ThumbnailImage.entry(imageUrl: tag?.thumbnailUrl);
  }
}

class _ViewTitleAndDateTime extends StatelessWidget {
  const _ViewTitleAndDateTime({required this.title, required this.updateAt});

  final String title;
  final DateTime updateAt;

  static final dateFormat = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: AppText.normal(title, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        AppText.normal(dateFormat.format(updateAt)),
      ],
    );
  }
}

class _ViewTagChips extends ConsumerWidget {
  const _ViewTagChips({required this.mainTagId, required this.tagIds});

  final int mainTagId;
  final List<int> tagIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mergeIds = _mergeIds();
    final tags = ref.watch(tagNotifierProvider.notifier).getTags(ids: mergeIds, maxLength: 4);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map((e) => TagChip(
                tag: e,
                isSelected: true,
                onSelected: (_) {/** タップしても特に何もしない */},
              ))
          .toList(),
    );
  }

  List<int> _mergeIds() {
    final tmp = tagIds;
    if (!tmp.contains(mainTagId)) {
      tmp.add(mainTagId);
    }
    tmp.sort();
    return tmp;
  }
}
