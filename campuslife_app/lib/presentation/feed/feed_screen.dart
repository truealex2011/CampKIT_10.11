import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/di.dart';
import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/fish.dart';
import '../shared/kit.dart';
import 'event_sheet.dart';
import 'media_pool.dart';

final shareUrlOfProvider = FutureProvider.family<String, String>((
  ref,
  id,
) async {
  ref.watch(revisionProvider);
  return ref.read(repositoryProvider).shareUrl(id);
});

final eventLikesProvider = FutureProvider.family<int, String>((
  ref,
  eventId,
) async {
  ref.watch(revisionProvider);
  return (await ref.read(repositoryProvider).statsOf(eventId)).likes;
});

final reminderIdsProvider = FutureProvider<Set<String>>((ref) async {
  ref.watch(revisionProvider);
  final user = ref.watch(sessionProvider);
  if (user == null) return const {};
  final feed = ref.watch(feedProvider).value ?? const [];
  final ids = <String>{};
  for (final event in feed) {
    final reminder = await ref
        .read(repositoryProvider)
        .reminderOf(event.id, user.id);
    if (reminder != null) ids.add(event.id);
  }
  return ids;
});

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final MediaPool _pool = MediaPool();

  @override
  void dispose() {
    _pool.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedProvider);
    return Scaffold(
      backgroundColor: Palette.ink,
      body: Stack(
        fit: StackFit.expand,
        children: [
          feed.when(
            skipLoadingOnReload: true,
            loading: () => const _FeedPlaceholder(label: 'Загружаем афишу…'),
            error: (e, _) => _FeedError(
              message: e is AppException
                  ? e.message
                  : 'Не удалось загрузить ленту',
              onRetry: () => ref.invalidate(feedProvider),
            ),
            data: (events) => events.isEmpty
                ? _FeedPlaceholder(
                    label: 'Пока нет событий',
                    hint:
                        'Загляни позже — организаторы скоро что-нибудь выложат',
                  )
                : _VerticalFeed(events: events, pool: _pool),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: _TopCorners()),
        ],
      ),
    );
  }
}

class _VerticalFeed extends StatefulWidget {
  const _VerticalFeed({required this.events, required this.pool});

  final List<CampusEvent> events;
  final MediaPool pool;

  @override
  State<_VerticalFeed> createState() => _VerticalFeedState();
}

