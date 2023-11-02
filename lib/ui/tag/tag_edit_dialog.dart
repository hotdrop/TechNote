import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/tag_preview_chip.dart';
import 'package:tech_note/ui/widgets/app_button.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/color_bullet_dialog.dart';
import 'package:tech_note/ui/widgets/tag_area_dropdown.dart';

class TagEditDialog {
  Future<void> show(BuildContext context, Tag? tag) async {
    return await showDialog<void>(
      context: context,
      builder: (context) => _AlertDialogWrapper(tag),
    );
  }
}

class _AlertDialogWrapper extends StatefulWidget {
  const _AlertDialogWrapper(this.tag);

  final Tag? tag;

  @override
  _AlertDialogWrapperState createState() => _AlertDialogWrapperState();
}

class _AlertDialogWrapperState extends State<_AlertDialogWrapper> {
  final _controller = TextEditingController();
  Uint8List? imageBytes;
  Color tagColor = const Color.fromARGB(255, 227, 227, 227);
  bool isTextColorBlack = true;
  TagAreaEnum? selectTagArea;

  @override
  void initState() {
    _controller.addListener(_onTextChanged);
    final editTag = widget.tag;
    if (editTag != null) {
      _controller.text = editTag.name;
      tagColor = editTag.tagColor;
      isTextColorBlack = editTag.isTextColorBlack;
      selectTagArea = editTag.tagArea;
    }
    super.initState();
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        imageBytes = result.files.first.bytes;
      });
    }
  }

  void _onTextChanged() {
    setState(() {
      // This triggers a rebuild with the updated text.
    });
  }

  void _onCheckboxChanged(bool? value) {
    if (value != null) {
      setState(() {
        isTextColorBlack = value;
      });
    }
  }

  bool _enableSaveAction() {
    return _controller.text.isNotEmpty && selectTagArea != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(children: [
                AppText.large('Tag Preview'),
                const Divider(),
                const SizedBox(height: 8),
                TagPreviewChip(
                  name: _controller.text,
                  tagColor: tagColor,
                  isTextColorBlack: isTextColorBlack,
                  imageByteData: imageBytes,
                  url: widget.tag?.thumbnailUrl,
                )
              ]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: selectImage,
              icon: const Icon(Icons.image),
              label: AppText.normal('Pick Thumbnail'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                const dialog = ColorBulletDialog();
                await dialog.show(
                  context: context,
                  currentColor: tagColor,
                  onSelected: (Color selectColor) {
                    setState(() => tagColor = selectColor);
                  },
                );
              },
              icon: const Icon(Icons.color_lens),
              label: AppText.normal('Select tag color'),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tag Name',
              ),
              controller: _controller,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: isTextColorBlack,
                  onChanged: _onCheckboxChanged,
                ),
                AppText.normal('Text Color Black'),
              ],
            ),
            const SizedBox(height: 16),
            TagAreaDropdown(
              currentTagArea: selectTagArea,
              onChanged: (TagAreaEnum selectVal) {
                setState(() => selectTagArea = selectVal);
              },
            ),
            const Spacer(),
            SaveButton(
                enable: _enableSaveAction(),
                onPressed: () {
                  // TODO 登録処理を行う
                }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
