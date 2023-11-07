import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'information_page_controller.g.dart';

@riverpod
class informationPageController extends _$informationPageController {
  @override
  Future<PackageInfo> build() async {
    return await PackageInfo.fromPlatform();
  }
}
