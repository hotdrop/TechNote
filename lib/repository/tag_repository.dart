import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';

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
    // TODO ローカルのTagから最新のupdateAtを取得する
    //    ローカルのTag件数が0
    //      -> Firestoreから全データ取得
    //    ローカルのTag件数あり
    //      updateAtの最新日時を、FirestoreのwhereのupdateAtと比較して以降のデータを全取得
    //  ローカルDBに反映する
  }

  Future<void> save(Tag tag, Uint8List? imageBytes) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (tag.isUnregistered()) {
      // TODO 新規保存してローカルDB書き換え
    } else {
      // TODO IDを指定して保存。imageBytesがnullでなければサムネイル画像更新
      // TODO ローカルDBに保存
    }
  }

  List<Tag> _dummyData() {
    return [
      Tag(id: 1, name: 'Kotlin', color: Color.fromARGB(255, 224, 137, 53), isTextColorBlack: false, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 2, name: 'Dart', color: Color.fromARGB(255, 120, 245, 147), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 3, name: 'Flutter', color: Color.fromARGB(255, 102, 226, 243), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 4, name: 'React', color: Color.fromARGB(255, 235, 244, 131), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 5, name: 'Vue', color: Color.fromARGB(255, 41, 180, 71), isTextColorBlack: false, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 6, name: 'Javascript', color: Color.fromARGB(255, 240, 249, 172), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: 7, name: '技術書', color: Color.fromARGB(255, 174, 174, 173), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: 8, name: 'Slide', color: Color.fromARGB(255, 33, 139, 29), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: 9, name: 'YouTube', color: Color.fromARGB(255, 244, 44, 44), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: 10, name: 'Android', color: Color.fromARGB(255, 20, 133, 18), isTextColorBlack: false, tagArea: TagAreaEnum.platform),
      Tag(id: 11, name: 'iOS', color: Color.fromARGB(255, 188, 187, 187), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: 12, name: 'Firebase', color: Color.fromARGB(255, 244, 161, 44), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: 13, name: 'AWS', color: Color.fromARGB(255, 246, 67, 67), isTextColorBlack: false, tagArea: TagAreaEnum.platform),
    ];
  }
}
