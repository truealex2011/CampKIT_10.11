import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../feed/media_pool.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';

final eventStatsProvider = FutureProvider.family<EventStats, String>((
  ref,
  eventId,
) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).statsOf(eventId);
});

final pendingMembersProvider = FutureProvider.family<List<OrgMember>, String>((
  ref,
  orgId,
) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).pendingMembers(orgId);
});

final orgStatsProvider = FutureProvider.family<List<EventStats>, String>((
  ref,
  orgId,
) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).statsFor(orgId);
});

final eventDailyProvider = FutureProvider.family<List<DayCount>, String>((
  ref,
  eventId,
) async {
  ref.watch(revisionProvider);
  return ref.watch(repositoryProvider).dailyStats(eventId);
});

abstract final class Ids {
  static final Random _random = Random.secure();

  static String next(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(0xFFFFFF)}';
}

abstract final class RuFmt {
  static bool _ready = false;

  static void _ensure() {
    if (_ready) return;
    _ready = true;
    try {
      initializeDateFormatting('ru');
    } catch (_) {}
  }

  static String dateTime(DateTime d) {
    _ensure();
    return DateFormat('d MMMM, HH:mm', 'ru').format(d);
  }

  static String date(DateTime d) {
    _ensure();
    return DateFormat('d MMMM yyyy', 'ru').format(d);
  }

  static String dayShort(DateTime d) {
    _ensure();
    return DateFormat('d MMM', 'ru').format(d);
  }

  static String time(DateTime d) {
    _ensure();
    return DateFormat('HH:mm', 'ru').format(d);
  }
}

Color statusDotColor(EventStatus status) => switch (status) {
  EventStatus.draft => Palette.muted,
  EventStatus.pendingReview => Palette.gold,
  EventStatus.published => Palette.mint,
  EventStatus.rejected => Palette.rose,
  EventStatus.cancelled => Palette.rose,
};

class ParticipantPreview extends StatelessWidget {
  const ParticipantPreview({super.key, required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final photos = event.photos;
    final video = event.video;
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (video != null || photos.isNotEmpty) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: video != null
                    ? PlaceholderTile(event: event, page: 0, video: true)
                    : PhotoTile(event: event, page: 0, path: photos.first.path),
              ),
            ),
            if (photos.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '+${photos.length - 1} фото в карусели',
                  style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
                ),
              ),
          ],
          const SizedBox(height: 12),
          Text(
            event.title.isEmpty ? 'Без названия' : event.title,
            style: Fonts.sansStyle(size: 19, weight: 700, height: 1.15),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              RoleChip(
                label: event.category.label,
                dot: FeedVisuals.colorFor(event.category),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 13,
                color: Palette.muted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  RuFmt.dateTime(event.startAt),
                  style: Fonts.sansStyle(size: 13, color: Palette.ink2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 13, color: Palette.muted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.place.isEmpty ? 'Место не указано' : event.place,
                  style: Fonts.sansStyle(size: 13, color: Palette.ink2),
                ),
              ),
            ],
          ),
          if (event.capacity > 0) ...[
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  Icons.local_see_rounded,
                  size: 13,
                  color: Palette.muted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Мест: ${event.capacity}',
                  style: Fonts.sansStyle(size: 13, color: Palette.ink2),
                ),
              ],
            ),
          ],
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: 9),
            Text(
              event.description,
              style: Fonts.sansStyle(
                size: 12.5,
                height: 1.45,
                color: Palette.muted,
              ),
            ),
          ],
          if (event.fields.isNotEmpty) ...[
            DividerLabel('Анкета на вход'),
            for (final f in event.fields)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            f.label,
                            style: Fonts.sansStyle(size: 13),
                          ),
                        ),
                        Text(
                          f.type.label,
                          style: Fonts.monoStyle(
                            size: 9.5,
                            color: Palette.muted,
                          ),
                        ),
                      ],
                    ),
                    if (f.type == FieldType.choice && f.options.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          f.options.join(' · '),
                          style: Fonts.sansStyle(
                            size: 11,
                            color: Palette.muted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class EmptyPlate extends StatelessWidget {
  const EmptyPlate({super.key, required this.lead, required this.text});

  final String lead;
  final String text;

  @override
  Widget build(BuildContext context) => GlassCard(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        const Center(child: FishSchool(size: 84)),
        const SizedBox(height: 10),
        NoteBlock(lead: lead, text: text),
        const SizedBox(height: 4),
      ],
    ),
  );
}
