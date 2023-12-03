import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';

part 'information_page_controller.g.dart';

@riverpod
class InformationPageController extends _$InformationPageController {
  @override
  Future<PackageInfo> build() async {
    return await PackageInfo.fromPlatform();
  }

  Future<void> refreshEntry() async {
    await ref.read(entryNotifierProvider.notifier).refresh();
  }

  Future<void> refreshTag() async {
    await ref.read(tagNotifierProvider.notifier).refresh();
  }
}

final infoPageRefreshEntryCountProvider = FutureProvider<int>((ref) async {
  return await ref.read(entryNotifierProvider.notifier).refreshCount();
});

final infoPageRefreshTagCountProvider = FutureProvider<int>((ref) async {
  return await ref.read(tagNotifierProvider.notifier).refreshCount();
});
