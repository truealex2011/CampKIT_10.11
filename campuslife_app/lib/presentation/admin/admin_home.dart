import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';
import '../shared/app_routes.dart';
import '../shared/kit.dart';
import '../shared/ocean/ocean_providers.dart';
import '../shared/pixel.dart';
import 'admin_common.dart';
import 'invite_keys_tab.dart';
import 'management_tab.dart';
import 'moderation_tab.dart';
import 'reports_tab.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  static const _tabs = AdminUi.tabs;

  int _tab = 0;

  @override
  void initState() {
    super.initState();
    AdminDate.bootstrap();
  }

  void _select(int index) => setState(() => _tab = index);

  void _openProfile() => Navigator.of(context).pushNamed(AppRoutes.profile);

  Future<void> _signOut() async {
    await ref.read(sessionProvider.notifier).signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.entry);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider);
    final counters = ref.watch(adminCountersProvider);
    final gutter = AdminUi.gutter(context);
    return Scaffold(
      backgroundColor: context.colors.paper,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [context.colors.glassField, context.colors.paper],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const Positioned.fill(child: OceanBackdrop(veil: 1.45)),
              Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, 14, gutter, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Topline(
                      user: user,
                      onProfile: _openProfile,
                      onSignOut: _signOut,
                    ),
                    const SizedBox(height: 14),
                    _CountersStrip(
                      async: counters,
                      onRetry: () => ref.invalidate(adminCountersProvider),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, 2, gutter, 4),
                child: SegTabs(items: _tabs, index: _tab, onSelect: _select),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : AppMotion.normal,
                  switchInCurve: AppMotion.ease,
                  switchOutCurve: AppMotion.ease,
                  child: KeyedSubtree(key: ValueKey(_tab), child: _section()),
                ),
              ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section() => switch (_tab) {
    0 => const ModerationTab(),
    1 => const InviteKeysTab(),
    2 => const ManagementTab(),
    _ => const ReportsTab(),
  };
}

class _Topline extends StatelessWidget {
  const _Topline({
    required this.user,
    required this.onProfile,
    required this.onSignOut,
  });

  final User? user;
  final VoidCallback onProfile;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Администратор';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MicroLabel('CampusLife · доступ'),
              Text(
                'Админ-панель',
                style: Fonts.sansStyle(
                  size: 25,
                  weight: 700,
                  letterSpacing: -0.9,
                  color: context.colors.ink,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user == null
                    ? 'Профиль не загружен'
                    : '$name · ${user!.role.label} · ${user!.email}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Fonts.monoStyle(
                  size: 10,
                  letterSpacing: 0.06 * 10,
                  color: context.colors.muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _ProfileButton(label: AdminUi.initialsOf(name), onTap: onProfile),
        const SizedBox(width: 8),
        _RoundButton(
          icon: Icons.logout_rounded,
          tooltip: 'Выйти из админ-панели',
          onTap: onSignOut,
        ),
      ],
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _HoverCircle(
    onTap: onTap,
    tooltip: 'Профиль администратора',
    filled: true,
    child: PixelFishMark(size: 28, color: context.colors.paper),
  );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _HoverCircle(
    onTap: onTap,
    tooltip: tooltip,
    child: Icon(icon, size: 16, color: context.colors.ink2),
  );
}

class _HoverCircle extends StatefulWidget {
  const _HoverCircle({
    required this.onTap,
    required this.tooltip,
    required this.child,
    this.filled = false,
  });

  final VoidCallback onTap;
  final String tooltip;
  final Widget child;
  final bool filled;

  @override
  State<_HoverCircle> createState() => _HoverCircleState();
}

class _HoverCircleState extends State<_HoverCircle> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: widget.tooltip,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero : AppMotion.normal,
        curve: AppMotion.ease,
        width: Scale.railIcon,
        height: Scale.railIcon,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.filled ? context.colors.ink : context.colors.glassField,
          border: Border.all(
            color: _hover ? context.colors.lineStrong : context.colors.line,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Material(
          color: context.colors.paper.withValues(alpha: 0),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            child: Center(child: widget.child),
          ),
        ),
      ),
    ),
  );
}

class _CountersStrip extends StatelessWidget {
  const _CountersStrip({required this.async, required this.onRetry});

  final AsyncValue<AppCounters?> async;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => async.when(
    loading: () => _grid(context, null),
    error: (error, _) => AdminCard(
      bottom: 0,
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 15, color: context.colors.rose),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              AdminUi.failureMessage(error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Fonts.sansStyle(size: 11.5, height: 1.35, color: context.colors.muted),
            ),
          ),
          TextLink('Обновить счётчики', onTap: onRetry),
        ],
      ),
    ),
    data: (counters) => _grid(context, counters),
  );

  Widget _grid(BuildContext context, AppCounters? counters) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          _cell(context, 'События', counters?.events),
          _gap(),
          _cell(context, 'Организации', counters?.orgs),
          _gap(),
          _cell(context, 'Пользователи', counters?.users),
        ],
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          _cell(context, 'На модерации', counters?.pendingModeration),
          _gap(),
          _cell(context, 'Жалобы', counters?.openReports, accent: context.colors.rose),
          _gap(),
          _cell(context, 'Свободные ключи', counters?.activeInviteKeys, accent: context.colors.accent),
        ],
      ),
    ],
  );

  static Widget _gap() => const SizedBox(width: 6);

  Widget _cell(BuildContext context, String label, int? value, {Color? accent}) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
          decoration: BoxDecoration(
            color: context.colors.glassField,
            borderRadius: BorderRadius.circular(AppRadius.field),
            border: Border.all(color: context.colors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(end: (value ?? 0).toDouble()),
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero : AppMotion.scene,
                curve: AppMotion.ease,
                builder: (context, number, _) => Text(
                  value == null ? '—' : '${number.round()}',
                  maxLines: 1,
                  style: Fonts.monoStyle(
                    size: 17, weight: 500, letterSpacing: -0.4,
                    color: value == null ? context.colors.placeholder : accent ?? context.colors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Fonts.monoStyle(size: 8.5, weight: 500, letterSpacing: 0.12 * 8.5, color: context.colors.muted),
              ),
            ],
          ),
        ),
      );
}
