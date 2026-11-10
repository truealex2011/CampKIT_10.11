import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import 'event_sheet.dart';
import 'media_pool.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _text = TextEditingController();
  Set<EventCategory> _categories = const {};
  DateTimeRange? _range;
  FeedFilter _filter = const FeedFilter();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _applyFilter() {
    _filter = FeedFilter(
      query: _text.text.trim(),
      categories: _categories,
      from: _range?.start,
      to: _range?.end,
    );
  }

  void _onQuery(String _) {
    setState(_applyFilter);
  }

  void _toggleCategory(EventCategory category) {
    setState(() {
      final next = {..._categories};
      if (!next.remove(category)) next.add(category);
      _categories = next;
      _applyFilter();
    });
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, 1, 1);
    final last = DateTime(now.year + 2, 12, 31);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: last,
      initialDateRange: _range,
      helpText: 'Период событий',
    );
    if (picked == null) return;
    setState(() {
      _range = picked;
      _applyFilter();
    });
  }

  void _clearAll() {
    setState(() {
      _text.clear();
      _categories = const {};
      _range = null;
      _applyFilter();
    });
  }

  bool get _dirty =>
      _filter.query.isNotEmpty ||
      _filter.categories.isNotEmpty ||
      _filter.from != null;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final results = ref.watch(searchResultsProvider(_filter));
    return Scaffold(
      backgroundColor: Palette.paper,
      appBar: AppBar(
        backgroundColor: Palette.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Palette.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Поиск событий',
          style: Fonts.sansStyle(size: 17, weight: 600, color: Palette.ink),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                Scale.gutter(size.width),
                4,
                Scale.gutter(size.width),
                0,
              ),
              child: GlassField(
                label: 'Что ищем',
                controller: _text,
                hint: 'Название, описание, место',
                icon: Icons.search_rounded,
                textCapitalization: TextCapitalization.sentences,
                onChanged: _onQuery,
                suffixIcon: Icons.close_rounded,
                onSuffixTap: _dirty ? _clearAll : null,
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: Scale.gutter(size.width),
                ),
                children: [
                  for (final category in EventCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        category: category,
                        selected: _categories.contains(category),
                        onTap: () => _toggleCategory(category),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Scale.gutter(size.width),
                6,
                Scale.gutter(size.width),
                4,
              ),
              child: _RangeTile(
                range: _range,
                onTap: _pickRange,
                onClear: _range == null ? null : _clearRange,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: results.when(
                loading: () => const Center(child: FishLoader(size: 40)),
                error: (e, _) => _SearchMessage(
                  icon: Icons.error_outline_rounded,
                  text: e is AppException ? e.message : 'Поиск недоступен',
                ),
                data: (events) => events.isEmpty
                    ? _SearchMessage(
                        fish: true,
                        text: 'Ничего не нашлось',
                        hint: 'Попробуй изменить запрос или фильтры',
                      )
                    : _Results(events: events),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearRange() {
    setState(() {
      _range = null;
      _applyFilter();
    });
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final EventCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(Scale.chipRadius),
    child: InkWell(
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Palette.ink : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(Scale.chipRadius),
          border: Border.all(color: selected ? Palette.ink : Palette.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FeedVisuals.iconFor(category),
              size: 14,
              color: selected ? Palette.paper : FeedVisuals.colorFor(category),
            ),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: Fonts.sansStyle(
                size: 12.5,
                weight: 500,
                color: selected ? Palette.paper : Palette.ink2,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RangeTile extends StatelessWidget {
  const _RangeTile({required this.range, required this.onTap, this.onClear});

  final DateTimeRange? range;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(Scale.fieldRadius),
    child: InkWell(
      borderRadius: BorderRadius.circular(Scale.fieldRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(Scale.fieldRadius),
          border: Border.all(color: Palette.line),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.date_range_rounded,
              size: 18,
              color: Palette.accent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                range == null
                    ? 'Любое время'
                    : '${DateFmt.dayMonth(range!.start)} — ${DateFmt.dayMonth(range!.end)}',
                style: Fonts.sansStyle(
                  size: 13.5,
                  color: range == null ? Palette.placeholder : Palette.ink,
                ),
              ),
            ),
            if (onClear != null)
              InkWell(
                onTap: onClear,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Palette.icon,
                  ),
                ),
              )
            else
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 20,
                color: Palette.icon,
              ),
          ],
        ),
      ),
    ),
  );
}

class _Results extends StatelessWidget {
  const _Results({required this.events});

  final List<CampusEvent> events;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    itemCount: events.length,
    separatorBuilder: (_, _) => const SizedBox(height: 10),
    itemBuilder: (context, i) => _ResultTile(event: events[i]),
  );
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final cover = event.media.isNotEmpty ? event.media.first.path : '';
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => openEventSheet(context, event.id),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Palette.line),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 76,
                    height: 76,
                    child: PhotoTile(event: event, page: 0, path: cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Fonts.sansStyle(size: 14, weight: 600),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            FeedVisuals.iconFor(event.category),
                            size: 13,
                            color: FeedVisuals.colorFor(event.category),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            event.category.label,
                            style: Fonts.monoStyle(
                              size: 10,
                              color: Palette.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${DateFmt.full(event.startAt)} · ${DateFmt.time(event.startAt)} · ${event.place.isEmpty ? 'место уточняется' : event.place}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Fonts.sansStyle(size: 11.5, color: Palette.ink2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    this.icon,
    required this.text,
    this.hint,
    this.fish = false,
  });

  final IconData? icon;
  final String text;
  final String? hint;
  final bool fish;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fish)
            const FishSchool(size: 76)
          else
            Icon(icon, size: 34, color: Palette.icon),
          const SizedBox(height: 14),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Fonts.sansStyle(size: 15, weight: 600, color: Palette.ink2),
          ),
          if (hint != null) ...[
            const SizedBox(height: 6),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: Fonts.sansStyle(
                size: 12.5,
                height: 1.4,
                color: Palette.muted,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
