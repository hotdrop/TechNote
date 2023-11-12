import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/repository/local/shared_prefs.dart';

final tagRepositoryProvider = Provider((ref) => TagRepository(ref));

class TagRepository {
  const TagRepository(this._ref);

  final Ref _ref;

  Future<List<Tag>> findAll() async {
    // ローカルDBからデータを取得して返す
    return _dummyData();
  }

  Future<int> findRefreshCount() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    // TODO 更新データをカウントする
    return 5;
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    // TODO ローカルのEntry件数が0ならリモートから全データ取得
    //   ローカルDBに保存
    await Future<void>.delayed(const Duration(seconds: 1));

    // TODO ローカルのEntry件数が1件以上ある
    //   updateAtの最新日時を、FirestoreのwhereのupdateAtと比較して以降のデータを全取得
    //   ローカルDBに反映する;
    await _ref.read(sharedPrefsProvider).saveLastRefreshTagDateTime(DateTime.now());
  }

  Future<Tag> save(Tag tag, Uint8List? imageBytes) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (tag.isUnregistered()) {
      // TODO 新規保存してローカルDB書き換え
    } else {
      // TODO IDを指定して保存。imageBytesがnullでなければサムネイル画像更新
      // TODO ローカルDBに保存
    }
    // TODO 保存した時にIDが振られるのでそれを反映して返す
    return tag;
  }

  Future<DateTime?> getLastUpdateDate() async {
    return _ref.read(sharedPrefsProvider).getLastRefreshEntryDateTime();
  }

  List<Tag> _dummyData() {
    return [
      Tag(id: 1, name: 'Kotlin', color: const Color.fromARGB(255, 243, 171, 104), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 2, name: 'Dart', color: const Color.fromARGB(255, 134, 223, 240), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 3, name: 'Flutter', color: const Color.fromARGB(255, 102, 226, 243), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 4, name: 'React', color: const Color.fromARGB(255, 235, 244, 131), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 5, name: 'Vue', color: const Color.fromARGB(255, 41, 180, 71), isTextColorBlack: false, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 6, name: 'Javascript', color: const Color.fromARGB(255, 240, 249, 172), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 7, name: '技術書', color: const Color.fromARGB(255, 174, 174, 173), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: 8, name: 'Slide', color: const Color.fromARGB(255, 62, 241, 56), isTextColorBlack: true, tagArea: TagAreaEnum.media),
      Tag(id: 9, name: 'YouTube', color: const Color.fromARGB(255, 246, 126, 126), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: 10, name: 'Android', color: const Color.fromARGB(255, 150, 243, 148), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: 11, name: 'iOS', color: const Color.fromARGB(255, 188, 187, 187), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: 12, name: 'Firebase', color: const Color.fromARGB(255, 244, 161, 44), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: 13, name: 'AWS', color: const Color.fromARGB(255, 246, 67, 67), isTextColorBlack: false, tagArea: TagAreaEnum.platform),
    ];
  }
}
