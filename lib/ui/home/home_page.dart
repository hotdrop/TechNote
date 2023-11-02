import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/edit/tag_edit_dialog.dart';
import 'package:tech_note/ui/tag/tag_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTheme.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('ホーム画面です'),
            ElevatedButton(
              onPressed: () async {
                ref.read(tagControllerProvider.notifier).selectTag(null);
                final dialog = TagEditDialog();
                await dialog.show(context);
              },
              child: Text('タグ生成テスト（初期値空）'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final tag = Tag(
                  name: '認証・認可',
                  thumbnailUrl: null,
                  tagColor: Colors.orange,
                  isTextColorBlack: true,
                  tagArea: TagAreaEnum.technique,
                );
                ref.read(tagControllerProvider.notifier).selectTag(tag);
                final dialog = TagEditDialog();
                await dialog.show(context);
              },
              child: Text('タグ生成テスト（初期値あり）'),
            ),
          ],
        ),
      ),
    );
  }
}
