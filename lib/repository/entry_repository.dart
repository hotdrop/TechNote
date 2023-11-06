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

  Future<void> refresh() async {
    // TODO ローカルのEntryから最新のupdateAtを取得する
    //    ローカルのEntry件数が0
    //      -> Firestoreから全データ取得
    //    ローカルのEntry件数あり
    //      updateAtの最新日時を、FirestoreのwhereのupdateAtと比較して以降のデータを全取得
    //  ローカルDBに反映する
  }

  List<Entry> _dummyData() {
    final now = DateTime.now();
    return [
      Entry(id: '2', title: 'タイトルが長いテスト情報です。アイウエオカキくけこ', url: '', mainTagId: 1, tagIds: [1, 10], note: 'ここノート', createAt: now, updateAt: now),
      Entry(id: '3', title: 'テスト2', url: 'https://www.sample.jp', mainTagId: 2, tagIds: [2, 3, 6, 10, 12], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 11, 5)),
      Entry(id: '4', title: 'テスト3', url: 'https://www.sample.jp', mainTagId: 3, tagIds: [2, 5, 6, 7], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 11, 4)),
      Entry(id: '5', title: 'テスト4', url: 'https://www.sample.jp', mainTagId: 7, tagIds: [6], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 11, 1)),
      Entry(id: '6', title: 'テスト5', url: 'https://www.sample.jp', mainTagId: 8, tagIds: [8, 11], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 25)),
      Entry(id: '7', title: 'テスト6', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '8', title: 'テスト7です', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '9', title: 'テスト8', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '10', title: 'テスト9', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '11', title: 'テスト10', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '12', title: 'テスト11', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '13', title: 'テスト12', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '14', title: 'テスト13', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '15', title: 'テスト14', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
      Entry(id: '16', title: 'テスト15', url: 'https://www.sample.jp', mainTagId: 9, tagIds: [1, 2, 9, 10], note: 'ここノート', createAt: now, updateAt: DateTime(2023, 10, 16)),
    ];
  }
}
