import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart';
import '../shared/kit.dart';
import 'admin_common.dart';

final _usersProvider = FutureProvider<List<User>>((ref) async {
  ref.watch(revisionProvider);
  return ref.read(repositoryProvider).users();
});

final _organizationsProvider = FutureProvider<List<Organization>>((ref) async {
  ref.watch(revisionProvider);
  return ref.read(repositoryProvider).organizations();
});

final _allEventsProvider = FutureProvider<List<CampusEvent>>((ref) async {
  ref.watch(revisionProvider);
  return ref.read(repositoryProvider).allEvents();
});

class ManagementTab extends ConsumerStatefulWidget {
  const ManagementTab({super.key});

  @override
  ConsumerState<ManagementTab> createState() => _ManagementTabState();
}

class _ManagementTabState extends ConsumerState<ManagementTab> {
  static const _sections = ['Пользователи', 'Организации', 'События'];
  static const _allStatuses = 'Все статусы';

  final TextEditingController _search = TextEditingController();

  int _section = 0;
  String _query = '';
  String? _statusFilter;
  String? _busyId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _matchesSearch => _query.isEmpty;

  bool _hit(String value) =>
      _query.isEmpty || value.toLowerCase().contains(_query);

  Future<void> _run(
    String id,
    Future<void> Function() action, {
    required String done,
  }) async {
    setState(() => _busyId = id);
    try {
      await action();
      ref.read(revisionProvider.notifier).bump();
      if (!mounted) return;
      ToastController.show(context, done);
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

  Future<void> _blockUser(User user, bool blocked) async {
    if (blocked) {
      final ok = await adminConfirm(
        context,
        title: 'Заблокировать пользователя?',
        body:
            '${user.name} потеряет вход в CampusLife: афиша, записи и билеты станут недоступны. '
            'Разблокировка вернёт аккаунт.',
        confirmLabel: 'Заблокировать',
      );
      if (!ok || !mounted) return;
    }
    await _run(
      user.id,
      () => ref.read(repositoryProvider).blockUser(user.id, blocked),
      done: blocked
          ? 'Пользователь заблокирован.'
          : 'Пользователь разблокирован и снова видит афишу.',
    );
  }

  Future<void> _blockOrganization(Organization org, bool blocked) async {
    if (blocked) {
      final ok = await adminConfirm(
        context,
        title: 'Заблокировать организацию?',
        body:
            '«${org.name}» не сможет публиковать события, а все события организации скрываются из афиши. '
            'Разблокировка вернёт опубликованные события.',
        confirmLabel: 'Заблокировать',
      );
      if (!ok || !mounted) return;
    }
    await _run(
      org.id,
      () => ref.read(repositoryProvider).blockOrganization(org.id, blocked),
      done: blocked
          ? 'Организация заблокирована — все её события скрыты из афиши.'
          : 'Организация разблокирована.',
    );
  }

  Future<void> _hideEvent(CampusEvent event) async {
    final ok = await adminConfirm(
      context,
      title: 'Скрыть событие из афиши?',
      body:
          '«${event.title}» получит статус «${EventStatus.rejected.label}» с примечанием '
          '«${AdminUi.hiddenByAdminNote}» и исчезнет из афиши у участников.',
      confirmLabel: 'Скрыть',
    );
    if (!ok || !mounted) return;
    await _run(event.id, () async {
      await ref
          .read(repositoryProvider)
          .moderate(event.id, false, note: AdminUi.hiddenByAdminNote);
    }, done: 'Событие скрыто из афиши.');
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(sessionProvider);
    return ListView(
      padding: AdminUi.page(context),
      children: [
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MicroLabel('Управление каталогом'),
              MiniTabs(
                items: _sections,
                index: _section,
                onSelect: (index) => setState(() => _section = index),
              ),
              GlassField(
                label: _section == 2
                    ? 'Поиск по названию события'
                    : 'Поиск по названию',
                controller: _search,
                hint: _section == 0
                    ? 'Имя или почта'
                    : _section == 1
                    ? 'Название или город'
                    : 'Заголовок события',
                icon: Icons.search_rounded,
                onChanged: (value) =>
                    setState(() => _query = value.trim().toLowerCase()),
              ),
              if (_section == 2)
                GlassSelect(
                  label: 'Статус события',
                  value: _statusFilter ?? _allStatuses,
                  items: [
                    _allStatuses,
                    ...EventStatus.values.map((s) => s.label),
                  ],
                  onChanged: (value) => setState(
                    () => _statusFilter =
                        (value == null || value == _allStatuses) ? null : value,
                  ),
                  icon: Icons.filter_alt_outlined,
                  placeholder: _allStatuses,
                ),
              const NoteBlock(
                text:
                    'Поиск фильтрует список на устройстве. Любое действие обновляет счётчики и афишу.',
              ),
            ],
          ),
        ),
        ..._body(me),
      ],
    );
  }

  List<Widget> _body(User? me) => switch (_section) {
    0 => _users(me),
    1 => _organizations(),
    _ => _events(),
  };

  List<Widget> _users(User? me) {
    final async = ref.watch(_usersProvider);
    return [
      _asyncSection<User>(
        async: async,
        loading: 'Загружаем пользователей…',
        emptyTitle: 'Пользователей нет',
        emptyHint: 'Данные появятся, как только кто-то зарегистрируется.',
        retry: () => ref.invalidate(_usersProvider),
        matches: (user) =>
            _hit(user.name) || _hit(user.email) || _hit(user.phone),
        tile: (user) => _UserTile(
          user: user,
          isMe: me != null && me.id == user.id,
          busy: _busyId == user.id,
          locked: _busyId != null,
          onBlock: () => _blockUser(user, !user.banned),
        ),
      ),
    ];
  }

  List<Widget> _organizations() {
    final async = ref.watch(_organizationsProvider);
    return [
      _asyncSection<Organization>(
        async: async,
        loading: 'Загружаем организации…',
        emptyTitle: 'Организаций нет',
        emptyHint:
            'Организации появляются после регистрации по приглашающему ключу.',
        retry: () => ref.invalidate(_organizationsProvider),
        matches: (org) => _hit(org.name) || _hit(org.city) || _hit(org.email),
        tile: (org) => _OrganizationTile(
          org: org,
          busy: _busyId == org.id,
          locked: _busyId != null,
          onBlock: () => _blockOrganization(org, !org.blocked),
        ),
      ),
    ];
  }

  List<Widget> _events() {
    final async = ref.watch(_allEventsProvider);
    final orgs = ref.watch(_organizationsProvider).value ?? const [];
    final orgById = {for (final org in orgs) org.id: org};
    return [
      _asyncSection<CampusEvent>(
        async: async,
        loading: 'Загружаем события…',
        emptyTitle: 'Событий ещё нет',
        emptyHint: 'Организаторы создадут события через мастер публикации.',
        retry: () => ref.invalidate(_allEventsProvider),
        matches: (event) =>
            _hit(event.title) &&
            (_statusFilter == null || event.status.label == _statusFilter),
        tile: (event) {
          final org = orgById[event.orgId];
          return _EventTile(
            event: event,
            orgName: org?.name ?? 'Организация ${event.orgId}',
            hiddenReason: _hiddenReason(event, org),
            busy: _busyId == event.id,
            locked: _busyId != null,
            onHide: () => _hideEvent(event),
          );
        },
      ),
    ];
  }

  String? _hiddenReason(CampusEvent event, Organization? org) {
    if (event.status == EventStatus.published) {
      return org != null && org.blocked
          ? 'Все события организации скрыты из афиши'
          : null;
    }
    if (event.status == EventStatus.rejected &&
        event.moderationNote == AdminUi.hiddenByAdminNote) {
      return 'Скрыто администратором';
    }
    return null;
  }

  Widget _asyncSection<T>({
    required AsyncValue<List<T>> async,
    required String loading,
    required String emptyTitle,
    required String emptyHint,
    required VoidCallback retry,
    required bool Function(T) matches,
    required Widget Function(T) tile,
  }) => async.when(
    loading: () => AdminLoading(text: loading),
    error: (error, _) =>
        AdminFailure(message: AdminUi.failureMessage(error), onRetry: retry),
    data: (list) {
      final found = list.where(matches).toList(growable: false);
      if (found.isEmpty) {
        return AdminEmpty(
          icon: _section == 0
              ? Icons.group_outlined
              : _section == 1
              ? Icons.account_balance_outlined
              : Icons.event_available_outlined,
          text: list.isEmpty ? emptyTitle : 'Ничего не найдено',
          hint: list.isEmpty
              ? emptyHint
              : _matchesSearch
              ? emptyHint
              : 'Уточни запрос или сбрось фильтр статуса.',
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DividerLabel('всего ${list.length} · показано ${found.length}'),
          for (final item in found) tile(item),
        ],
      );
    },
  );
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.isMe,
    required this.busy,
    required this.locked,
    required this.onBlock,
  });

  final User user;
  final bool isMe;
  final bool busy;
  final bool locked;
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    final banned = user.banned;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(
                label: AdminUi.initialsOf(user.name),
                color: banned ? Palette.rose : Palette.roleDot(user.role),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Fonts.sansStyle(
                        size: 14,
                        weight: 600,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AdminTag(
                text: user.role.label.toUpperCase(),
                color: Palette.roleDot(user.role),
                icon: Icons.person_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              AdminTag(
                text: banned ? 'ЗАБЛОКИРОВАН' : 'АКТИВЕН',
                color: banned ? Palette.rose : Palette.mint,
                icon: banned
                    ? Icons.block_rounded
                    : Icons.check_circle_outline_rounded,
                strong: banned,
              ),
              if (isMe)
                const AdminTag(
                  text: 'ТЕКУЩИЙ АККАУНТ',
                  color: Palette.ink2,
                  icon: Icons.badge_outlined,
                ),
              if (user.phone.isNotEmpty)
                AdminTag(
                  text: user.phone,
                  color: Palette.accent,
                  icon: Icons.phone_rounded,
                ),
            ],
          ),
          const SizedBox(height: 8),
          AdminKeyValue(label: 'ID', value: user.id, color: Palette.muted),
          const SizedBox(height: 6),
          if (isMe)
            const NoteBlock(
              text:
                  'Это твой аккаунт администратора — блокировка доступна для остальных пользователей.',
            )
          else
            Row(
              children: [
                Expanded(
                  child: busy
                      ? const PrimaryButton(
                          label: 'Выполняем',
                          busy: true,
                          arrow: false,
                        )
                      : GhostButton(
                          label: banned
                              ? 'Разблокировать пользователя'
                              : 'Заблокировать пользователя',
                          onPressed: locked ? null : onBlock,
                        ),
                ),
              ],
            ),
          if (!isMe) const SizedBox(height: 6),
          if (!isMe)
            NoteBlock(
              text: banned
                  ? 'После разблокировки пользователь снова увидит афишу, билеты и напоминания.'
                  : 'Блокировка запрещает вход: афиша, записи и билеты становятся недоступны.',
            ),
        ],
      ),
    );
  }
}

