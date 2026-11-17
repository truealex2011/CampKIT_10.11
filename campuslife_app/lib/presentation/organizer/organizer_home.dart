import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../shared/app_routes.dart';
import '../shared/event_preview_screen.dart';
import '../shared/fish.dart';
import '../shared/glass_sheet.dart';
import '../shared/kit.dart';
import '../shared/ocean/ocean_providers.dart';
import 'checkin_screen.dart';
import 'organizer_common.dart';
import 'stats_view.dart';

class OrganizerHomeScreen extends ConsumerStatefulWidget {
  const OrganizerHomeScreen({super.key});

  @override
  ConsumerState<OrganizerHomeScreen> createState() =>
      _OrganizerHomeScreenState();
}

class _OrganizerHomeScreenState extends ConsumerState<OrganizerHomeScreen> {
  static const _sections = ['События', 'Анкеты', 'Команда', 'Статистика'];

  int _tab = 0;
  int _orgIndex = 0;
  String _focusEventId = '';

  Future<void> _signOut() async {
    final navigator = Navigator.of(context);
    await ref.read(sessionProvider.notifier).signOut();
    if (!navigator.mounted) return;
    navigator.pushNamedAndRemoveUntil(AppRoutes.entry, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final orgs = ref.watch(organizerOrgsProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: OceanBackdrop(veil: 1.35)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Scale.gutter(MediaQuery.sizeOf(context).width),
              ),
              child: switch (orgs) {
                AsyncData(:final value) =>
                  value.isEmpty
                      ? _ConsoleShell(
                          body: const EmptyPlate(
                            lead: 'Пусто.',
                            text:
                                'За тобой не числится ни одна организация. Обратись к админу за ключом приглашения.',
                          ),
                        )
                      : _buildOrg(value),
                AsyncError() => _ConsoleShell(
                  body: const EmptyPlate(
                    lead: 'Сбой.',
                    text: 'Не удалось загрузить организации. Попробуй позже.',
                  ),
                ),
                _ => const Center(child: FishLoader(size: 40)),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrg(List<Organization> orgs) {
    final safeIndex = _orgIndex.clamp(0, orgs.length - 1);
    final org = orgs[safeIndex];
    return _ConsoleShell(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const MicroLabel('кабинет организатора'),
              const Spacer(),
              IconButton(
                tooltip: 'Профиль',
                visualDensity: VisualDensity.compact,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.profile),
                icon: const Icon(
                  Icons.person_outline_rounded,
                  size: 20,
                  color: Palette.icon,
                ),
              ),
              IconButton(
                tooltip: 'Выйти',
                visualDensity: VisualDensity.compact,
                onPressed: _signOut,
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: Palette.icon,
                ),
              ),
            ],
          ),
          Text(
            org.name,
            style: Fonts.sansStyle(
              family: Fonts.serif,
              fallback: Fonts.serifFallback,
              size: 22,
              weight: 700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              RoleChip(label: org.type.label, dot: Palette.gold),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  org.city,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
                ),
              ),
              const Spacer(),
              _OrgIdChip(orgId: org.id),
            ],
          ),
          if (orgs.length > 1)
            MiniTabs(
              items: [for (final o in orgs) o.name],
              index: safeIndex,
              onSelect: (i) => setState(() => _orgIndex = i),
            )
          else
            const SizedBox(height: 10),
          SegTabs(
            items: _sections,
            index: _tab,
            onSelect: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 12),
        ],
      ),
      body: switch (_tab) {
        0 => _EventsTab(
          orgId: org.id,
          onOpenApplications: (eventId) => setState(() {
            _focusEventId = eventId;
            _tab = 1;
          }),
        ),
        1 => _ApplicationsTab(
          orgId: org.id,
          focusEventId: _focusEventId,
          onClearFocus: () => setState(() => _focusEventId = ''),
        ),
        2 => _RequestsTab(orgId: org.id),
        _ => StatsView(orgId: org.id),
      },
      onCreate: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.wizard, arguments: WizardArgs(orgId: org.id)),
    );
  }
}

