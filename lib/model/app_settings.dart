// アプリ起動時の初期化処理を行う
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/ui/base_menu.dart';

final appInitFutureProvider = FutureProvider<void>((ref) async {
  // TODO ここでアプリの初期化処理を行う
  await Future<void>.delayed(const Duration(milliseconds: 500));
});

// どの画面メニューを表示しているか？
final selectMenuIndexProvider = StateProvider<int>((_) => BaseMenu.homeIndex);