class _OrganizationTile extends StatelessWidget {
  const _OrganizationTile({
    required this.org,
    required this.busy,
    required this.locked,
    required this.onBlock,
  });

  final Organization org;
  final bool busy;
  final bool locked;
  final VoidCallback onBlock;

  @override
  Widget build(BuildContext context) {
    final blocked = org.blocked;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(
                label: AdminUi.initialsOf(org.name),
                color: blocked ? Palette.rose : Palette.gold,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.name,
                      maxLines: 2,
                      style: Fonts.sansStyle(
                        size: 14,
                        weight: 600,
                        height: 1.2,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${org.type.label} · ${org.city}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              AdminTag(
                text: blocked ? 'СКРЫТА ИЗ АФИШИ' : 'ОТКРЫТА',
                color: blocked ? Palette.rose : Palette.mint,
                icon: blocked
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                strong: blocked,
              ),
              if (org.phone.isNotEmpty)
                AdminTag(
                  text: org.phone,
                  color: Palette.accent,
                  icon: Icons.phone_rounded,
                ),
              if (org.email.isNotEmpty)
                AdminTag(
                  text: org.email,
                  color: Palette.ink2,
                  icon: Icons.alternate_email_rounded,
                ),
            ],
          ),
          const SizedBox(height: 8),
          AdminKeyValue(label: 'ID', value: org.id, color: Palette.muted),
          AdminKeyValue(
            label: 'Владелец',
            value: org.ownerId,
            color: Palette.muted,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: busy
                    ? const PrimaryButton(
                        label: 'Выполняем',
                        busy: true,
                        arrow: false,
                      )
                    : GhostButton(
                        label: blocked
                            ? 'Разблокировать организацию'
                            : 'Заблокировать организацию',
                        onPressed: locked ? null : onBlock,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const NoteBlock(
            text:
                'Последствие блокировки: все события организации скрываются из афиши, '
                'новая публикация становится невозможна до разблокировки.',
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.orgName,
    required this.hiddenReason,
    required this.busy,
    required this.locked,
    required this.onHide,
  });

  final CampusEvent event;
  final String orgName;
  final String? hiddenReason;
  final bool busy;
  final bool locked;
  final VoidCallback onHide;

  bool get _hideable =>
      event.status == EventStatus.published ||
      event.status == EventStatus.pendingReview;

  @override
  Widget build(BuildContext context) {
    final reason = hiddenReason;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Fonts.sansStyle(
                    size: 14,
                    weight: 600,
                    height: 1.2,
                    color: Palette.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _CoverDot(event: event),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${AdminDate.weekday(event.startAt)} · ${AdminDate.dateTime(event.startAt)}',
            style: Fonts.sansStyle(size: 12, color: Palette.ink2),
          ),
          const SizedBox(height: 2),
          Text(
            event.place.isEmpty ? 'Место уточняется' : event.place,
            style: Fonts.monoStyle(size: 9.5, color: Palette.muted),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              AdminTag(
                text: event.status.label.toUpperCase(),
                color: AdminUi.statusColor(event.status),
                icon: AdminUi.statusIcon(event.status),
                strong: true,
              ),
              AdminTag(
                text: event.category.label.toUpperCase(),
                color: AdminUi.categoryColor(event.category),
                icon: AdminUi.categoryIcon(event.category),
              ),
              if (reason != null)
                AdminTag(
                  text: 'СКРЫТО ИЗ АФИШИ',
                  color: Palette.rose,
                  icon: Icons.visibility_off_rounded,
                  strong: true,
                ),
            ],
          ),
          const SizedBox(height: 8),
          AdminKeyValue(label: 'Организация', value: orgName),
          if (reason != null)
            AdminKeyValue(label: 'Причина', value: reason, color: Palette.rose),
          if (event.moderationNote.isNotEmpty)
            AdminKeyValue(
              label: 'Примечание',
              value: event.moderationNote,
              color: Palette.ink2,
            ),
          const SizedBox(height: 6),
          if (_hideable)
            Row(
              children: [
                Expanded(
                  child: busy
                      ? const PrimaryButton(
                          label: 'Выполняем',
                          busy: true,
                          arrow: false,
                        )
                      : GhostButton(
                          label: 'Скрыть из афиши',
                          onPressed: locked ? null : onHide,
                        ),
                ),
              ],
            )
          else
            NoteBlock(
              text: event.status == EventStatus.rejected
                  ? 'Событие уже снято с публикации — в афише его нет.'
                  : 'Скрывать нечего: событие ещё не опубликовано.',
            ),
        ],
      ),
    );
  }
}

class _CoverDot extends StatelessWidget {
  const _CoverDot({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final media = event.media.length;
    final color = AdminUi.categoryColor(event.category);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(AdminUi.categoryIcon(event.category), size: 17, color: color),
          if (media > 0)
            Positioned(
              right: 2,
              bottom: 1,
              child: Text(
                '$media',
                style: Fonts.monoStyle(
                  size: 8,
                  weight: 600,
                  color: Palette.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withValues(alpha: 0.13),
      border: Border.all(color: color.withValues(alpha: 0.34)),
    ),
    child: Center(
      child: Text(
        label,
        style: Fonts.monoStyle(
          size: 11.5,
          weight: 600,
          letterSpacing: 0,
          color: color,
        ),
      ),
    ),
  );
}
