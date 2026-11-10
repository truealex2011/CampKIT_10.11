import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../shared/app_routes.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
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
  static const _sections = ['События', 'Заявки', 'Статистика'];

  int _tab = 0;
  int _orgIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orgs = ref.watch(organizerOrgsProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
          const MicroLabel('кабинет организатора'),
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
        0 => _EventsTab(orgId: org.id),
        1 => _RequestsTab(orgId: org.id),
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

class _EventsTab extends ConsumerWidget {
  const _EventsTab({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(organizerEventsProvider(orgId));
    return switch (events) {
      AsyncData(:final value) =>
        value.isEmpty
            ? const EmptyPlate(
                lead: 'Ни одного события.',
                text:
                    'Нажми «Новое событие» и собери афишу по шагам — черновик сохранится сам.',
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                itemCount: value.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _EventCard(event: value[i]),
              ),
      AsyncError() => const EmptyPlate(
        lead: 'Сбой.',
        text: 'Список событий не загрузился. Обнови экран позже.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({required this.event});

  final CampusEvent event;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) => GlassCard(
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
                member.userId,
                style: Fonts.monoStyle(
                  size: 12.5,
                  color: Palette.ink,
                  letterSpacing: 0,
                ),
              ),
            ),
            Text(
              RuFmt.date(member.requestedAt),
              style: Fonts.sansStyle(size: 11, color: Palette.muted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'просит доступ к организации',
          style: Fonts.sansStyle(size: 11.5, color: Palette.muted),
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
