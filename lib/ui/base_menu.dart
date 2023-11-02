import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/app_settings.dart';
import 'package:tech_note/ui/home/home_page.dart';
import 'package:tech_note/ui/setting/settings_page.dart';
import 'package:tech_note/ui/tag/tag_page.dart';
import 'package:tech_note/ui/widgets/app_text.dart';

class BaseMenu extends ConsumerWidget {
  const BaseMenu({super.key});

  static const int homeIndex = 0;
  static const int tagIndex = 1;
  static const int settingIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdx = ref.watch(selectMenuIndexProvider);
    final isMobileSize = MediaQuery.of(context).size.width < 640;
    if (isMobileSize) {
      return _ViewMobileMode(
        destinations: destinations,
        body: _menuView(currentIdx),
        currentIdx: currentIdx,
        onTap: (index) => ref.read(selectMenuIndexProvider.notifier).state = index,
      );
    } else {
      return _ViewWebMode(
        destinations: destinations,
        body: _menuView(currentIdx),
        currentIdx: currentIdx,
        onTap: (index) => ref.read(selectMenuIndexProvider.notifier).state = index,
      );
    }
  }

  List<Destination> get destinations => <Destination>[
        const Destination('Home', Icon(Icons.home)),
        const Destination('Tag', Icon(Icons.label)),
        const Destination('Setting', Icon(Icons.settings)),
      ];

  Widget _menuView(int index) {
    return switch (index) {
      homeIndex => const HomePage(),
      tagIndex => const TagPage(),
      settingIndex => const SettingsPage(),
      _ => throw Exception(['不正なIndexです index=$index'])
    };
  }
}

class _ViewWebMode extends StatelessWidget {
  const _ViewWebMode({
    required this.destinations,
    required this.body,
    required this.currentIdx,
    required this.onTap,
  });

  final List<Destination> destinations;
  final Widget body;
  final int currentIdx;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: destinations
                .map((e) => NavigationRailDestination(
                      icon: e.icon,
                      label: AppText.normal(e.title),
                    ))
                .toList(),
            selectedIndex: currentIdx,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.selected,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _ViewMobileMode extends StatelessWidget {
  const _ViewMobileMode({
    required this.destinations,
    required this.body,
    required this.currentIdx,
    required this.onTap,
  });

  final List<Destination> destinations;
  final Widget body;
  final int currentIdx;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppTheme.primaryLightColor,
        items: destinations
            .map((e) => BottomNavigationBarItem(
                  icon: e.icon,
                  label: e.title,
                ))
            .toList(),
        onTap: onTap,
      ),
    );
  }
}

class Destination {
  const Destination(this.title, this.icon);

  final String title;
  final Widget icon;
}
