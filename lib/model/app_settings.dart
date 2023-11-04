// アプリ起動時の初期化処理を行う
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/base_menu.dart';

final appInitFutureProvider = FutureProvider<void>((ref) async {
  // TODO ここでアプリに必要な初期処理を行う
  await ref.read(tagNotifierProvider.notifier).onLoad();

  // Tag画像のキャッシュ
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));
});

// どの画面メニューを表示しているか？
final selectMenuIndexProvider = StateProvider<int>((_) => BaseMenu.homeIndex);