class _OrgIdChip extends StatelessWidget {
  const _OrgIdChip({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(Scale.chipRadius),
    child: InkWell(
      borderRadius: BorderRadius.circular(Scale.chipRadius),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: orgId));
        if (!context.mounted) return;
        ToastController.show(context, 'id организации скопирован');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'id: $orgId',
              style: Fonts.monoStyle(size: 10, color: Palette.muted),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.copy_rounded, size: 13, color: Palette.icon),
          ],
        ),
      ),
    ),
  );
}

class _ConsoleShell extends StatelessWidget {
  const _ConsoleShell({required this.body, this.header, this.onCreate});

  final Widget body;
  final Widget? header;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 14),
      if (header != null) ...[header!, const SizedBox(height: 4)],
      Expanded(child: body),
      const SizedBox(height: 12),
      if (onCreate != null)
        PrimaryButton(
          label: 'Новое событие',
          icon: Icons.add_rounded,
          arrow: false,
          onPressed: onCreate,
        ),
      const SizedBox(height: 14),
    ],
  );
}

class _EventsTab extends ConsumerStatefulWidget {
  const _EventsTab({
    required this.orgId,
    required this.onOpenApplications,
  });

  final String orgId;
  final ValueChanged<String> onOpenApplications;

  @override
  ConsumerState<_EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends ConsumerState<_EventsTab> {
  static const _filters = ['Все', 'Черновики', 'Опубликовано', 'Архив'];

  final TextEditingController _search = TextEditingController();
  int _filter = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CampusEvent> _filtered(List<CampusEvent> source) {
    final query = _search.text.trim().toLowerCase();
    final now = DateTime.now();
    return source.where((event) {
      final matchesQuery =
          query.isEmpty ||
          event.title.toLowerCase().contains(query) ||
          event.place.toLowerCase().contains(query);
      if (!matchesQuery) return false;
      return switch (_filter) {
        0 => true,
        1 => event.status == EventStatus.draft,
        2 => event.status == EventStatus.published,
        _ =>
          event.status == EventStatus.cancelled ||
          event.status == EventStatus.rejected ||
          event.status == EventStatus.pendingReview ||
          !event.startAt.isAfter(now),
      };
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(organizerEventsProvider(widget.orgId));
    return switch (events) {
      AsyncData(:final value) when value.isEmpty => const EmptyPlate(
        lead: 'Ни одного события.',
        text: 'Нажми «Новое событие» и собери афишу по шагам — черновик сохранится сам.',
      ),
      AsyncData(:final value) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassField(
            label: 'поиск среди событий',
            controller: _search,
            hint: 'Название или место',
            icon: Icons.search_rounded,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          SegTabs(
            items: _filters,
            index: _filter,
            onSelect: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          Expanded(child: _list(_filtered(value))),
        ],
      ),
      AsyncError() => const EmptyPlate(
        lead: 'Сбой.',
        text: 'Список событий не загрузился. Обнови экран позже.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _list(List<CampusEvent> value) => value.isEmpty
      ? const EmptyPlate(
          lead: 'Ничего не найдено.',
          text: 'Измени поисковый запрос или выбери другой фильтр.',
        )
      : ListView.separated(
          padding: const EdgeInsets.only(top: 2, bottom: 8),
          itemCount: value.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _EventCard(
            event: value[i],
            onOpenApplications: () =>
                widget.onOpenApplications(value[i].id),
          ),
        );
}

class _EventCard extends ConsumerWidget {
  const _EventCard({
    required this.event,
    required this.onOpenApplications,
  });

  final CampusEvent event;
  final VoidCallback onOpenApplications;

  bool get _cancellable =>
      event.status == EventStatus.published ||
      event.status == EventStatus.pendingReview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title.isEmpty ? 'Без названия' : event.title,
                  style: Fonts.sansStyle(size: 15.5, weight: 600, height: 1.2),
                ),
              ),
              const SizedBox(width: 8),
              RoleChip(
                label: event.status.label,
                dot: statusDotColor(event.status),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '${RuFmt.dateTime(event.startAt)} · ${event.place.isEmpty ? 'место не указано' : event.place}',
            style: Fonts.sansStyle(size: 12, color: Palette.muted),
          ),
          const SizedBox(height: 7),
          _RegistrationsLine(event: event),
          if (event.status == EventStatus.cancelled &&
              event.cancelledAt != null) ...[
            const SizedBox(height: 5),
            Text(
              'Отменено ${RuFmt.date(event.cancelledAt!)}',
              style: Fonts.sansStyle(size: 11, color: Palette.rose),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              GhostButton(
                label: 'Посмотреть',
                icon: Icons.visibility_outlined,
                onPressed: () => EventPreviewScreen.show(context, event),
              ),
              GhostButton(
                label: 'Заявки',
                icon: Icons.description_outlined,
                onPressed: onOpenApplications,
              ),
              if (event.status != EventStatus.cancelled)
                GhostButton(
                  label: 'Редактировать',
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.wizard,
                    arguments: WizardArgs(
                      orgId: event.orgId,
                      eventId: event.id,
                    ),
                  ),
                ),
              if (event.status != EventStatus.draft &&
                  event.status != EventStatus.cancelled)
                GhostButton(
                  label: 'Проход по QR',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CheckinScreen(eventId: event.id),
                    ),
                  ),
                ),
              if (event.status == EventStatus.draft)
                GhostButton(
                  label: 'Удалить черновик',
                  onPressed: () => _confirmDelete(context, ref),
                ),
              if (_cancellable)
                TextLink(
                  'Отменить событие',
                  onTap: () => _confirmCancel(context, ref),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Отменить событие?'),
        content: const Text(
          'Все, кто записался, увидят пометку «Отменено». Событие останется в списке.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Не надо'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Да, отменить'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await ref.read(repositoryProvider).cancel(event.id);
      ref.read(revisionProvider.notifier).bump();
      if (context.mounted) ToastController.show(context, 'Событие отменено');
    } on AppException catch (e) {
      if (context.mounted) {
        ToastController.show(context, e.message, error: true);
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить черновик?'),
        content: const Text('Черновик исчезнет безвозвратно.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Не надо'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await ref.read(repositoryProvider).deleteEvent(event.id);
      ref.read(revisionProvider.notifier).bump();
      if (context.mounted) ToastController.show(context, 'Черновик удалён');
    } on AppException catch (e) {
      if (context.mounted) {
        ToastController.show(context, e.message, error: true);
      }
    }
  }
}

class _RegistrationsLine extends ConsumerWidget {
  const _RegistrationsLine({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(eventStatsProvider(event.id))) {
        AsyncData(:final value) => Text(
          event.capacity > 0
              ? 'записалось ${value.registrations} из ${event.capacity}'
              : 'записалось ${value.registrations} · лимита нет',
          style: Fonts.sansStyle(size: 12, weight: 500, color: Palette.ink2),
        ),
        AsyncError() => Text(
          'статистика пока недоступна',
          style: Fonts.sansStyle(size: 12, color: Palette.muted),
        ),
        _ => Text(
          'считаем записи…',
          style: Fonts.sansStyle(size: 12, color: Palette.muted),
        ),
      };
}

class _ApplicationsTab extends ConsumerWidget {
  const _ApplicationsTab({
    required this.orgId,
    required this.focusEventId,
    required this.onClearFocus,
  });

  final String orgId;
  final String focusEventId;
  final VoidCallback onClearFocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(organizerEventsProvider(orgId));
    return switch (events) {
      AsyncData(:final value) when value.isEmpty => const EmptyPlate(
        lead: 'Событий пока нет.',
        text: 'Заявки появятся после публикации события и отправки анкеты.',
      ),
      AsyncData(:final value) => ListView(
        children: [
          if (focusEventId.isNotEmpty) ...[
            Row(
              children: [
                const MicroLabel('только выбранное событие'),
                const Spacer(),
                TextLink('Все заявки', onTap: onClearFocus),
              ],
            ),
            const SizedBox(height: 6),
          ],
          for (final event in value)
            if (focusEventId.isEmpty || event.id == focusEventId)
              _EventApplicationsSection(event: event),
          if (focusEventId.isNotEmpty &&
              !value.any((event) => event.id == focusEventId))
            const EmptyPlate(
              lead: 'Событие не найдено.',
              text: 'Возможно, оно было удалено. Покажи все заявки.',
            ),
        ],
      ),
      AsyncError() => const EmptyPlate(
        lead: 'Сбой.',
        text: 'Не удалось загрузить заявки.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }
}

class _EventApplicationsSection extends ConsumerWidget {
  const _EventApplicationsSection({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(eventApplicationsProvider(event.id));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: switch (applications) {
        AsyncData(:final value) when value.isEmpty => const SizedBox.shrink(),
        AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                event.title,
                style: Fonts.sansStyle(size: 15, weight: 700),
              ),
            ),
            for (final application in value)
              _ApplicationCard(application: application, event: event),
          ],
        ),
        AsyncError() => const SizedBox.shrink(),
        _ => const Padding(
          padding: EdgeInsets.all(12),
          child: Center(child: FishLoader(size: 28)),
        ),
      },
    );
  }
}

class _ApplicationCard extends ConsumerWidget {
  const _ApplicationCard({required this.application, required this.event});

  final EventApplication application;
  final CampusEvent event;

  void _openDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassSheet(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.mail_outline_rounded, size: 24, color: Palette.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Анкета: ${application.applicantName}',
                      style: Fonts.sansStyle(size: 18, weight: 700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Почта: ${application.applicantEmail}', style: Fonts.sansStyle(size: 13, color: Palette.muted)),
              if (application.applicantPhone.isNotEmpty)
                Text('Телефон: ${application.applicantPhone}', style: Fonts.sansStyle(size: 13, color: Palette.muted)),
              Text('Отправлено: ${RuFmt.dateTime(application.createdAt)}', style: Fonts.sansStyle(size: 12, color: Palette.muted)),
              const DividerLabel('Ответы на вопросы', top: 12),
              for (final field in event.fields)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(field.label, style: Fonts.sansStyle(size: 13, weight: 600)),
                      const SizedBox(height: 2),
                      Text(application.answers[field.id] ?? '—', style: Fonts.sansStyle(size: 13.5, color: Palette.ink2)),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              if (application.status == 'pending')
                Row(
                  children: GhostButton.pair(
                    GhostButton(
                      label: 'Одобрить заявку',
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _resolve(context, ref, true);
                      },
                    ),
                    GhostButton(
                      label: 'Отклонить',
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _resolve(context, ref, false);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: GlassCard(
      child: InkWell(
        onTap: () => _openDetails(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(application.applicantName, style: Fonts.sansStyle(size: 14, weight: 700)),
                ),
                RoleChip(
                  label: application.status == 'approved'
                      ? 'Одобрено'
                      : application.status == 'rejected'
                          ? 'Отклонено'
                          : 'Ожидает',
                  dot: application.status == 'approved'
                      ? Palette.mint
                      : application.status == 'rejected'
                          ? Palette.rose
                          : Palette.gold,
                ),
              ],
            ),
            Text(application.applicantEmail, style: Fonts.sansStyle(size: 12, color: Palette.muted)),
            const SizedBox(height: 6),
            Text(
              'Нажми, чтобы открыть полную анкету с ответами',
              style: Fonts.sansStyle(size: 11.5, color: Palette.accent),
            ),
            if (application.status == 'pending') ...[
              const SizedBox(height: 8),
              Row(
                children: GhostButton.pair(
                  GhostButton(label: 'Одобрить', onPressed: () => _resolve(context, ref, true)),
                  GhostButton(label: 'Отклонить', onPressed: () => _resolve(context, ref, false)),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  Future<void> _resolve(BuildContext context, WidgetRef ref, bool approve) async {
    try {
      await ref.read(repositoryProvider).resolveApplication(application.id, approve);
      ref.read(revisionProvider.notifier).bump();
    } on AppException catch (error) {
      if (context.mounted) ToastController.show(context, error.message, error: true);
    }
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(pendingMembersProvider(orgId));
    return switch (members) {
      AsyncData(:final value) =>
        value.isEmpty
            ? const EmptyPlate(
                lead: 'Заявок нет.',
                text:
                    'Когда кто-то попросит вступить в организацию, заявка появится здесь.',
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                itemCount: value.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) =>
                    _MemberCard(orgId: orgId, member: value[i]),
              ),
      AsyncError() => const EmptyPlate(
        lead: 'Сбой.',
        text: 'Заявки не загрузились. Обнови экран позже.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }
}

class _MemberCard extends ConsumerWidget {
  const _MemberCard({required this.orgId, required this.member});

  final String orgId;
  final OrgMember member;

  void _openCard(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassSheet(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.badge_rounded, size: 24, color: Palette.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Визитка кандидата',
                      style: Fonts.sansStyle(size: 18, weight: 700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _DetailField(label: 'Имя и фамилия', value: member.name?.isNotEmpty == true ? member.name! : member.userId),
              if (member.email != null && member.email!.isNotEmpty)
                _DetailField(label: 'Почта', value: member.email!),
              if (member.phone != null && member.phone!.isNotEmpty)
                _DetailField(label: 'Телефон', value: member.phone!),
              _DetailField(
                label: 'О себе / визитка',
                value: member.note.isNotEmpty ? member.note : 'Информация не указана',
              ),
              _DetailField(
                label: 'Дата заявки',
                value: RuFmt.dateTime(member.requestedAt),
              ),
              const SizedBox(height: 16),
              Row(
                children: GhostButton.pair(
                  GhostButton(
                    label: 'Принять в команду',
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _resolve(context, ref, true);
                    },
                  ),
                  GhostButton(
                    label: 'Отклонить',
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _resolve(context, ref, false);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => GlassCard(
    child: InkWell(
      onTap: () => _openCard(context, ref),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_search_rounded,
                size: 16,
                color: Palette.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  member.name?.isNotEmpty == true ? member.name! : member.userId,
                  style: Fonts.sansStyle(
                    size: 13.5,
                    weight: 600,
                    color: Palette.ink,
                  ),
                ),
              ),
              Text(
                RuFmt.date(member.requestedAt),
                style: Fonts.sansStyle(size: 11, color: Palette.muted),
              ),
            ],
          ),
          if (member.note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              member.note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Fonts.sansStyle(size: 12, color: Palette.ink2),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Нажми, чтобы открыть полную визитку',
                style: Fonts.sansStyle(size: 11.5, color: Palette.accent),
              ),
              const Spacer(),
              GhostButton(
                label: 'Визитка',
                icon: Icons.badge_outlined,
                onPressed: () => _openCard(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: GhostButton.pair(
              GhostButton(
                label: 'Одобрить',
                onPressed: () => _resolve(context, ref, true),
              ),
              GhostButton(
                label: 'Отклонить',
                onPressed: () => _resolve(context, ref, false),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _resolve(
    BuildContext context,
    WidgetRef ref,
    bool approve,
  ) async {
    try {
      await ref
          .read(repositoryProvider)
          .resolveMembership(orgId, member.userId, approve);
      ref.read(revisionProvider.notifier).bump();
      if (context.mounted) {
        ToastController.show(
          context,
          approve ? 'Участник одобрен' : 'Заявка отклонена',
        );
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastController.show(context, e.message, error: true);
      }
    }
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Fonts.monoStyle(size: 10, color: Palette.muted)),
        const SizedBox(height: 2),
        Text(value, style: Fonts.sansStyle(size: 13.5, color: Palette.ink)),
      ],
    ),
  );
}
