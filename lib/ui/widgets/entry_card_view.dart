import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/tag_chip.dart';
import 'package:tech_note/ui/widgets/thumbnail_image.dart';

class EntryCardView extends StatelessWidget {
  const EntryCardView(this.entry, {super.key, required this.onTap});

  final Entry entry;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
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
                    _TagChips(entry: entry),
                  ],
                ),
              ),
            ],
          ),
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
    return ThumbnailImage.entryCard(imageUrl: tag?.thumbnailUrl);
  }
}

class _ViewTitleAndDateTime extends StatelessWidget {
  const _ViewTitleAndDateTime({required this.title, required this.updateAt});

  final String title;
  final DateTime updateAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: AppText.normal(title, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        AppText.normal(Entry.dateFormat.format(updateAt)),
      ],
    );
  }
}

class _TagChips extends ConsumerWidget {
  const _TagChips({required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mergeIds = entry.mergeMainAndSubTagIds();
    final tags = ref.watch(tagNotifierProvider.notifier).getTags(ids: mergeIds, maxLength: 4);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map((e) => TagChip(
                tag: e,
                isSelected: true,
                onSelected: (_) {/** no op */},
              ))
          .toList(),
    );
  }
}
