import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/ui/entry/delete_dialog.dart';
import 'package:tech_note/ui/entry/entry_edit_page.dart';
import 'package:tech_note/ui/entry/entry_page_controller.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/markdown_text.dart';
import 'package:tech_note/ui/widgets/tag_chip.dart';
import 'package:tech_note/ui/widgets/thumbnail_image.dart';
import 'package:url_launcher/url_launcher.dart';

class EntryPage extends StatelessWidget {
  const EntryPage._();

  static void start(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EntryPage._()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.pageTitle(AppTheme.appName),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ViewHeader(),
            SizedBox(height: 8),
            _ViewTags(),
            Divider(),
            _ViewContents(),
            Divider(),
            SizedBox(height: 8),
            _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _ViewHeader extends StatelessWidget {
  const _ViewHeader();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return (isMobile) ? const _ViewHeaderMobileScreen() : const _ViewHeaderWideScreen();
  }
}

class _ViewHeaderWideScreen extends ConsumerWidget {
  const _ViewHeaderWideScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ViewThumbnailImage(),
              SizedBox(width: 16),
              Flexible(child: _ViewTitleAndUrl()),
            ],
          ),
        ),
        _ViewDate(),
      ],
    );
  }
}

class _ViewHeaderMobileScreen extends ConsumerWidget {
  const _ViewHeaderMobileScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ViewDate(),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ViewThumbnailImage(),
            SizedBox(width: 16),
            Flexible(
              child: _ViewTitleAndUrl(),
            )
          ],
        ),
      ],
    );
  }
}

class _ViewThumbnailImage extends ConsumerWidget {
  const _ViewThumbnailImage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainTagId = ref.watch(selectEntryStateProvider)?.mainTagId;
    return ThumbnailImage.entryPage(
      imageUrl: ref.read(entryPageControllerProvider.notifier).getThumbnailUrl(mainTagId),
    );
  }
}

class _ViewTitleAndUrl extends ConsumerWidget {
  const _ViewTitleAndUrl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(selectEntryStateProvider)!.title;
    final url = ref.watch(selectEntryStateProvider)?.url;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.normal(title, isUnderLine: true),
        const SizedBox(height: 16),
        if (url != null)
          InkWell(
            child: AppText.weblink(url),
            onTap: () async {
              final uri = Uri.parse(url);
              await launchUrl(uri);
            },
          ),
      ],
    );
  }
}

class _ViewDate extends ConsumerWidget {
  const _ViewDate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createAt = ref.watch(selectEntryStateProvider)!.createAt;
    final updateAt = ref.watch(selectEntryStateProvider)!.updateAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.small('Create Date: ${Entry.dateFormat.format(createAt)}'),
        AppText.small('Update Date: ${Entry.dateFormat.format(updateAt)}'),
      ],
    );
  }
}

class _ViewTags extends ConsumerWidget {
  const _ViewTags();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagIds = ref.watch(selectEntryStateProvider)?.tagIds ?? [];
    final tags = ref.watch(entryPageControllerProvider.notifier).getTags(tagIds);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags
            .map((e) => TagChip(
                  tag: e,
                  isSelected: true,
                  onSelected: (_) {/** no op */},
                ))
            .toList(),
      ),
    );
  }
}

class _ViewContents extends ConsumerWidget {
  const _ViewContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(selectEntryStateProvider)?.note ?? '';
    return Expanded(
      child: SingleChildScrollView(
        child: MarkdownText(note: note),
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final isDelete = await DeleteDialog.show(context);
                if (isDelete) {
                  navigator.pop();
                }
              },
            )),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: () {
              EntryEditPage.start(context);
            },
            icon: const Icon(Icons.edit),
            label: AppText.normal('Edit'),
          ),
        )
      ],
    );
  }
}