class _VerticalFeedState extends State<_VerticalFeed> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _applyPool();
  }

  @override
  void didUpdateWidget(covariant _VerticalFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.events, widget.events)) _applyPool();
  }

  void _applyPool() {
    final ids = widget.events.map((e) => e.id).toList(growable: false);
    final paths = {for (final e in widget.events) e.id: e.video?.path};
    widget.pool.syncWith(ids, paths);
    widget.pool.setActive(_index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageView.builder(
    controller: _controller,
    scrollDirection: Axis.vertical,
    physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
    itemCount: widget.events.length,
    onPageChanged: (i) {
      setState(() => _index = i);
      widget.pool.setActive(i);
    },
    itemBuilder: (context, i) =>
        EventCard(event: widget.events[i], pool: widget.pool),
  );
}

class EventCard extends ConsumerStatefulWidget {
  const EventCard({super.key, required this.event, required this.pool});

  final CampusEvent event;
  final MediaPool pool;

  @override
  ConsumerState<EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
  static const double _railBottom = 111;

  bool _registrationMode = false;

  Future<void> _toggleFavorite(CampusEvent event) async {
    final user = ref.read(sessionProvider);
    if (user == null) {
      ToastController.show(
        context,
        'Войди, чтобы сохранять события',
        error: true,
      );
      return;
    }
    try {
      await ref.read(repositoryProvider).toggleFavorite(event.id, user.id);
      ref.read(revisionProvider.notifier).bump();
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    }
  }

  Future<void> _commitRegistration(CampusEvent event) async {
    final user = ref.read(sessionProvider);
    if (user == null) {
      ToastController.show(context, 'Войди, чтобы записаться', error: true);
      return;
    }
    try {
      await ref.read(repositoryProvider).toggleRegistration(event.id, user.id);
      FeedState.toggle(event.id);
      ref.read(revisionProvider.notifier).bump();
      final nowRegistered = FeedState.isRegistered(event.id);
      if (mounted) {
        ToastController.show(
          context,
          nowRegistered ? 'Ты записан(а) на событие' : 'Запись отменена',
        );
      }
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    }
  }

  Future<void> _share(CampusEvent event) async {
    try {
      final url = await ref.read(repositoryProvider).shareUrl(event.id);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              SharePage(eventId: event.id, title: event.title, url: url),
        ),
      );
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    }
  }

  Future<void> _openReminder(CampusEvent event) async {
    final user = ref.read(sessionProvider);
    if (user == null) {
      ToastController.show(
        context,
        'Войди, чтобы поставить напоминание',
        error: true,
      );
      return;
    }
    Reminder? current;
    try {
      current = await ref
          .read(repositoryProvider)
          .reminderOf(event.id, user.id);
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    }
    if (!mounted) return;
    final result = await showModalBottomSheet<_ReminderChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReminderSheet(hasReminder: current != null),
    );
    if (result == null || !mounted) return;
    if (result.clear) {
      await _clearReminder(event, user.id);
      return;
    }
    if (result.offset == ReminderOffset.custom) {
      if (!mounted) return;
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked == null || !mounted) return;
      final base = DateTime(
        event.startAt.year,
        event.startAt.month,
        event.startAt.day,
        picked.hour,
        picked.minute,
      );
      await _setReminder(
        event,
        user.id,
        ReminderOffset.custom,
        base.subtract(const Duration(hours: 1)),
      );
    } else {
      await _setReminder(event, user.id, result.offset!, null);
    }
  }

  Future<void> _setReminder(
    CampusEvent event,
    String userId,
    ReminderOffset offset,
    DateTime? customAt,
  ) async {
    try {
      await ref
          .read(repositoryProvider)
          .setReminder(event.id, userId, offset, customAt: customAt);
      ref.read(revisionProvider.notifier).bump();
      if (mounted) ToastController.show(context, 'Напоминание установлено');
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    }
  }

  Future<void> _clearReminder(CampusEvent event, String userId) async {
    try {
      await ref.read(repositoryProvider).clearReminder(event.id, userId);
      ref.read(revisionProvider.notifier).bump();
      if (mounted) ToastController.show(context, 'Напоминание снято');
    } on AppException catch (e) {
      if (mounted) ToastController.show(context, e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final favoriteIds = ref.watch(favoriteIdsProvider).value ?? const {};
    final reminderIds = ref.watch(reminderIdsProvider).value ?? const {};
    final isFavorite = favoriteIds.contains(event.id);
    final hasReminder = reminderIds.contains(event.id);
    final organizer = ref
        .watch(organizationOfProvider(event.orgId))
        .value
        ?.name;
    final size = MediaQuery.sizeOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: MediaCarousel(event: event, pool: widget.pool),
        ),
        const Positioned.fill(child: _FeedScrim()),
        Positioned(
          left: 76,
          right: 88,
          bottom: 24,
          child: IgnorePointer(
            ignoring: _registrationMode,
            child: _Caption(
              event: event,
              organizer: organizer,
              availableHeight: size.height * 0.34,
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_registrationMode,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _registrationMode = false),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 260),
                curve: Palette.ease,
                opacity: _registrationMode ? 1 : 0,
                child: const ColoredBox(color: Color(0x8C05080C)),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: _railBottom,
          child: _RightRail(
            event: event,
            hasReminder: hasReminder,
            isFavorite: isFavorite,
            registered: FeedState.isRegistered(event.id),
            likeCount: ref.watch(eventLikesProvider(event.id)).value ?? 0,
            armed: _registrationMode,
            onReminder: () => _openReminder(event),
            onLike: () => _toggleFavorite(event),
            onRegister: () => _commitRegistration(event),
            onEnterMode: () {
              if (mounted) setState(() => _registrationMode = true);
            },
            onExitMode: () {
              if (mounted) setState(() => _registrationMode = false);
            },
            onDescription: () => openEventSheet(context, event.id),
            onShare: () => _share(event),
            onReport: () => openReportSheet(context, event.id, null),
          ),
        ),
      ],
    );
  }
}

class _RightRail extends StatelessWidget {
  const _RightRail({
    required this.event,
    required this.hasReminder,
    required this.isFavorite,
    required this.registered,
    required this.likeCount,
    required this.armed,
    required this.onReminder,
    required this.onLike,
    required this.onRegister,
    required this.onEnterMode,
    required this.onExitMode,
    required this.onDescription,
    required this.onShare,
    required this.onReport,
  });

