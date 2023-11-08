import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/entry.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/base_menu.dart';

final appInitFutureProvider = FutureProvider<void>((ref) async {
  // ここでアプリに必要な初期処理を行う
  await Future.wait([
    ref.read(entryNotifierProvider.notifier).onLoad(),
    ref.read(tagNotifierProvider.notifier).onLoad(),
  ]);

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));
});

final selectBaseMenuIndexProvider = StateProvider<int>((_) => BaseMenu.homeIndex);
