import 'package:flutter/material.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/tag/tag_edit_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                final dialog = TagEditDialog();
                await dialog.show(context, null);
              },
              child: Text('タグ生成テスト（初期値空）'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final dialog = TagEditDialog();
                await dialog.show(
                    context,
                    Tag(
                      name: '認証・認可',
                      thumbnailUrl: null,
                      tagColor: Colors.orange,
                      isTextColorBlack: true,
                      tagArea: TagAreaEnum.technique,
                    ));
              },
              child: Text('タグ生成テスト（初期値あり）'),
            ),
          ],
        ),
      ),
    );
  }
}
