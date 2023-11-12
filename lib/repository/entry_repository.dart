import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/repository/local/shared_prefs.dart';

final entryRepositoryProvider = Provider((ref) => EntryRepository(ref));

class EntryRepository {
  const EntryRepository(this._ref);

  final Ref _ref;

  Future<List<Entry>> findAll() async {
    // TODO ローカルDBからデータを取得して返す
    return _dummyData();
  }

  Future<int> findRefreshCount() async {
    // TODO lastUpdateAtでFirestoreをwhereして更新データ件数を取得する
    await Future<void>.delayed(const Duration(seconds: 2));
    return 10;
  }

  Future<void> refresh() async {
    // TODO ローカルのEntry件数が0ならリモートから全データ取得
    //   ローカルDBに保存
    await Future<void>.delayed(const Duration(seconds: 1));

    // TODO ローカルのEntry件数が1件以上ある
    //   updateAtの最新日時を、FirestoreのwhereのupdateAtと比較して以降のデータを全取得
    //   ローカルDBに反映する;
    await _ref.read(sharedPrefsProvider).saveLastRefreshEntryDateTime(DateTime.now());
  }

  Future<void> delete(Entry entry) async {
    // TODO リモートとローカルDBから削除する
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  Future<Entry> save(Entry entry) async {
    // TODO 保存し、その後にIDが振られるのでそれを反映して返す
    await Future<void>.delayed(const Duration(seconds: 1));
    return entry;
  }

  Future<DateTime?> getLastUpdateDate() async {
    return _ref.read(sharedPrefsProvider).getLastRefreshEntryDateTime();
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