  final CampusEvent event;
  final bool hasReminder;
  final bool isFavorite;
  final bool registered;
  final int likeCount;
  final bool armed;
  final VoidCallback onReminder;
  final VoidCallback onLike;
  final VoidCallback onRegister;
  final VoidCallback onEnterMode;
  final VoidCallback onExitMode;
  final VoidCallback onDescription;
  final VoidCallback onShare;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 74,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _RailButton(
          icon: hasReminder
              ? Icons.notifications_active_rounded
              : Icons.notifications_none_rounded,
          label: 'Напомнить',
          active: hasReminder,
          onTap: onReminder,
        ),
        const SizedBox(height: _railGap),
        _DragLikeButton(
          railWidth: 74,
          isFavorite: isFavorite,
          registered: registered,
          likeCount: likeCount,
          armed: armed,
          onLike: onLike,
          onRegister: onRegister,
          onEnterMode: onEnterMode,
          onExitMode: onExitMode,
        ),
        const SizedBox(height: _railGap),
        IgnorePointer(
          ignoring: armed,
          child: Opacity(
            opacity: armed ? 0.35 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RailButton(
                  icon: Icons.article_outlined,
                  label: 'Описание',
                  onTap: onDescription,
                ),
                const SizedBox(height: _railGap),
                _RailButton(
                  icon: Icons.share_outlined,
                  label: 'Поделиться',
                  onTap: onShare,
                ),
                const SizedBox(height: _railGap),
                _RailButton(
                  icon: Icons.flag_outlined,
                  label: 'Жалоба',
                  onTap: onReport,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

const double _railGap = 14;

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 74,
    height: 70,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _RoundIconButton(icon: icon, size: 50, active: active, onTap: onTap),
        const SizedBox(height: 5),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Fonts.monoStyle(
            size: 9,
            letterSpacing: 0.08 * 9,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    ),
  );
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    this.icon,
    this.glyph,
    required this.onTap,
    this.size = 48,
    this.active = false,
  });

  final IconData? icon;
  final Widget? glyph;
  final VoidCallback? onTap;
  final double size;
  final bool active;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: SizedBox(
      width: size,
      height: size,
      child: Material(
        shape: CircleBorder(
          side: BorderSide(
            color: active
                ? Palette.accent
                : Colors.white.withValues(alpha: 0.24),
          ),
        ),
        color: active
            ? Palette.accent.withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child:
                glyph ??
                Icon(
                  icon,
                  size: size * 0.46,
                  color: active
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.92),
                ),
          ),
        ),
      ),
    ),
  );
}

class _DragLikeButton extends StatefulWidget {
  const _DragLikeButton({
    required this.railWidth,
    required this.isFavorite,
    required this.registered,
    required this.likeCount,
    required this.armed,
    required this.onLike,
    required this.onRegister,
    required this.onEnterMode,
    required this.onExitMode,
  });

  final double railWidth;
  final bool isFavorite;
  final bool registered;
  final int likeCount;
  final bool armed;
  final VoidCallback onLike;
  final VoidCallback onRegister;
  final VoidCallback onEnterMode;
  final VoidCallback onExitMode;

  @override
  State<_DragLikeButton> createState() => _DragLikeButtonState();
}

