import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';

abstract final class AdminUi {
  static const tabs = ['Модерация', 'Ключи', 'Управление', 'Жалобы'];

  static const hiddenByAdminNote = 'Скрыто администратором';

  static double gutter(BuildContext context) =>
      Scale.gutter(MediaQuery.sizeOf(context).width);

  static EdgeInsets page(BuildContext context) {
    final gutter = AdminUi.gutter(context) * 0.62;
    return EdgeInsets.fromLTRB(gutter, 8, gutter, 38);
  }

  static String failureMessage(Object error) => error is AppException
      ? error.message
      : 'Не удалось получить данные. Обнови раздел.';

  static Color statusColor(EventStatus status) => switch (status) {
    EventStatus.draft => Palette.muted,
    EventStatus.pendingReview => Palette.gold,
    EventStatus.published => Palette.mint,
    EventStatus.rejected => Palette.rose,
    EventStatus.cancelled => Palette.ink2,
  };

  static IconData statusIcon(EventStatus status) => switch (status) {
    EventStatus.draft => Icons.edit_note_rounded,
    EventStatus.pendingReview => Icons.hourglass_top_rounded,
    EventStatus.published => Icons.public_rounded,
    EventStatus.rejected => Icons.do_not_disturb_on_outlined,
    EventStatus.cancelled => Icons.event_busy_rounded,
  };

  static Color categoryColor(EventCategory category) => switch (category) {
    EventCategory.sport => Palette.mint,
    EventCategory.art => Palette.gold,
    EventCategory.science => Palette.accent,
    EventCategory.contest => Palette.rose,
    EventCategory.lecture => Palette.ink2,
    EventCategory.music => Palette.accent,
    EventCategory.volunteer => Palette.mint,
    EventCategory.outing => Palette.gold,
  };

  static IconData categoryIcon(EventCategory category) => switch (category) {
    EventCategory.sport => Icons.sports_volleyball_rounded,
    EventCategory.art => Icons.brush_rounded,
    EventCategory.science => Icons.science_rounded,
    EventCategory.contest => Icons.emoji_events_rounded,
    EventCategory.lecture => Icons.mic_rounded,
    EventCategory.music => Icons.music_note_rounded,
    EventCategory.volunteer => Icons.volunteer_activism_rounded,
    EventCategory.outing => Icons.alt_route_rounded,
  };

  static Color fieldTypeColor(FieldType type) => switch (type) {
    FieldType.text => Palette.ink2,
    FieldType.number => Palette.accent,
    FieldType.url => Palette.accent,
    FieldType.yesNo => Palette.mint,
    FieldType.choice => Palette.gold,
  };

  static IconData fieldTypeIcon(FieldType type) => switch (type) {
    FieldType.text => Icons.text_snippet_outlined,
    FieldType.number => Icons.pin_outlined,
    FieldType.url => Icons.link_rounded,
    FieldType.yesNo => Icons.check_box_outlined,
    FieldType.choice => Icons.list_alt_rounded,
  };

  static String targetLabel(ReportTarget target) => switch (target) {
    ReportTarget.event => 'Событие',
    ReportTarget.organizer => 'Организатор',
  };

  static String reportActionLabel(ReportStatus status) => switch (status) {
    ReportStatus.open => 'В работе',
    ReportStatus.eventHidden => 'Скрыть событие',
    ReportStatus.organizerWarned => 'Предупредить организатора',
    ReportStatus.organizerBlocked => 'Заблокировать организатора',
    ReportStatus.dismissed => 'Отклонить жалобу',
  };

  static String reportDoneLabel(ReportStatus status) => switch (status) {
    ReportStatus.eventHidden => 'Событие скрыто — его больше нет в афише.',
    ReportStatus.organizerWarned => 'Организатор предупреждён.',
    ReportStatus.organizerBlocked =>
      'Организатор заблокирован — все его события скрыты из афиши.',
    ReportStatus.dismissed => 'Жалоба отклонена.',
    ReportStatus.open => 'Жалоба оставлена открытой.',
  };

  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '—';
    final first = parts.first;
    final second = parts.length > 1 ? parts.elementAt(1) : '';
    final letters =
        '${first.substring(0, 1)}${second.isEmpty ? '' : second.substring(0, 1)}';
    return letters.toUpperCase();
  }
}

abstract final class AdminDate {
  static const _months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  static const _weekdays = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

  static bool _bootstrapped = false;
  static bool _intlReady = false;

