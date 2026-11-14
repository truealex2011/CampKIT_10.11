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
    final colors = context.colors;
    final photos = event.photos;
    final video = event.video;
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (video != null || photos.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: photos.isNotEmpty
                    ? PhotoTile(event: event, page: 0, path: photos.first.path)
                    : PlaceholderTile(event: event, page: 0, video: true),
              ),
            ),
            if (photos.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${photos.length - 1} фото в карусели',
                  style: Fonts.monoStyle(size: 10, color: colors.muted),
                ),
              ),
            const SizedBox(height: 16),
          ],
          Text(
            event.title.isEmpty ? 'Без названия' : event.title,
            style: Fonts.sansStyle(
              size: 20, weight: 700, height: 1.2, color: colors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              RoleChip(label: event.category.label, dot: colors.accent),
            ],
          ),
          const SizedBox(height: 16),
          _PreviewMetadata(
            icon: Icons.calendar_today_rounded,
            text: RuFmt.dateTime(event.startAt),
          ),
          _PreviewMetadata(
            icon: Icons.place_outlined,
            text: event.place.isEmpty ? 'Место не указано' : event.place,
          ),
          if (event.capacity > 0)
            _PreviewMetadata(
              icon: Icons.confirmation_number_outlined,
              text: 'Мест: ${event.capacity}',
            ),
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              event.description,
              style: Fonts.sansStyle(
                size: 13, height: 1.5, color: colors.ink2,
              ),
            ),
          ],
          if (event.fields.isNotEmpty) ...[
            const DividerLabel('Анкета на вход'),
            for (final field in event.fields)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field.label, style: Fonts.sansStyle(
                      size: 13, weight: 600, color: colors.ink,
                    )),
                    const SizedBox(height: 4),
                    Text(field.type.label, style: Fonts.monoStyle(
                      size: 10, color: colors.muted,
                    )),
                    if (field.type == FieldType.choice && field.options.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(field.options.join(' · '),
                          style: Fonts.sansStyle(size: 12, color: colors.ink2),
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

class _PreviewMetadata extends StatelessWidget {
  const _PreviewMetadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.colors.accent),
        const SizedBox(width: 8),
        Expanded(child: Text(text,
          style: Fonts.sansStyle(size: 13, height: 1.4, color: context.colors.ink2),
        )),
      ],
    ),
  );
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
