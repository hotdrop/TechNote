import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/widgets/tag_preview_chip.dart';
import 'package:tech_note/ui/tag/tag_page_controller.dart';
import 'package:tech_note/ui/widgets/app_button.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/color_bullet_dialog.dart';
import 'package:tech_note/ui/widgets/tag_area_dropdown.dart';

class TagEditDialog {
  static Future<void> show(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (context) => const _AlertDialogWrapper(),
    );
  }
}

class _AlertDialogWrapper extends ConsumerWidget {
  const _AlertDialogWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AlertDialog(
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _ViewTagPreview(),
            SizedBox(height: 24),
            _ViewPickThumbnailButton(),
            SizedBox(height: 16),
            _ViewSelectColorButton(),
            SizedBox(height: 24),
            _ViewTagNameTextField(),
            SizedBox(height: 8),
            _ViewTextColorCheckBox(),
            SizedBox(height: 16),
            _ViewTagAreaDropdown(),
            Spacer(),
            _ViewButtons(),
          ],
        ),
      ),
    );
  }
}

class _ViewTagPreview extends ConsumerWidget {
  const _ViewTagPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          AppText.large('Tag Preview'),
          const Divider(),
          const SizedBox(height: 8),
          TagPreviewChip(
            name: ref.watch(tagEditNameProvider),
            tagColor: ref.watch(tagEditColorProvider),
            isTextColorBlack: ref.watch(tagEditIsTextColorBlackProvider),
            imageByteData: ref.watch(tagEditImageByteProvider),
            url: ref.read(tagPageSelectProvider)?.thumbnailUrl,
          )
        ],
      ),
    );
  }
}

class _ViewPickThumbnailButton extends ConsumerWidget {
  const _ViewPickThumbnailButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null) {
          final imageBytes = result.files.first.bytes!;
          ref.read(tagPageControllerProvider.notifier).inputImageByte(imageBytes);
        }
      },
      icon: const Icon(Icons.image),
      label: AppText.normal('Pick Thumbnail'),
    );
  }
}

class _ViewSelectColorButton extends ConsumerWidget {
  const _ViewSelectColorButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        const dialog = ColorBulletDialog();
        await dialog.show(
          context: context,
          currentColor: ref.read(tagEditColorProvider),
          onSelected: (Color selectColor) {
            ref.read(tagPageControllerProvider.notifier).inputColor(selectColor);
          },
        );
      },
      icon: const Icon(Icons.color_lens),
      label: AppText.normal('Select tag color'),
    );
  }
}

class _ViewTagNameTextField extends ConsumerWidget {
  const _ViewTagNameTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Tag Name',
      ),
      initialValue: ref.watch(tagPageSelectProvider)?.name,
      onChanged: (String newVal) {
        ref.read(tagPageControllerProvider.notifier).inputTagName(newVal);
      },
    );
  }
}

class _ViewTextColorCheckBox extends ConsumerWidget {
  const _ViewTextColorCheckBox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
          value: ref.watch(tagEditIsTextColorBlackProvider),
          onChanged: (bool? value) {
            if (value != null) {
              ref.read(tagPageControllerProvider.notifier).inputIsTextColorBlack(value);
            }
          },
        ),
        AppText.normal('Text Color Black'),
      ],
    );
  }
}

class _ViewTagAreaDropdown extends ConsumerWidget {
  const _ViewTagAreaDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TagAreaDropdown(
      currentTagArea: ref.watch(tagEditSelectTagAreaProvider),
      onChanged: (TagAreaEnum value) {
        ref.read(tagPageControllerProvider.notifier).inputTagArea(value);
      },
    );
  }
}

class _ViewButtons extends ConsumerWidget {
  const _ViewButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText.normal('Cancel'),
        ),
        const SizedBox(width: 24),
        SaveButton(
            width: 150,
            enable: ref.watch(tagEditPreparedSaveProvider),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(tagPageControllerProvider.notifier).save();
              Future<void>.delayed(const Duration(seconds: 1)).then((_) {
                navigator.pop();
              });
            }),
      ],
    );
  }
}