  static void bootstrap() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    initializeDateFormatting(
      'ru',
    ).then((_) => _intlReady = true).catchError((_) => false);
  }

  static String time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  static String dayMonth(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.'
      '${value.month.toString().padLeft(2, '0')}.'
      '${value.year}';

  static String stamp(DateTime value) => '${dayMonth(value)} ${time(value)}';

  static String weekday(DateTime value) => _weekdays[value.weekday - 1];

  static String fullDate(DateTime value) {
    bootstrap();
    final manual = '${value.day} ${_months[value.month - 1]} ${value.year}';
    if (!_intlReady) return manual;
    return _capitalize(_format('d MMMM yyyy', value) ?? manual);
  }

  static String dateTime(DateTime value) {
    bootstrap();
    final manual =
        '${value.day} ${_months[value.month - 1]} ${value.year}, ${time(value)}';
    if (!_intlReady) return manual;
    return _capitalize(_format('d MMMM yyyy, HH:mm', value) ?? manual);
  }

  static String _capitalize(String text) =>
      text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';

  static String? _format(String pattern, DateTime value) {
    try {
      return DateFormat(pattern, 'ru').format(value);
    } on Object {
      return null;
    }
  }
}

class AdminCard extends StatelessWidget {
  const AdminCard({
    super.key,
    required this.child,
    this.bottom = 10,
    this.top = 0,
  });

  final Widget child;
  final double bottom;
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: top, bottom: bottom),
    child: Center(child: GlassCard(child: child)),
  );
}

class AdminTag extends StatelessWidget {
  const AdminTag({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.strong = false,
  });

  final String text;
  final Color color;
  final IconData? icon;
  final bool strong;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(9, 5, 10, 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: strong ? 0.15 : 0.07),
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      border: Border.all(color: color.withValues(alpha: strong ? 0.5 : 0.28)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Fonts.monoStyle(
              size: 9.5,
              weight: 600,
              letterSpacing: 0.1 * 9.5,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}

class AdminKeyValue extends StatelessWidget {
  const AdminKeyValue({
    super.key,
    required this.label,
    required this.value,
    this.color = Palette.ink2,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label.toUpperCase(),
            style: Fonts.monoStyle(
              size: 9.5,
              letterSpacing: 0.1 * 9.5,
              color: Palette.muted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Fonts.sansStyle(size: 12.5, height: 1.35, color: color),
          ),
        ),
      ],
    ),
  );
}

class AdminLoading extends StatelessWidget {
  const AdminLoading({super.key, this.text = 'Загружаем…'});

  final String text;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: FishLoader(size: 16, color: Palette.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
          ),
        ),
      ],
    ),
  );
}

class AdminFailure extends StatelessWidget {
  const AdminFailure({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.cloud_off_rounded, size: 16, color: Palette.rose),
            const SizedBox(width: 8),
            Text(
              'Раздел не открылся',
              style: Fonts.sansStyle(
                size: 13.5,
                weight: 600,
                color: Palette.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Fonts.sansStyle(size: 12.5, height: 1.45, color: Palette.ink2),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          GhostButton(label: 'Обновить раздел', onPressed: onRetry),
        ],
      ],
    ),
  );
}

class AdminEmpty extends StatelessWidget {
  const AdminEmpty({
    super.key,
    required this.text,
    required this.hint,
    this.icon = Icons.inbox_rounded,
  });

  final String text;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Palette.icon),
        const SizedBox(height: 10),
        Text(
          text,
          style: Fonts.sansStyle(size: 14, weight: 600, color: Palette.ink),
        ),
        const SizedBox(height: 5),
        Text(
          hint,
          style: Fonts.sansStyle(size: 12, height: 1.45, color: Palette.muted),
        ),
      ],
    ),
  );
}

class AdminHint extends StatelessWidget {
  const AdminHint({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => AdminCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MicroLabel(title),
        Text(
          text,
          style: Fonts.sansStyle(size: 12, height: 1.5, color: Palette.ink2),
        ),
      ],
    ),
  );
}

Future<bool> adminConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  String cancelLabel = 'Отмена',
}) async {
  final answer = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: Palette.paper,
          borderRadius: BorderRadius.circular(Scale.cardRadiusNarrow),
          border: Border.all(color: Palette.cardLine),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D0D1117),
              blurRadius: 40,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Fonts.sansStyle(
                size: 15.5,
                weight: 700,
                color: Palette.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Fonts.sansStyle(
                size: 12.5,
                height: 1.45,
                color: Palette.ink2,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: GhostButton.pair(
                GhostButton(
                  label: cancelLabel,
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                PrimaryButton(
                  label: confirmLabel,
                  arrow: false,
                  icon: Icons.check_rounded,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return answer ?? false;
}

Future<void> adminCopy(
  BuildContext context,
  String value, {
  String? done,
}) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) return;
  ToastController.show(context, done ?? 'Скопировано в буфер обмена');
}
