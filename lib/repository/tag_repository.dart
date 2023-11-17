import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/repository/remote/tag_api.dart';

final tagRepositoryProvider = Provider((ref) => TagRepository(ref));

class TagRepository {
  const TagRepository(this._ref);

  final Ref _ref;

  Future<List<Tag>> findAll() async {
    // TODO ローカルDBからデータを取得して返す
    return _dummyData();
  }

  Future<int> getUpdateTagCount() async {
    return await _ref.read(tagApiProvider).getUpdateTagCount();
  }

  Future<void> refresh() async {
    // final newTags = await _ref.read(tagApiProvider).findTags(lastUpdateAt);
    // TODO ローカルDBに保存
  }

  Future<Tag> save(Tag tag, Uint8List? imageBytes) async {
    Tag localTag = tag;
    if (imageBytes != null) {
      final imageUrl = await _ref.read(tagApiProvider).saveImage(tag.name, imageBytes);
      localTag = tag.copyThumbnailUrl(imageUrl);
    }

    final id = await _ref.read(tagApiProvider).save(localTag);
    if (tag.isUnregistered()) {
      localTag = localTag.copyId(id);
    }

    // TODO ローカルDB書き換え

    return localTag;
  }

  List<Tag> _dummyData() {
    return [
      Tag(id: "1", name: 'Kotlin', color: const Color.fromARGB(255, 243, 171, 104), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: "2", name: 'Dart', color: const Color.fromARGB(255, 134, 223, 240), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: "3", name: 'Flutter', thumbnailUrl: '', color: const Color.fromARGB(255, 102, 226, 243), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: "4", name: 'React', color: const Color.fromARGB(255, 235, 244, 131), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: "5", name: 'Vue', color: const Color.fromARGB(255, 41, 180, 71), isTextColorBlack: false, tagArea: TagAreaEnum.langAndFw),
      Tag(id: "6", name: 'Javascript', color: const Color.fromARGB(255, 240, 249, 172), isTextColorBlack: true, tagArea: TagAreaEnum.langAndFw),
      Tag(id: "7", name: '技術書', color: const Color.fromARGB(255, 174, 174, 173), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: "8", name: 'Slide', color: const Color.fromARGB(255, 62, 241, 56), isTextColorBlack: true, tagArea: TagAreaEnum.media),
      Tag(id: "9", name: 'YouTube', color: const Color.fromARGB(255, 246, 126, 126), isTextColorBlack: false, tagArea: TagAreaEnum.media),
      Tag(id: "10", name: 'Android', color: const Color.fromARGB(255, 150, 243, 148), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: "11", name: 'iOS', color: const Color.fromARGB(255, 188, 187, 187), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: "12", name: 'Firebase', color: const Color.fromARGB(255, 244, 161, 44), isTextColorBlack: true, tagArea: TagAreaEnum.platform),
      Tag(id: "13", name: 'AWS', color: const Color.fromARGB(255, 246, 67, 67), isTextColorBlack: false, tagArea: TagAreaEnum.platform),
    ];
  }
}