class _DragLikeButtonState extends State<_DragLikeButton>
    with TickerProviderStateMixin {
  late final AnimationController _drag;
  late final AnimationController _fly;
  late final AnimationController _hold;
  late final AnimationController _swim;
  late final AnimationController _splash;
  bool _crossed = false;
  bool _entered = false;
  double? _holdOriginX;

  double get _trackLength => widget.railWidth - 13 + 153;

  double get _threshold => _trackLength * 0.4;

  @override
  void initState() {
    super.initState();
    _drag = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
      lowerBound: 0,
      upperBound: _trackLength * 0.72,
      value: 0,
    )..addListener(() => setState(() {}));
    _fly = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..addListener(() => setState(() {}));
    _hold = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener(_onHoldStatus);
    _swim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..addListener(() => setState(() {}));
    _splash = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addListener(() => setState(() {}));
  }

  void _onHoldStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_entered) {
      _entered = true;
      HapticFeedback.heavyImpact();
      widget.onEnterMode();
    }
  }

  @override
  void didUpdateWidget(covariant _DragLikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.armed && oldWidget.armed) {
      _entered = false;
      _holdOriginX = null;
      _hold.value = 0;
      _crossed = false;
      _swim.stop();
    }
    if (widget.armed && !oldWidget.armed) {
      if (!MediaQuery.disableAnimationsOf(context)) _swim.repeat();
    }
  }

  @override
  void dispose() {
    _drag.dispose();
    _fly.dispose();
    _hold.dispose();
    _swim.dispose();
    _splash.dispose();
    super.dispose();
  }

  void _onHoldStart(LongPressStartDetails d) {
    _holdOriginX = d.localPosition.dx;
    if (widget.armed) return; // режим уже включён — это нажатие для перетаскивания
    _crossed = false;
    HapticFeedback.lightImpact();
    _hold.forward(from: 0);
  }

  void _onHoldMove(LongPressMoveUpdateDetails d) {
    if (!widget.armed || _holdOriginX == null) return;
    _applyDrag(_holdOriginX! - d.localPosition.dx);
  }

  void _onHoldEnd(LongPressEndDetails _) {
    if (widget.armed) {
      _finishDrag();
    } else {
      _holdOriginX = null;
      _hold.reverse();
    }
  }

  void _onHoldCancel() {
    if (widget.armed) {
      _finishDrag();
    } else {
      _holdOriginX = null;
      _hold.stop();
      _hold.reverse();
    }
  }

  double _flickDx = 0;

  void _onStart(DragStartDetails _) {
    _flickDx = 0;
    if (!widget.armed) return;
    _drag.stop();
    _crossed = false;
    HapticFeedback.lightImpact();
  }

  void _onUpdate(DragUpdateDetails d) {
    if (!widget.armed) {
      _flickDx += d.delta.dx;
      return;
    }
    _applyDrag(_drag.value - d.delta.dx);
  }

  void _onEnd(DragEndDetails d) {
    if (!widget.armed) {
      final vx = d.velocity.pixelsPerSecond.dx.abs();
      if (vx > 600 || _flickDx.abs() > 50) _flyLike();
      return;
    }
    _finishDrag();
  }

  void _tapLike() {
    if (widget.isFavorite) {
      widget.onLike();
    } else {
      _flyLike();
    }
  }

  void _flyLike() {
    HapticFeedback.lightImpact();
    widget.onLike();
    _fly.forward(from: 0);
  }

  void _applyDrag(double raw) {
    final next = raw.clamp(0.0, _trackLength * 0.72);
    _drag.value = next;
    final nowCrossed = next >= _threshold;
    if (nowCrossed != _crossed) {
      _crossed = nowCrossed;
      HapticFeedback.mediumImpact();
    }
  }

  void _finishDrag() {
    final committed = _drag.value >= _threshold;
    if (committed) {
      HapticFeedback.selectionClick();
      _splash.forward(from: 0);
      widget.onRegister();
    }
    _holdOriginX = null;
    _drag.animateTo(
      0,
      duration: Duration(milliseconds: committed ? 360 : 520),
      curve: committed ? Curves.easeOut : Curves.elasticOut,
    );
    widget.onExitMode();
  }

  @override
  Widget build(BuildContext context) {
    final value = _drag.value;
    final reached = value >= _threshold;
    final fill = (value / _trackLength).clamp(0.0, 1.0);
    final holding = _hold.value > 0.01;
    return SizedBox(
      width: widget.railWidth,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -153,
            right: 13,
            top: 8,
            height: 48,
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                curve: Palette.ease,
                opacity: widget.armed ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: reached
                          ? Palette.mint
                          : Colors.white.withValues(alpha: 0.28),
                    ),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: fill,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Palette.accent.withValues(alpha: 0.1),
                                    Palette.accent.withValues(alpha: 0.85),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LanePainter(
                            swim: _swim.value,
                            color: Palette.darkAccent,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            (reached
                                ? 'ОТПУСТИ'
                                : widget.registered
                                ? 'ОТМЕНИТЬ'
                                : 'ЗАПИСАТЬСЯ'),
                            textAlign: TextAlign.center,
                            style: Fonts.monoStyle(
                              size: 9,
                              weight: 600,
                              letterSpacing: 0.08 * 9,
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -141,
            top: 22,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              curve: Palette.ease,
              opacity: widget.armed ? 1 : 0,
              child: Icon(
                reached ? Icons.check_rounded : Icons.swipe_left_alt_rounded,
                size: 18,
                color: Colors.white.withValues(alpha: reached ? 1 : 0.75),
              ),
            ),
          ),
          Positioned(
            left: -150,
            top: 0,
            child: IgnorePointer(
              child: SizedBox(
                width: 52,
                height: 52,
                child: CustomPaint(
                  painter: SplashPainter(
                    progress: _splash.value,
                    color: Palette.darkAccent,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: -4,
            child: Transform.translate(
              offset: Offset(-value, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onLike,
                onLongPressStart: _onHoldStart,
                onLongPressMoveUpdate: _onHoldMove,
                onLongPressEnd: _onHoldEnd,
                onLongPressCancel: _onHoldCancel,
                onHorizontalDragStart: _onStart,
                onHorizontalDragUpdate: _onUpdate,
                onHorizontalDragEnd: _onEnd,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 58,
                      height: 58,
                      child: Transform.rotate(
                        angle: widget.armed
                            ? math.sin(_swim.value * math.pi * 4) * 0.06
                            : 0,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              right: -14,
                              top: 16,
                              child: IgnorePointer(
                                child: Opacity(
                                  opacity: widget.armed ? 0.25 + 0.75 * fill : 0,
                                  child: Transform.translate(
                                    offset: Offset(
                                      math.sin(_swim.value * math.pi * 2) * 2,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _Bubble(size: 5, alpha: 0.5),
                                        const SizedBox(width: 3),
                                        _Bubble(size: 3.5, alpha: 0.35),
                                        const SizedBox(width: 3),
                                        _Bubble(size: 2.5, alpha: 0.25),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 160),
                              opacity: holding || widget.armed ? 1 : 0,
                              child: SizedBox(
                                width: 58,
                                height: 58,
                                child: CircularProgressIndicator(
                                  value: widget.armed ? 1 : _hold.value,
                                  strokeWidth: 2,
                                  strokeCap: StrokeCap.round,
                                  color: Colors.white,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              ),
                            ),
                            _RoundIconButton(
                              glyph: FishHeartIcon(
                                size: 27,
                                filled: widget.isFavorite,
                                color: Colors.white,
                                heartColor: widget.isFavorite
                                    ? Palette.rose
                                    : Colors.white,
                              ),
                              size: 50,
                              active: widget.isFavorite,
                              onTap: _tapLike,
                            ),
                            if (_fly.value > 0)
                              IgnorePointer(
                                child: Opacity(
                                  opacity: 1 - _fly.value,
                                  child: Transform.translate(
                                    offset: Offset(0, -90 * _fly.value),
                                    child: FishHeartIcon(
                                      size: 46,
                                      filled: true,
                                      color: Palette.accent,
                                      heartColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.likeCount}',
                      style: Fonts.monoStyle(
                        size: 10,
                        letterSpacing: 0,
                        color: Colors.white.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: widget.registered ? 1 : 0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, v, child) => Positioned(
              right: 2,
              top: 2,
              child: Transform.scale(scale: v, child: child),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: Palette.mint,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: alpha),
    ),
  );
}

class _LanePainter extends CustomPainter {
  _LanePainter({required this.swim, required this.color});

  final double swim;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (var k = 0; k < 6; k++) {
      final u = (swim * 0.5 + k * 0.17) % 1.0;
      final x = size.width * (1 - u);
      final y = size.height * (0.2 + 0.6 * ((k * 0.37) % 1));
      canvas.drawCircle(
        Offset(x, y),
        1.2 + (k % 3) * 0.7,
        Paint()
          ..color = color.withValues(alpha: 0.12 + 0.18 * (1 - u))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
    for (var f = 0; f < 2; f++) {
      final u = (swim * 0.35 + f * 0.5) % 1.0;
      final x = 8 + size.width * 0.8 * (1 - u);
      final y = size.height * (f == 0 ? 0.28 : 0.72);
      paintFish(
        canvas,
        Offset(x, y),
        9 / 24,
        0,
        Paint()..color = color.withValues(alpha: 0.4),
        math.sin(swim * math.pi * 8 + f * 2) * 0.3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LanePainter old) => old.swim != swim;
}

class MediaCarousel extends StatefulWidget {
  const MediaCarousel({super.key, required this.event, required this.pool});

  final CampusEvent event;
  final MediaPool pool;

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final photos = event.photos;
    final hasVideo = event.video != null;
    final count = photos.length + (hasVideo ? 1 : 0);

    if (count == 0) {
      return PlaceholderTile(event: event, page: 0);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: count,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, i) {
            final isVideo = hasVideo && i == photos.length;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isVideo ? () => widget.pool.togglePlay(event.id) : null,
              child: isVideo ? _videoArea(event) : _photoArea(photos[i], i),
            );
          },
        ),
        if (count > 1)
          Positioned(
            left: 16,
            bottom: 176,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.32),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${_page + 1}/$count',
                style: Fonts.monoStyle(
                  size: 11,
                  weight: 500,
                  letterSpacing: 0,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _photoArea(EventMedia media, int index) =>
      PhotoTile(event: widget.event, page: index, path: media.path);

  Widget _videoArea(CampusEvent event) => AnimatedBuilder(
    animation: widget.pool,
    builder: (context, _) {
      final state = widget.pool.stateOf(event.id);
      final controller = widget.pool.controllerFor(event.id);
      if (state == MediaSlotState.ready && controller != null) {
        return Stack(
          fit: StackFit.expand,
          children: [
            VideoTile(controller: controller),
            if (!widget.pool.isPlaying(event.id))
              const Center(child: _PlayGlyph()),
          ],
        );
      }
      return PlaceholderTile(
        event: event,
        page: event.photos.length,
        video: true,
      );
    },
  );
}

class _PlayGlyph extends StatelessWidget {
  const _PlayGlyph();

  @override
  Widget build(BuildContext context) => Container(
    width: 66,
    height: 66,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black.withValues(alpha: 0.42),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
    ),
    child: const Icon(Icons.play_arrow_rounded, size: 38, color: Colors.white),
  );
}

class _FeedScrim extends StatelessWidget {
  const _FeedScrim();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.36),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.74),
          ],
          stops: const [0, 0.28, 0.5, 1],
        ),
      ),
    ),
  );
}

class _Caption extends StatelessWidget {
  const _Caption({
    required this.event,
    required this.organizer,
    required this.availableHeight,
  });

  final CampusEvent event;
  final String? organizer;
  final double availableHeight;

  @override
  Widget build(BuildContext context) {
    final catColor = FeedVisuals.colorFor(event.category);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: catColor.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FeedVisuals.iconFor(event.category), size: 12, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                event.category.label.toUpperCase(),
                style: Fonts.monoStyle(
                  size: 9.5,
                  weight: 600,
                  letterSpacing: 0.08 * 9.5,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Fonts.sansStyle(
            size: 19,
            weight: 700,
            height: 1.15,
            color: Colors.white,
          ).withShadows(),
        ),
      if (organizer != null && organizer!.isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(
          organizer!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Fonts.sansStyle(
            size: 13,
            weight: 500,
            color: Colors.white.withValues(alpha: 0.82),
          ),
        ),
      ],
      const SizedBox(height: 8),
      Row(
        children: [
          const Icon(Icons.event_rounded, size: 15, color: Colors.white70),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              '${DateFmt.full(event.startAt)} · ${DateFmt.time(event.startAt)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Fonts.sansStyle(size: 12.5, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.place_rounded, size: 15, color: Colors.white70),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              event.place.isEmpty ? 'Место уточняется' : event.place,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Fonts.sansStyle(size: 12.5, color: Colors.white70),
            ),
          ),
        ],
      ),
      if (event.description.isNotEmpty) ...[
        const SizedBox(height: 9),
        Text(
          event.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Fonts.sansStyle(
            size: 13,
            height: 1.4,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    ],
  );
  }
}

extension _CaptionShadow on TextStyle {
  TextStyle withShadows() => copyWith(
    shadows: const [
      Shadow(color: Color(0x99000000), blurRadius: 14, offset: Offset(0, 2)),
    ],
  );
}

class _TopCorners extends ConsumerWidget {
  const _TopCorners();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        Scale.gutter(MediaQuery.sizeOf(context).width) - 4,
        8,
        Scale.gutter(MediaQuery.sizeOf(context).width) - 4,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RoundIconButton(
            icon: Icons.person_rounded,
            size: 42,
            onTap: () => Navigator.of(context).pushNamed('/profile'),
          ),
          _RoundIconButton(
            icon: Icons.search_rounded,
            size: 42,
            onTap: () => Navigator.of(context).pushNamed('/search'),
          ),
        ],
      ),
    ),
  );
}

class _FeedPlaceholder extends StatelessWidget {
  const _FeedPlaceholder({required this.label, this.hint});

  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hint != null)
            FishSchool(size: 84, color: Colors.white.withValues(alpha: 0.5))
          else
            const FishLoader(size: 40, color: Palette.darkAccent),
          const SizedBox(height: 16),
          Text(
            label,
            style: Fonts.sansStyle(size: 16, weight: 600, color: Colors.white),
          ),
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: Fonts.sansStyle(
                size: 12.5,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _FeedError extends StatelessWidget {
  const _FeedError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 34, color: Palette.rose),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Fonts.sansStyle(size: 14, height: 1.4, color: Colors.white),
          ),
          const SizedBox(height: 18),
          GhostButton(label: 'Повторить', onPressed: onRetry),
        ],
      ),
    ),
  );
}

