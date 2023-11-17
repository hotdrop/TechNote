import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/entry/entry_page_controller.dart';
import 'package:tech_note/ui/widgets/app_button.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/tag_chip.dart';
import 'package:tech_note/ui/widgets/tags_bottom_sheet.dart';
import 'package:tech_note/ui/widgets/thumbnail_image.dart';

class EntryEditPage extends StatelessWidget {
  const EntryEditPage._();

  static void start(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EntryEditPage._()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.pageTitle(AppTheme.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _InputTitleTextField(),
              const SizedBox(height: 16),
              const _InputUrlTextField(),
              const SizedBox(height: 16),
              const _ViewSelectTag(),
              AppText.small('※タグを選択するとサムネイルに設定できます', isBold: true),
              const SizedBox(height: 16),
              const _NoteTextField(),
              const SizedBox(height: 16),
              const _ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputTitleTextField extends ConsumerWidget {
  const _InputTitleTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        label: AppText.normal('Title'),
        helperText: '* required',
        helperStyle: const TextStyle(
          color: Colors.red,
        ),
      ),
      style: const TextStyle(fontSize: AppTheme.defaultTextSize),
      initialValue: ref.watch(entryEditPageTitleProvider),
      onChanged: (String newVal) {
        ref.read(entryPageControllerProvider.notifier).inputTitle(newVal);
      },
    );
  }
}

class _InputUrlTextField extends ConsumerWidget {
  const _InputUrlTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        label: AppText.normal('URL'),
      ),
      style: const TextStyle(fontSize: AppTheme.defaultTextSize),
      initialValue: ref.watch(entryEditPageUrlProvider),
      onChanged: (String newVal) {
        ref.read(entryPageControllerProvider.notifier).inputUrl(newVal);
      },
    );
  }
}

class _ViewSelectTag extends ConsumerWidget {
  const _ViewSelectTag();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ThumbnailImage(),
        SizedBox(width: 16),
        _TagChips(),
        SizedBox(width: 8),
      ],
    );
  }
}

class _ThumbnailImage extends ConsumerWidget {
  const _ThumbnailImage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainTagId = ref.watch(entryEditPageSelectMainTagProvider);
    return ThumbnailImage.entryPage(
      imageUrl: ref.read(entryPageControllerProvider.notifier).getThumbnailUrl(mainTagId),
    );
  }
}

class _TagChips extends ConsumerWidget {
  const _TagChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagChipWidgets = ref
        .watch(entryEditPageSelectTagsProvider)
        .map((e) => TagChip(
              tag: e,
              isSelected: true,
              onSelected: (_) {
                ref.read(entryPageControllerProvider.notifier).selectMainTag(e.id);
              },
            ))
        .toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...tagChipWidgets,
        const _TagButton(),
      ],
    );
  }
}

class _TagButton extends ConsumerWidget {
  const _TagButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (_) => const _TagSelectBottomSheet(),
        );
      },
      icon: const Icon(Icons.add_box_rounded),
    );
  }
}

class _TagSelectBottomSheet extends ConsumerWidget {
  const _TagSelectBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TagsBottomSheet(
      selectTagIds: ref.watch(entryEditPageSelectTagIdsProvider),
      onSelected: (Tag tag, bool isSelect) {
        ref.read(entryPageControllerProvider.notifier).selectTag(id: tag.id, isSelect: isSelect);
      },
    );
  }
}

class _NoteTextField extends ConsumerWidget {
  const _NoteTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      initialValue: ref.read(entryEditPageNoteProvider),
      minLines: 1,
      maxLines: 20,
      style: const TextStyle(fontSize: AppTheme.defaultTextSize),
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      onChanged: (String newVal) {
        ref.read(entryPageControllerProvider.notifier).inputNote(newVal);
      },
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText.normal('Cancel'),
        ),
        const SizedBox(width: 24),
        SaveButton(
            width: 150,
            enable: ref.watch(entryEditPagePreparedSaveProvider),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(entryPageControllerProvider.notifier).edit();
              Future<void>.delayed(const Duration(seconds: 1)).then((_) {
                navigator.pop();
              });
            }),
      ],
    );
  }
}
