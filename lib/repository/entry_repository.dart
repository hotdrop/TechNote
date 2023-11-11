import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';

final entryRepositoryProvider = Provider((ref) => EntryRepository(ref));

class EntryRepository {
  const EntryRepository(this._ref);

  final Ref _ref;

  Future<List<Entry>> findAll() async {
    // ローカルDBからデータを取得して返す
    return _dummyData();
  }

  Future<int> findRefreshCount() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    // TODO 更新データをカウントする
    return 10;
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    // TODO ローカルのEntryから最新のupdateAtを取得する
    //    ローカルのEntry件数が0
    //      -> Firestoreから全データ取得
    //    ローカルのEntry件数あり
    //      updateAtの最新日時を、FirestoreのwhereのupdateAtと比較して以降のデータを全取得
    //  ローカルDBに反映する
  }

  Future<void> delete() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    // TODO リモートから削除する
    // ローカルDBから削除する
  }

  List<Entry> _dummyData() {
    final now = DateTime.now();
    final note = '''
# マークダウンテスト
ここに本文を入れます。

## その1
テストです。アイウエオカキクケコ。hogeです。ホゲホゲ
なぜhogeなのか？

## その2
スクロールが問題ないかのテストをする

`ここが強調になるか`のテスト
**ここが太文字になるか**のテスト

## その3
コードの確認はするか？
''';
    return [
      Entry(id: '1', title: 'タイトルが長いテスト情報です。アイウエオカキくけこ', url: 'http://www.sample.jp/entry/test=2948jdjdsfhh', mainTagId: 1, tagIds: [1, 10], note: note, createAt: now, updateAt: now),
      Entry(id: '2', title: 'テスト2', url: 'https://www.sample.jp', mainTagId: 2, tagIds: [2, 3, 6, 10, 12], note: 'アイウエオノート', createAt: now, updateAt: DateTime(2023, 11, 5)),
      Entry(id: '3', title: 'テスト3', url: 'https://www.sample.jp', mainTagId: 3, tagIds: [2, 5, 6, 7], note: 'カキクケコノート', createAt: now, updateAt: DateTime(2023, 11, 4)),
      Entry(id: '4', title: 'テスト4', url: 'https://www.sample.jp', mainTagId: 7, tagIds: [6], note: 'ホゲノート', createAt: now, updateAt: DateTime(2023, 11, 1)),
      Entry(id: '5', title: 'テスト5', url: 'https://www.sample.jp', mainTagId: 8, tagIds: [8, 11], note: 'hogeノート', createAt: now, updateAt: DateTime(2023, 10, 25)),
    ];
  }
}