class _ReminderChoice {
  const _ReminderChoice.clear() : offset = null, clear = true;
  const _ReminderChoice.pick(this.offset) : clear = false;

  final ReminderOffset? offset;
  final bool clear;
}

class _ReminderSheet extends StatelessWidget {
  const _ReminderSheet({required this.hasReminder});

  final bool hasReminder;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Palette.paper,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      border: Border(top: BorderSide(color: Palette.cardLine)),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Напомнить о событии',
              style: Fonts.sansStyle(size: 16, weight: 700),
            ),
            const SizedBox(height: 4),
            Text(
              'Выбери, когда прислать напоминание.',
              style: Fonts.sansStyle(size: 12.5, color: Palette.muted),
            ),
            const SizedBox(height: 12),
            _ReminderOption(
              icon: Icons.schedule_rounded,
              label: 'За 1 час',
              onTap: () => Navigator.pop(
                context,
                const _ReminderChoice.pick(ReminderOffset.oneHour),
              ),
            ),
            _ReminderOption(
              icon: Icons.today_rounded,
              label: 'За день',
              onTap: () => Navigator.pop(
                context,
                const _ReminderChoice.pick(ReminderOffset.oneDay),
              ),
            ),
            _ReminderOption(
              icon: Icons.tune_rounded,
              label: 'Своё время',
              onTap: () => Navigator.pop(
                context,
                const _ReminderChoice.pick(ReminderOffset.custom),
              ),
            ),
            if (hasReminder)
              _ReminderOption(
                icon: Icons.notifications_off_rounded,
                label: 'Снять напоминание',
                danger: true,
                onTap: () =>
                    Navigator.pop(context, const _ReminderChoice.clear()),
              ),
          ],
        ),
      ),
    ),
  );
}

