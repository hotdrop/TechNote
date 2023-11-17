import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/firebase_options.dart';
import 'package:tech_note/model/app_settings.dart';
import 'package:tech_note/ui/base_menu.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appSettingsNotifierProvider).isDarkMode;
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', '')],
      title: AppTheme.appName,
      theme: isDarkMode ? AppTheme.dark : AppTheme.light,
      home: ref.watch(appInitFutureProvider).when(
            data: (_) => const BaseMenu(),
            error: (error, s) => _ViewOnLoading(errorMessage: '$error'),
            loading: () => const _ViewOnLoading(),
          ),
    );
  }
}

class _ViewOnLoading extends StatelessWidget {
  const _ViewOnLoading({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.pageTitle(AppTheme.appName),
      ),
      body: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Theme.of(context).primaryColor,
          size: 32,
        ),
      ),
    );
  }
}
