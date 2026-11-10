import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../feed/media_pool.dart';
import '../shared/kit.dart';
import 'admin_common.dart';

class ModerationTab extends ConsumerStatefulWidget {
  const ModerationTab({super.key});

  @override
  ConsumerState<ModerationTab> createState() => _ModerationTabState();
}

class _ModerationTabState extends ConsumerState<ModerationTab> {
  String? _busyId;

  Future<void> _approve(CampusEvent event) async {
    setState(() => _busyId = event.id);
    try {
      final updated = await ref
          .read(repositoryProvider)
          .moderate(event.id, true);
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      ToastController.show(
        context,
        'Одобрено · статус «${updated.status.label}» — событие появилось в афише.',
      );
    } on Object catch (error) {
      if (mounted) {
        ToastController.show(
          context,
          AdminUi.failureMessage(error),
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _reject(CampusEvent event) async {
    final note = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RejectSheet(event: event),
    );
    if (note == null || note.isEmpty || !mounted) return;
    setState(() => _busyId = event.id);
    try {
      await ref.read(repositoryProvider).moderate(event.id, false, note: note);
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      ToastController.show(
        context,
        'Отклонено · причина сохранена и видна организатору.',
      );
    } on Object catch (error) {
      if (mounted) {
        ToastController.show(
          context,
          AdminUi.failureMessage(error),
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(moderationQueueProvider);
    return ListView(
      padding: AdminUi.page(context),
      children: [
        const AdminHint(
          title: 'Очередь модерации',
          text:
              'Здесь события организаторов со статусом «На проверке». Предпросмотр выглядит так же, как карточка в афише у участника. '
              'Одобрение сразу публикует событие в афише, отклонение возвращает его организатору с указанием причины.',
        ),
        queue.when(
          loading: () => const AdminLoading(text: 'Открываем очередь…'),
          error: (error, _) => AdminFailure(
            message: AdminUi.failureMessage(error),
            onRetry: () => ref.invalidate(moderationQueueProvider),
          ),
          data: (events) {
            if (events.isEmpty) {
              return const AdminEmpty(
                icon: Icons.fact_check_outlined,
                text: 'Заявок на модерацию нет',
                hint:
                    'Как только организатор отправит событие на проверку, оно появится здесь с предпросмотром афиши.',
              );
            }
            final sorted = [...events]
              ..sort((a, b) => a.startAt.compareTo(b.startAt));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DividerLabel('на проверке · ${sorted.length}'),
                for (final event in sorted)
                  _QueueCard(
                    event: event,
                    busy: _busyId == event.id,
                    blocked: _busyId != null,
                    onApprove: () => _approve(event),
                    onReject: () => _reject(event),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QueueCard extends StatelessWidget {
  const _QueueCard({
    required this.event,
    required this.busy,
    required this.blocked,
    required this.onApprove,
    required this.onReject,
  });

  final CampusEvent event;
  final bool busy;
  final bool blocked;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final note = event.moderationNote;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AdminTag(
                text: event.status.label.toUpperCase(),
                color: AdminUi.statusColor(event.status),
                icon: AdminUi.statusIcon(event.status),
                strong: true,
              ),
              const Spacer(),
              Text(
                'ID · ${event.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Fonts.monoStyle(size: 9, color: Palette.placeholder),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ParticipantPreview(event: event),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              decoration: BoxDecoration(
                color: Palette.roseSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Palette.roseLine),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MicroLabel('Примечание модератора к прошлой проверке'),
                  Text(
                    note,
                    style: Fonts.sansStyle(
                      size: 12,
                      height: 1.45,
                      color: Palette.ink2,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GhostButton(
                  label: 'Отклонить',
                  onPressed: blocked ? null : onReject,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  label: 'Одобрить',
                  busy: busy,
                  arrow: false,
                  icon: Icons.check_rounded,
                  onPressed: blocked ? null : onApprove,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            busy
                ? 'Выполняем решение…'
                : 'Одобрение публикует событие в афише, отклонение требует причины.',
            style: Fonts.monoStyle(size: 9, color: Palette.placeholder),
          ),
        ],
      ),
    );
  }
}

class _ParticipantPreview extends StatelessWidget {
  const _ParticipantPreview({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final photos = event.photos;
    final video = event.video;
    final media = event.media;
    final fields = [...event.fields]
      ..sort((a, b) => a.position.compareTo(b.position));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CoverTile(
          event: event,
          photoCount: photos.length,
          hasVideo: video != null,
        ),
        const SizedBox(height: 11),
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Fonts.sansStyle(
            size: 16.5,
            weight: 700,
            height: 1.15,
            letterSpacing: -0.4,
            color: Palette.ink,
          ),
        ),
        const SizedBox(height: 8),
        _MetaRow(
          icon: Icons.event_rounded,
          text:
              '${AdminDate.weekday(event.startAt)} · ${AdminDate.dateTime(event.startAt)}',
        ),
        _MetaRow(
          icon: Icons.place_rounded,
          text: event.place.isEmpty ? 'Место уточняется' : event.place,
        ),
        if (event.capacity >= 0)
          _MetaRow(
            icon: Icons.confirmation_number_outlined,
            text: 'Мест: ${event.capacity}',
          ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            AdminTag(
              text: event.category.label.toUpperCase(),
              color: AdminUi.categoryColor(event.category),
              icon: AdminUi.categoryIcon(event.category),
            ),
            if (media.isNotEmpty)
              AdminTag(
                text:
                    '${media.length} медиа · ${photos.length} фото${video != null ? ' · видео' : ''}',
                color: Palette.accent,
                icon: Icons.photo_library_outlined,
              )
            else
              const AdminTag(
                text: 'БЕЗ МЕДИА',
                color: Palette.muted,
                icon: Icons.image_not_supported_outlined,
              ),
            for (final field in fields)
              AdminTag(
                text: field.label.toUpperCase(),
                color: AdminUi.fieldTypeColor(field.type),
                icon: AdminUi.fieldTypeIcon(field.type),
              ),
          ],
        ),
        if (event.description.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Fonts.sansStyle(
              size: 12.5,
              height: 1.5,
              color: Palette.ink2,
            ),
          ),
        ],
        const SizedBox(height: 10),
        DividerLabel('организация · id ${event.orgId}', top: 2, bottom: 2),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Palette.icon),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Fonts.sansStyle(
              size: 12.5,
              height: 1.35,
              color: Palette.ink2,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CoverTile extends StatelessWidget {
  const _CoverTile({
    required this.event,
    required this.photoCount,
    required this.hasVideo,
  });

  final CampusEvent event;
  final int photoCount;
  final bool hasVideo;

  @override
  Widget build(BuildContext context) {
    final hasMedia = photoCount > 0 || hasVideo;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 92,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _base(),
            if (hasMedia) const _CoverScrim(),
            Positioned(
              left: 12,
              bottom: 10,
              child: Text(
                'ПРЕДПРОСМОТР УЧАСТНИКА',
                style: Fonts.monoStyle(
                  size: 8.5,
                  weight: 500,
                  letterSpacing: 0.14 * 8.5,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ),
            if (hasMedia)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(Scale.chipRadius),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasVideo
                            ? Icons.play_circle_outline_rounded
                            : Icons.photo_outlined,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        hasVideo && photoCount > 0
                            ? 'Видео · $photoCount фото'
                            : hasVideo
                            ? 'Видео'
                            : 'Фото · $photoCount',
                        style: Fonts.monoStyle(
                          size: 9,
                          weight: 500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _base() {
    final photos = event.photos;
    if (photos.isNotEmpty) {
      return PhotoTile(event: event, page: 0, path: photos.first.path);
    }
    if (hasVideo) {
      return PlaceholderTile(event: event, page: 0, video: true);
    }
    final hue = (event.category.index * 33 + 8) % 360 / 360;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.72),
            HSLColor.fromAHSL(1, hue, 0.45, 0.24).toColor(),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          AdminUi.categoryIcon(event.category),
          size: 32,
          color: Colors.white.withValues(alpha: 0.22),
        ),
      ),
    );
  }
}

class _CoverScrim extends StatelessWidget {
  const _CoverScrim();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.18),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.55),
          ],
          stops: const [0, 0.45, 1],
        ),
      ),
    ),
  );
}

class _RejectSheet extends StatefulWidget {
  const _RejectSheet({required this.event});

  final CampusEvent event;

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  final TextEditingController _note = TextEditingController();

  String _error = '';

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _note.text.trim();
    if (text.isEmpty) {
      setState(
        () => _error = 'Причина обязательна: без неё нельзя отклонить событие.',
      );
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Причина отклонения',
                style: Fonts.sansStyle(
                  size: 17,
                  weight: 700,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '«${widget.event.title}»',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
              ),
              const SizedBox(height: 12),
              GlassField(
                label: 'Что исправить организатору',
                controller: _note,
                hint: 'Например: не указана ссылка на регистрацию',
                icon: Icons.rate_review_outlined,
                autofocus: true,
                error: _error,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  if (_error.isNotEmpty) setState(() => _error = '');
                },
              ),
              Row(
                children: GhostButton.pair(
                  GhostButton(
                    label: 'Отмена',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  PrimaryButton(
                    label: 'Отклонить',
                    arrow: false,
                    icon: Icons.close_rounded,
                    onPressed: _submit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
