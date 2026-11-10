import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import 'media_pool.dart';

final organizationOfProvider = FutureProvider.family<Organization?, String>((
  ref,
  id,
) async {
  ref.watch(revisionProvider);
  return ref.read(repositoryProvider).organizationById(id);
});

Future<void> openEventSheet(BuildContext context, String eventId) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EventSheet(eventId: eventId),
    );

Future<void> openReportSheet(
  BuildContext context,
  String eventId,
  String? organizerId,
) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => ReportSheet(eventId: eventId, organizerId: organizerId),
);

class EventSheet extends ConsumerStatefulWidget {
  const EventSheet({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventSheet> createState() => _EventSheetState();
}

class _EventSheetState extends ConsumerState<EventSheet> {
  bool _busy = false;

  Future<void> _toggleRegistration(CampusEvent event) async {
    final user = ref.read(sessionProvider);
    if (user == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(repositoryProvider).toggleRegistration(event.id, user.id);
      FeedState.toggle(event.id);
      ref.read(revisionProvider.notifier).bump();
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(eventProvider(widget.eventId));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.62,
      child: Container(
        decoration: const BoxDecoration(
          color: Palette.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Palette.cardLine)),
          boxShadow: [
            BoxShadow(
              color: Color(0x400D1117),
              blurRadius: 40,
              offset: Offset(0, -12),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: async.when(
            loading: () => const Center(child: FishLoader(size: 40)),
            error: (e, _) => _SheetError(message: '$e'),
            data: (event) => event == null
                ? const _SheetError(message: 'Событие недоступно')
                : _content(context, event),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, CampusEvent event) {
    final registered = FeedState.isRegistered(event.id);
    return Column(
      children: [
        SizedBox(
          height: 28,
          child: Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Palette.lineStrong,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                FeedVisuals.iconFor(event.category),
                size: 16,
                color: FeedVisuals.colorFor(event.category),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Fonts.sansStyle(size: 17, weight: 600, height: 1.15),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 34,
                height: 34,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Palette.muted),
                ),
              ),
            ],
          ),
        ),
        const DividerLabel('детали'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            children: [
              _InfoRow(
                icon: Icons.event_rounded,
                label: 'Дата',
                value: DateFmt.full(event.startAt),
              ),
              _InfoRow(
                icon: Icons.schedule_rounded,
                label: 'Время',
                value: DateFmt.time(event.startAt),
              ),
              _InfoRow(
                icon: Icons.place_rounded,
                label: 'Место',
                value: event.place.isEmpty ? 'Уточняется' : event.place,
              ),
              if (event.description.isNotEmpty) ...[
                const DividerLabel('описание'),
                Text(
                  event.description,
                  style: Fonts.sansStyle(
                    size: 13,
                    height: 1.55,
                    color: Palette.ink2,
                  ),
                ),
              ],
              if (event.fields.isNotEmpty) ...[
                const DividerLabel('поля'),
                for (final field in event.fields)
                  _InfoRow(
                    icon: _fieldIcon(field.type),
                    label: field.label,
                    value: _fieldValue(field),
                  ),
              ],
              const DividerLabel('контакты организатора'),
              _Contacts(orgId: event.orgId),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextLink(
                  'Пожаловиться на организатора',
                  onTap: () => openReportSheet(context, event.id, event.orgId),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: registered
                  ? 'Отменить запись'
                  : event.capacity == 0
                  ? 'Мест нет'
                  : 'Записаться',
              busy: _busy,
              arrow: false,
              icon: registered ? Icons.person_off_rounded : Icons.check_rounded,
              onPressed: event.capacity == 0 && !registered
                  ? null
                  : () => _toggleRegistration(event),
            ),
          ),
        ),
      ],
    );
  }

  static IconData _fieldIcon(FieldType t) => switch (t) {
    FieldType.text => Icons.text_snippet_outlined,
    FieldType.number => Icons.pin_outlined,
    FieldType.url => Icons.link,
    FieldType.yesNo => Icons.check_box_outlined,
    FieldType.choice => Icons.list_alt,
  };

  static String _fieldValue(CustomField f) => f.value.isEmpty ? '—' : f.value;
}

class _Contacts extends ConsumerWidget {
  const _Contacts({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(organizationOfProvider(orgId)).value;
    if (org == null) {
      return Text(
        'Организация не найдена',
        style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          org.name,
          style: Fonts.sansStyle(size: 13.5, weight: 600, color: Palette.ink),
        ),
        const SizedBox(height: 8),
        if (org.phone.isNotEmpty)
          _InfoRow(
            icon: Icons.phone_rounded,
            label: 'Телефон',
            value: org.phone,
          ),
        if (org.email.isNotEmpty)
          _InfoRow(
            icon: Icons.alternate_email_rounded,
            label: 'Почта',
            value: org.email,
          ),
        if (org.phone.isEmpty && org.email.isEmpty)
          Text(
            'Контакты не указаны',
            style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Palette.muted),
        const SizedBox(width: 12),
        SizedBox(
          width: 84,
          child: Text(
            label.toUpperCase(),
            style: Fonts.monoStyle(
              size: 10,
              letterSpacing: 0.1 * 10,
              color: Palette.muted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Fonts.sansStyle(
              size: 13.5,
              height: 1.35,
              color: Palette.ink,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SheetError extends StatelessWidget {
  const _SheetError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Fonts.sansStyle(size: 13, color: Palette.muted),
      ),
    ),
  );
}

class ReportSheet extends ConsumerStatefulWidget {
  const ReportSheet({super.key, required this.eventId, this.organizerId});

  final String eventId;
  final String? organizerId;

  @override
  ConsumerState<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<ReportSheet> {
  static const _reasons = [
    'Спам или реклама',
    'Мошенничество',
    'Вводящая в заблуждение информация',
    'Неподходящий контент',
    'Отмена без предупреждения',
    'Другое',
  ];

  final TextEditingController _comment = TextEditingController();
  int _selected = 0;
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(sessionProvider);
    if (user == null) {
      ToastController.show(context, 'Сначала войди в аккаунт', error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(repositoryProvider)
          .submitReport(
            reporterId: user.id,
            target: widget.organizerId == null
                ? ReportTarget.event
                : ReportTarget.organizer,
            reason: _reasons[_selected],
            comment: _comment.text.trim(),
            eventId: widget.eventId,
            organizerId: widget.organizerId,
          );
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      Navigator.of(context).pop();
      ToastController.show(context, 'Жалоба отправлена');
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Palette.paper,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      border: Border(top: BorderSide(color: Palette.cardLine)),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Пожаловаться', style: Fonts.sansStyle(size: 17, weight: 700)),
            Text(
              'Выбери причину — модератор рассмотрит обращение.',
              style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < _reasons.length; i++)
                      _ReasonTile(
                        label: _reasons[i],
                        selected: i == _selected,
                        onTap: () => setState(() => _selected = i),
                      ),
                    const SizedBox(height: 8),
                    GlassField(
                      label: 'Комментарий (необязательно)',
                      controller: _comment,
                      hint: 'Опиши детали',
                      icon: Icons.mode_comment_outlined,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: GhostButton.pair(
                GhostButton(
                  label: 'Отмена',
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                ),
                PrimaryButton(
                  label: 'Отправить',
                  busy: _busy,
                  arrow: false,
                  icon: Icons.flag_rounded,
                  onPressed: _busy ? null : _submit,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? Palette.accentSoft : Palette.wash,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Palette.accentLine : Palette.line,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 16,
                color: selected ? Palette.accent : Palette.icon,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: Fonts.sansStyle(size: 13, color: Palette.ink2),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
