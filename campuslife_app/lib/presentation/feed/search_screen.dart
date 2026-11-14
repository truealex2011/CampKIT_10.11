import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import '../shared/ocean/ocean_providers.dart';
import '../shared/pixel.dart';
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
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final colors = context.colors;
        final dayBackground = WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : Colors.transparent,
        );
        final dayForeground = WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.selected)
              ? colors.paper
              : states.contains(WidgetState.disabled)
                  ? colors.placeholder
                  : colors.ink,
        );
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Theme(
              data: Theme.of(context).copyWith(
                datePickerTheme: DatePickerThemeData(
                  backgroundColor: colors.glass,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sheet),
                    side: BorderSide(color: colors.cardLine),
                  ),
                  headerHelpStyle: Fonts.monoStyle(
                    size: 9,
                    color: colors.accent,
                  ),
                  weekdayStyle: Fonts.monoStyle(size: 10, color: colors.muted),
                  dayStyle: Fonts.sansStyle(size: 13, weight: 500),
                  dayBackgroundColor: dayBackground,
                  dayForegroundColor: dayForeground,
                  todayBackgroundColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                  todayForegroundColor: WidgetStateProperty.all(colors.accent),
                  todayBorder: const BorderSide(color: Colors.transparent),
                  yearStyle: Fonts.sansStyle(size: 13, color: colors.ink2),
                  rangeSelectionBackgroundColor: colors.accentSoft,
                  rangeSelectionOverlayColor: WidgetStateProperty.all(
                    colors.accentSoft,
                  ),
                  dividerColor: colors.line,
                  cancelButtonStyle: _pickerButton(colors),
                  confirmButtonStyle: _pickerButton(colors, accent: true),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
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
      backgroundColor: context.colors.paper,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        surfaceTintColor: context.colors.paper.withValues(alpha: 0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.colors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'найди своё',
          style: Fonts.sansStyle(
            size: 22,
            weight: 500,
            color: context.colors.ink,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: OceanBackdrop(veil: 1.25)),
            Column(
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
              height: Scale.railIcon * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0),
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
                loading: () => ListView(
                  padding: EdgeInsets.all(Scale.gutter(size.width)),
                  children: const [
                    RepaintBoundary(child: PixelSkeleton()),
                    SizedBox(height: 24),
                    RepaintBoundary(child: PixelSkeleton()),
                  ],
                ),
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

ButtonStyle _pickerButton(AppColors colors, {bool accent = false}) =>
    TextButton.styleFrom(
      foregroundColor: accent ? colors.accent : colors.muted,
      textStyle: Fonts.sansStyle(size: 13, weight: accent ? 600 : 500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        side: accent
            ? BorderSide(color: colors.accentLine)
            : BorderSide(color: colors.line),
      ),
    );

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
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
    color: context.colors.paper.withValues(alpha: 0),
    borderRadius: BorderRadius.circular(Scale.chipRadius),
    child: InkWell(
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      onTap: onTap,
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppMotion.normal,
        curve: AppMotion.ease,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.colors.ink : context.colors.glassField,
          borderRadius: BorderRadius.circular(Scale.chipRadius),
          border: Border.all(
            color: selected ? context.colors.ink : context.colors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FeedVisuals.iconFor(category),
              size: 14,
              color: selected ? context.colors.paper : context.colors.accent,
            ),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: Fonts.sansStyle(
                size: 12.5,
                weight: 500,
                color: selected ? context.colors.paper : context.colors.ink2,
              ),
            ),
          ],
        ),
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
    color: context.colors.glassField,
    borderRadius: BorderRadius.circular(AppRadius.field),
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.field),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 18,
              color: context.colors.accent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                range == null
                    ? 'Любое время'
                    : '${DateFmt.dayMonth(range!.start)} — ${DateFmt.dayMonth(range!.end)}',
                style: Fonts.sansStyle(
                  size: 13.5,
                  color: range == null
                      ? context.colors.muted
                      : context.colors.ink,
                ),
              ),
            ),
            if (onClear != null)
              IconButton(
                onPressed: onClear,
                icon: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: context.colors.icon,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 20,
                color: context.colors.icon,
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
    itemBuilder: (context, i) => RiseIn(
      key: ValueKey(events[i].id),
      delay: i.clamp(0, 5) * AppMotion.fast.inMilliseconds / 1000,
      child: _ResultTile(event: events[i]),
    ),
  );
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final cover = event.photos.isNotEmpty ? event.photos.first.path : '';
    return Material(
      color: context.colors.glassField,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: context.colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openEventSheet(context, event.id),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.field),
                child: SizedBox(
                  width: 76,
                  height: 90,
                  child: PhotoTile(event: event, page: 0, path: cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.category.label.toUpperCase(),
                      style: Fonts.monoStyle(
                        size: 9,
                        color: context.colors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Fonts.sansStyle(
                        size: 14,
                        weight: 600,
                        color: context.colors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${DateFmt.full(event.startAt)} · ${DateFmt.time(event.startAt)}',
                      style: Fonts.monoStyle(
                        size: 9,
                        color: context.colors.muted,
                      ),
                    ),
                    Text(
                      event.place.isEmpty ? 'Место уточняется' : event.place,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Fonts.sansStyle(
                        size: 11.5,
                        color: context.colors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          FishSchool(size: 76, color: context.colors.icon),
          const SizedBox(height: 14),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Fonts.sansStyle(
              size: 15,
              weight: 600,
              color: context.colors.ink2,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 6),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: Fonts.sansStyle(
                size: 12.5,
                height: 1.4,
                color: context.colors.muted,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
