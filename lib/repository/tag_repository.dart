import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';

final tagRepositoryProvider = Provider((ref) => TagRepository(ref));

class TagRepository {
  const TagRepository(this._ref);

  final Ref _ref;

  Future<List<Tag>> findAll() async {
    // TODO 以下の処理を行う。今はダミー処理
    //  ローカルの日時を取得する。日時がなければFirestoreから全取得してローカルDBに保存
    //  日時があればFirestoreから更新日時を取得
    //  ローカルの日時と比較し、古ければFirestoreから全取得してローカルDBに保存

    // ローカルDBからデータを取得して返す
    await Future<void>.delayed(const Duration(seconds: 1));
    return _dummyData();
  }

  Future<void> save(Tag tag) async {
    // この判定はFirestoreやローカルDBでやれば良いかも
    switch (tag) {
      case RegisteredTag():
        // TODO IDを指定して保存
        // TODO ローカルDB書き換え
        break;
      case UnregisterdTag():
        // TODO 新規保存
        // TODO ローカルDB書き換え
        break;
    }
    // Colorを16進数にする
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  List<Tag> _dummyData() {
    return [
      RegisteredTag(tagId: '1', name: 'Kotlin', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 224, 137, 53), isTextColorBlack: false, tagArea: TagAreaEnum.langAndFw),
      RegisteredTag(tagId: '2', name: 'Dart', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 120, 245, 147), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      RegisteredTag(tagId: '3', name: 'Flutter', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 102, 226, 243), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      RegisteredTag(tagId: '4', name: 'React', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 235, 244, 131), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      RegisteredTag(tagId: '5', name: 'Vue', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 41, 180, 71), isTextColorBlack: false, tagArea: TagAreaEnum.langAndFw),
      RegisteredTag(tagId: '6', name: 'Javascript', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 240, 249, 172), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      RegisteredTag(tagId: '7', name: '技術書', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 174, 174, 173), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      RegisteredTag(tagId: '8', name: 'Slide', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 33, 139, 29), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      RegisteredTag(tagId: '9', name: 'YouTube', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 244, 44, 44), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      RegisteredTag(tagId: '10', name: 'Android', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 20, 133, 18), isTextColorBlack: false, tagArea: TagAreaEnum.platform),
      RegisteredTag(tagId: '11', name: 'iOS', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 188, 187, 187), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      RegisteredTag(tagId: '12', name: 'Firebase', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 244, 161, 44), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      RegisteredTag(tagId: '13', name: 'AWS', thumbnailImageUrl: '', tagColor: Color.fromARGB(255, 246, 67, 67), isTextColorBlack: false, tagArea: TagAreaEnum.platform),
    ];
  }
}
