import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/home/home_page_controller.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/entry_card_view.dart';
import 'package:tech_note/ui/widgets/tags_view_by_area.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTheme.appName),
        // TODO Actionに更新ボタン
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _ViewHeader(),
            Divider(),
            _ViewContents(),
          ],
        ),
      ),
      // TODO エントリ新規登録のFab
    );
  }
}

class _ViewHeader extends ConsumerWidget {
  const _ViewHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ViewSearchTextField(),
          SizedBox(height: 16),
          Row(
            children: [
              _ViewTagFilter(),
              SizedBox(width: 16),
              _ViewFilterSortIcon(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewSearchTextField extends ConsumerWidget {
  const _ViewSearchTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(2),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Icon(Icons.search),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        hintText: 'Search with Enter',
      ),
      style: const TextStyle(fontSize: AppTheme.defaultTextSize),
      onFieldSubmitted: (String query) {
        // TODO キーワード検索する
      },
    );
  }
}

class _ViewFilterSortIcon extends ConsumerWidget {
  const _ViewFilterSortIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesc = ref.watch(homePageIsUpdateAtDescStateProvider);
    final label = isDesc ? 'Latest' : 'Oldest';
    return OutlinedButton.icon(
      icon: const Icon(Icons.sort),
      label: AppText.normal(label),
      onPressed: () {
        ref.read(homePageControllerProvider.notifier).changeUpdateAtSort();
      },
    );
  }
}

class _ViewTagFilter extends ConsumerWidget {
  const _ViewTagFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.filter_alt_sharp),
      label: AppText.normal('Tag Filter'),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (_) => const _TagFilterBottomSheet(),
        );
      },
    );
  }
}

class _ViewContents extends ConsumerWidget {
  const _ViewContents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(homePageShowEntriesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? screenWidth : (screenWidth / 2) - 50;

    return Flexible(
      child: SingleChildScrollView(
        child: Wrap(
          children: entries
              .map(
                (e) => SizedBox(
                  width: cardWidth,
                  child: EntryCardView(e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TagFilterBottomSheet extends ConsumerWidget {
  const _TagFilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          // TODO フィルターのクリアボタン的なものが欲しい
          children: TagAreaEnum.values.map((area) {
            return TagsViewByArea(
              area,
              selectTagIds: ref.watch(homePageFilterTagIdsStateProvider),
              onSelected: (Tag tag, bool isSelect) {
                ref.read(homePageControllerProvider.notifier).selectFilterTag(tag.id, isSelect);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
