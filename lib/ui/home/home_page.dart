import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_note/common/app_theme.dart';
import 'package:tech_note/model/tag.dart';
import 'package:tech_note/ui/entry/entry_edit_page.dart';
import 'package:tech_note/ui/entry/entry_page.dart';
import 'package:tech_note/ui/entry/entry_page_controller.dart';
import 'package:tech_note/ui/home/home_page_controller.dart';
import 'package:tech_note/ui/home/refresh_dialog.dart';
import 'package:tech_note/ui/widgets/app_text.dart';
import 'package:tech_note/ui/widgets/entry_card_view.dart';
import 'package:tech_note/ui/widgets/tags_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.pageTitle(AppTheme.appName),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _RefreshButton(),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ViewHeader(),
            Divider(),
            _ViewContents(),
          ],
        ),
      ),
      floatingActionButton: const _RegisterNewEntryFab(),
    );
  }
}

class _RefreshButton extends ConsumerWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO このボタンはinfo画面に移動する
    return IconButton(
      onPressed: () async {
        await RefreshDialog.show(context);
      },
      icon: const Icon(Icons.refresh),
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
          _SearchTextField(),
          SizedBox(height: 16),
          Row(
            children: [
              _ViewTagFilter(),
              SizedBox(width: 16),
              _FilterSortIcon(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchTextField extends ConsumerWidget {
  const _SearchTextField();

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
        ref.read(homePageControllerProvider.notifier).inputKeyword(query);
      },
    );
  }
}

class _FilterSortIcon extends ConsumerWidget {
  const _FilterSortIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesc = ref.watch(homePageIsUpdateAtDescStateProvider);
    final label = isDesc ? 'Oldest' : 'Latest';
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
        padding: const EdgeInsets.only(bottom: 64),
        child: Wrap(
          children: entries
              .map(
                (e) => SizedBox(
                  width: cardWidth,
                  child: EntryCardView(e, onTap: () {
                    ref.read(selectEntryStateProvider.notifier).state = e;
                    EntryPage.start(context);
                  }),
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
    return TagsBottomSheet(
      selectTagIds: ref.watch(homePageFilterTagIdsStateProvider),
      onSelected: (Tag tag, bool isSelect) {
        ref.read(homePageControllerProvider.notifier).selectFilterTag(tag.id, isSelect);
      },
    );
  }
}

class _RegisterNewEntryFab extends ConsumerWidget {
  const _RegisterNewEntryFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        ref.read(entryPageControllerProvider.notifier).clear();
        EntryEditPage.start(context);
      },
    );
  }
}
