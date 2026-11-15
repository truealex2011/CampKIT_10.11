import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../entry/entry_widgets.dart' show NoteBlock;
import '../feed/event_sheet.dart';
import '../feed/media_pool.dart' show DateFmt, FeedVisuals;
import '../shared/app_routes.dart';
import '../shared/fish.dart';
import '../shared/ocean/ocean_providers.dart';
import '../shared/glass_sheet.dart';
import '../shared/kit.dart';
import '../shared/onboarding.dart';
import '../shared/pixel.dart';
import '../shared/theme_controls.dart';
import 'ticket_card.dart';

final reminderOfProvider = FutureProvider.family<Reminder?, String>((
  ref,
  eventId,
) async {
  ref.watch(revisionProvider);
  final user = ref.watch(sessionProvider);
  if (user == null) return null;
  return ref.read(repositoryProvider).reminderOf(eventId, user.id);
});

final fishEnabledProvider = StateNotifierProvider<FishEnabledNotifier, bool>((
  ref,
) {
  return FishEnabledNotifier();
});

class FishEnabledNotifier extends StateNotifier<bool> {
  FishEnabledNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    state = await isFishEnabled();
  }

  Future<void> toggle() async {
    state = !state;
    await setFishEnabled(state);
  }
}

enum _ReminderAction { oneHour, oneDay, custom, clear }

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const List<String> _tabs = ['Билеты', 'Избранное', 'Настройки'];

  int _tab = 0;
  final _themeBoundary = GlobalKey();
  final _themeToggle = GlobalKey();
  final _themeTabs = GlobalKey();
  Offset? _themeOrigin;
  bool _changingTheme = false;

  Future<void> _changeTheme(
    ThemeMode mode,
    GlobalKey source, {
    int? segment,
  }) async {
    final pointerOrigin = _themeOrigin;
    _themeOrigin = null;
    if (_changingTheme || mode == ref.read(themeModeProvider)) return;
    _changingTheme = true;
    final box = source.currentContext!.findRenderObject() as RenderBox;
    final origin = pointerOrigin ??
        box.localToGlobal(
          Offset(
            segment == null
                ? box.size.width / 2
                : 4 + (box.size.width - 8) * (segment + 0.5) / 3,
            box.size.height / 2,
          ),
        );
    try {
      await revealTheme(
        context,
        _themeBoundary,
        mode,
        origin,
        () => ref.read(themeModeProvider.notifier).set(mode),
      );
    } finally {
      _changingTheme = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider);
    final width = MediaQuery.sizeOf(context).width;
    return RepaintBoundary(
      key: _themeBoundary,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(child: OceanBackdrop(veil: 1.35)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Scale.gutter(width)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: context.colors.icon,
                      ),
                    ),
                    PixelAvatar(name: user?.name ?? 'Гость'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name.isEmpty == false ? user!.name : 'Гость',
                            style: Fonts.sansStyle(
                              size: 17,
                              weight: 700,
                              height: 1.15,
                            ),
                          ),
                          Text(
                            user?.email ?? 'смотришь без аккаунта',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Fonts.monoStyle(
                              size: 10,
                              color: context.colors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (user != null)
                      RoleChip(
                        label: user.role.label,
                        dot: context.colors.roleDot(user.role),
                      )
                    else
                      TextLink(
                        'войти',
                        onTap: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.entry),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SegTabs(
                  items: _tabs,
                  index: _tab,
                  onSelect: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero : AppMotion.normal,
                    switchInCurve: AppMotion.ease,
                    switchOutCurve: AppMotion.ease,
                    child: KeyedSubtree(
                      key: ValueKey(_tab),
                      child: switch (_tab) {
                        0 => _tickets(),
                        1 => _favorites(),
                        _ => _settings(user),
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tickets() {
    final tickets = ref.watch(ticketsProvider);
    return switch (tickets) {
      AsyncData(:final value) =>
        value.isEmpty
            ? const _EmptyPlate(
                lead: 'Билетов пока нет.',
                text:
                    'Запишись на событие в ленте — билет с QR-кодом появится здесь.',
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: value.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => TicketCard(
                  bundle: value[i],
                  onOpen: () => openEventSheet(context, value[i].event.id),
                ),
              ),
      AsyncError() => const _EmptyPlate(
        lead: 'Сбой.',
        text: 'Билеты не загрузились. Попробуй открыть экран позже.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _favorites() {
    final favorites = ref.watch(favoritesProvider);
    return switch (favorites) {
      AsyncData(:final value) =>
        value.isEmpty
            ? const _EmptyPlate(
                lead: 'Избранное пусто.',
                text:
                    'Нажми на сердце в карточке события — оно сохранится здесь.',
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: value.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _FavoriteTile(event: value[i]),
              ),
      AsyncError() => const _EmptyPlate(
        lead: 'Сбой.',
        text: 'Избранное не загрузилось. Попробуй открыть экран позже.',
      ),
      _ => const Center(child: FishLoader(size: 40)),
    };
  }

  Widget _settings(User? user) {
    final mode = ref.watch(themeModeProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 12),
      children: [
        Listener(
          onPointerDown: (event) => _themeOrigin = event.position,
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                MicroLabel('тёмная тема'),
                GhostButton(
                  key: _themeToggle,
                  label: switch (mode) {
                    ThemeMode.dark => 'включена — выключим',
                    ThemeMode.system => 'следим за системой',
                    _ => 'выключена — включим',
                  },
                  expand: true,
                  onPressed: () => _changeTheme(
                    switch (mode) {
                      ThemeMode.dark => ThemeMode.light,
                      ThemeMode.light => ThemeMode.dark,
                      ThemeMode.system => ThemeMode.light,
                    },
                    _themeToggle,
                  ),
                ),
                const SizedBox(height: 10),
                SegTabs(
                  key: _themeTabs,
                  items: const ['Светлая', 'Тёмная', 'Система'],
                  index: switch (mode) {
                    ThemeMode.light => 0,
                    ThemeMode.dark => 1,
                    _ => 2,
                  },
                  onSelect: (i) => _changeTheme(
                    switch (i) {
                      0 => ThemeMode.light,
                      1 => ThemeMode.dark,
                      _ => ThemeMode.system,
                    },
                    _themeTabs,
                    segment: i,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
        // Fish toggle
        Listener(
          onPointerDown: (event) => _themeOrigin = event.position,
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.set_meal_rounded,
                    size: 20,
                    color: context.colors.muted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Рыбы на фоне',
                          style: Fonts.sansStyle(
                            size: 14,
                            weight: 500,
                            color: context.colors.ink,
                          ),
                        ),
                        Text(
                          'Анимированные рыбки в океане',
                          style: Fonts.sansStyle(
                            size: 11,
                            color: context.colors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: ref.watch(fishEnabledProvider),
                    onChanged: (_) => ref.read(fishEnabledProvider.notifier).toggle(),
                    activeColor: Palette.accent,
                  ),
                ],
              ),
            ),
          ),
        ),
        const DividerLabel('Аккаунт'),
        GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              _InfoRow(
                label: 'имя',
                value: user?.name ?? 'гость',
                icon: Icons.person_outline_rounded,
              ),
              _InfoRow(
                label: 'почта',
                value: user?.email ?? '—',
                icon: Icons.alternate_email_rounded,
              ),
              _InfoRow(
                label: 'телефон',
                value: (user?.phone.isEmpty ?? true) ? '—' : user!.phone,
                icon: Icons.phone_outlined,
              ),
              if (user != null)
                _InfoRow(
                  label: 'id',
                  value: user.id,
                  icon: Icons.badge_outlined,
                ),
              const SizedBox(height: 6),
            ],
          ),
        ),
        if (user != null) ...[
          const DividerLabel('Вход'),
          GhostButton(
            label: 'Выйти из аккаунта',
            expand: true,
            onPressed: () => unawaited(_signOut()),
          ),
          const SizedBox(height: 8),
          const NoteBlock(
            lead: 'Данные останутся',
            text:
                '— на этом устройстве. Записи и напоминания вернутся, когда войдёшь снова.',
          ),
        ],
      ],
    );
  }

  Future<void> _signOut() async {
    final navigator = Navigator.of(context);
    await ref.read(sessionProvider.notifier).signOut();
    unawaited(
      navigator.pushNamedAndRemoveUntil(AppRoutes.entry, (route) => false),
    );
  }
}

class _EmptyPlate extends StatelessWidget {
  const _EmptyPlate({required this.lead, required this.text});

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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(icon, size: 15, color: context.colors.muted),
        const SizedBox(width: 9),
        SizedBox(
          width: 66,
          child: Text(
            label,
            style: Fonts.monoStyle(size: 9.5, color: context.colors.muted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Fonts.sansStyle(size: 13, color: context.colors.ink2),
          ),
        ),
      ],
    ),
  );
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminder = ref.watch(reminderOfProvider(event.id));
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.title.isEmpty ? 'Без названия' : event.title,
                  style: Fonts.sansStyle(size: 15, weight: 600, height: 1.2),
                ),
              ),
              const SizedBox(width: 8),
              RoleChip(
                label: event.category.label,
                dot: FeedVisuals.colorFor(event.category),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${DateFmt.full(event.startAt)} · ${DateFmt.time(event.startAt)}'
            ' · ${event.place.isEmpty ? 'место не указано' : event.place}',
            style: Fonts.sansStyle(size: 12, color: context.colors.muted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                reminder is AsyncData && reminder.value != null
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_none_rounded,
                size: 16,
                color: context.colors.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  switch (reminder) {
                    AsyncData(:final value) =>
                      value == null
                          ? 'напоминания нет'
                          : 'напомню ${value.offset.label}, в ${DateFmt.time(value.fireAt)}',
                    AsyncError() => 'напоминание не проверить',
                    _ => 'считаем…',
                  },
                  style: Fonts.sansStyle(
                    size: 11.5,
                    color: context.colors.ink2,
                  ),
                ),
              ),
              TextLink(
                'напомнить',
                onTap: () => unawaited(_editReminder(context, ref)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: GhostButton.pair(
              GhostButton(
                label: 'Открыть',
                onPressed: () => openEventSheet(context, event.id),
              ),
              GhostButton(
                label: 'Убрать',
                onPressed: () => unawaited(_dropFavorite(context, ref)),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Future<void> _editReminder(BuildContext context, WidgetRef ref) async {
    final user = ref.read(sessionProvider);
    if (user == null) {
      ToastController.show(
        context,
        'Войди, чтобы ставить напоминания',
        error: true,
      );
      return;
    }
    final current = ref.read(reminderOfProvider(event.id)).value;
    final action = await showGlassSheet<_ReminderAction>(
      context: context,
      builder: (_) => _ReminderSheet(hasReminder: current != null),
    );
    if (action == null || !context.mounted) return;
    final repository = ref.read(repositoryProvider);
    try {
      switch (action) {
        case _ReminderAction.oneHour:
          await repository.setReminder(
            event.id,
            user.id,
            ReminderOffset.oneHour,
          );
        case _ReminderAction.oneDay:
          await repository.setReminder(
            event.id,
            user.id,
            ReminderOffset.oneDay,
          );
        case _ReminderAction.custom:
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(event.startAt),
            helpText: 'Во сколько напомнить',
          );
          if (picked == null) return;
          await repository.setReminder(
            event.id,
            user.id,
            ReminderOffset.custom,
            customAt: DateTime(
              event.startAt.year,
              event.startAt.month,
              event.startAt.day,
              picked.hour,
              picked.minute,
            ),
          );
        case _ReminderAction.clear:
          await repository.clearReminder(event.id, user.id);
      }
      ref.read(revisionProvider.notifier).bump();
      if (!context.mounted) return;
      ToastController.show(
        context,
        action == _ReminderAction.clear
            ? 'Напоминание снято'
            : 'Напоминание готово',
      );
    } on AppException catch (e) {
      if (context.mounted) {
        ToastController.show(context, e.message, error: true);
      }
    }
  }

  Future<void> _dropFavorite(BuildContext context, WidgetRef ref) async {
    final user = ref.read(sessionProvider);
    if (user == null) {
      Navigator.of(context).pop();
      return;
    }
    try {
      await ref.read(repositoryProvider).toggleFavorite(event.id, user.id);
      ref.read(revisionProvider.notifier).bump();
    } on AppException catch (e) {
      if (context.mounted) {
        ToastController.show(context, e.message, error: true);
      }
    }
  }
}

class _ReminderSheet extends StatelessWidget {
  const _ReminderSheet({required this.hasReminder});

  final bool hasReminder;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MicroLabel('напомнить о событии'),
        Text(
          hasReminder ? 'Напоминание уже стоит' : 'Когда напомнить',
          style: Fonts.sansStyle(size: 15.5, weight: 700, height: 1.2),
        ),
        const SizedBox(height: 12),
        for (final option in const [
          (_ReminderAction.oneHour, 'за 1 час до начала'),
          (_ReminderAction.oneDay, 'за день до начала'),
          (_ReminderAction.custom, 'в своё время'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GhostButton(
              label: option.$2,
              expand: true,
              onPressed: () => Navigator.of(context).pop(option.$1),
            ),
          ),
        if (hasReminder)
          TextLink(
            'снять напоминание',
            onTap: () => Navigator.of(context).pop(_ReminderAction.clear),
          ),
        const SizedBox(height: 4),
      ],
    ),
  );
}