class _ReminderOption extends StatelessWidget {
  const _ReminderOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: danger ? Palette.rose : Palette.accent,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Fonts.sansStyle(
                  size: 14,
                  color: danger ? Palette.rose : Palette.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class SharePage extends ConsumerStatefulWidget {
  const SharePage({
    super.key,
    required this.eventId,
    required this.title,
    required this.url,
  });

  final String eventId;
  final String title;
  final String url;

  @override
  ConsumerState<SharePage> createState() => _SharePageState();
}

class _SharePageState extends ConsumerState<SharePage> {
  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.url));
    if (!mounted) return;
    ToastController.show(context, 'Ссылка скопирована');
  }

  Future<void> _shareExternally() async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: widget.url, subject: widget.title),
      );
    } catch (_) {
      if (mounted) {
        ToastController.show(
          context,
          'Не удалось открыть меню обмена',
          error: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.url;
    return Scaffold(
      backgroundColor: Palette.paper,
      appBar: AppBar(
        backgroundColor: Palette.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Palette.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Поделиться',
          style: Fonts.sansStyle(size: 17, weight: 600, color: Palette.ink),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Fonts.sansStyle(
                    size: 15,
                    weight: 600,
                    color: Palette.ink2,
                  ),
                ),
                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const MicroLabel('QR события'),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            Scale.fieldRadius,
                          ),
                          border: Border.all(color: Palette.line),
                        ),
                        child: QrImageView(
                          data: url,
                          size: 210,
                          version: QrVersions.auto,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Palette.ink,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Palette.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        url,
                        textAlign: TextAlign.center,
                        style: Fonts.monoStyle(
                          size: 11.5,
                          weight: 400,
                          color: Palette.accent,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: GhostButton.pair(
                          GhostButton(
                            label: 'Копировать ссылку',
                            onPressed: _copy,
                          ),
                          PrimaryButton(
                            label: 'Поделиться',
                            arrow: false,
                            icon: Icons.ios_share_rounded,
                            onPressed: _shareExternally,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
