import 'dart:math' as math;

import 'package:flutter/material.dart';

enum ParticipantOnboardingResult { completed, skipped }

class ParticipantOnboarding extends StatefulWidget {
  const ParticipantOnboarding({super.key, required this.onFinished});

  final ValueChanged<ParticipantOnboardingResult> onFinished;

  @override
  State<ParticipantOnboarding> createState() => _ParticipantOnboardingState();
}

class _ParticipantOnboardingState extends State<ParticipantOnboarding> {
  @override
  Widget build(BuildContext context) {
    return _Session(onFinish: widget.onFinished);
  }
}

abstract final class _C {
  static const Color paper = Color(0xFFF6F6F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF0D1117);
  static const Color ink2 = Color(0xFF39424F);
  static const Color muted = Color(0xFF7B8798);
  static const Color accent = Color(0xFF0E6B76);
  static const Color accentSoft = Color(0xFFE7F1F2);
  static const Color accentLine = Color(0xFFBBD8DB);
  static const Color hairline = Color(0xFFE4E6E1);
  static const Color skeleton = Color(0xFFE8EAE5);
  static const Color bone = Color(0xFFDDDFD9);
  static const Color shade = Color(0xFFF0F1ED);
}

abstract final class _R {
  static const double control = 14;
  static const double card = 24;
  static const double sheet = 28;
  static const double pill = 999;
}

abstract final class _D {
  static const Duration quick = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 220);
  static const Duration express = Duration(milliseconds: 360);
  static const Duration stage = Duration(milliseconds: 600);
  static const Duration hold = Duration(milliseconds: 1000);
  static const Duration demoTap = Duration(milliseconds: 1800);
  static const Duration demoSwipe = Duration(milliseconds: 2200);
  static const Duration demoHold = Duration(milliseconds: 2400);
  static const Duration shimmer = Duration(milliseconds: 1600);
}

abstract final class _E {
  static const Cubic main = Cubic(0.2, 0.8, 0.2, 1);
  static const Cubic soft = Cubic(0.32, 0.72, 0.24, 1);
}

abstract final class _T {
  static const List<String> _sans = <String>['Inter', 'Roboto', 'Segoe UI', 'Arial'];
  static const List<String> _mono = <String>['Roboto Mono', 'Menlo', 'Courier New'];

  static TextStyle sans(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color color = _C.ink,
    double height = 1.3,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontFamilyFallback: _sans,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono(
    double size, {
    Color color = _C.muted,
    FontWeight weight = FontWeight.w600,
    double letterSpacing = 0.8,
    double height = 1.15,
  }) {
    return TextStyle(
      fontFamily: 'OceanMono',
      fontFamilyFallback: _mono,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

enum _Phase {
  intro,
  swipeFeed,
  media,
  favorite,
  register,
  reminder,
  description,
  share,
  report,
  search,
  profile,
  settings,
  finale,
}

enum _SheetKind { none, reminder, description, share, report, ticket }

enum _RailAction { bell, fish, info, share, flag }

enum _SceneKind { court, lab, waves, video }

enum _ProfileTab { tickets, favorites, settings }

enum _ReminderChoice { hour, day }

enum _ReportReason { wrongInfo, inappropriate, other }

enum _DemoKind {
  none,
  swipeUp,
  swipeLeft,
  tapFish,
  tapBell,
  tapInfo,
  tapShare,
  tapFlag,
  tapSearch,
  tapProfile,
  holdDrag,
}

class _EventSpec {
  const _EventSpec({
    required this.title,
    required this.category,
    required this.organizer,
    required this.place,
    required this.blurb,
    required this.scenes,
  });

  final String title;
  final String category;
  final String organizer;
  final String place;
  final String blurb;
  final List<_SceneKind> scenes;
}

class _SearchItem {
  const _SearchItem({
    required this.title,
    required this.meta,
    required this.words,
  });

  final String title;
  final String meta;
  final String words;
}

const _EventSpec _eventOne = _EventSpec(
  title: 'Открытие CampusLife',
  category: 'Учебное мероприятие',
  organizer: 'Студсовет',
  place: 'Актовый зал',
  blurb:
      'Короткий старт сезона: показываем ленту, билеты и всё, что помогает не потерять интересное.',
  scenes: <_SceneKind>[_SceneKind.court, _SceneKind.lab, _SceneKind.video],
);

const _EventSpec _eventTwo = _EventSpec(
  title: 'Вечер студенческих идей',
  category: 'Учебное мероприятие',
  organizer: 'Студсовет',
  place: 'Актовый зал',
  blurb:
      'Собираем идеи на один вечер: короткие питчи, музыка между блоками и разговоры в холле.',
  scenes: <_SceneKind>[_SceneKind.lab, _SceneKind.waves, _SceneKind.video],
);

const List<_EventSpec> _events = <_EventSpec>[_eventOne, _eventTwo];

const List<_SearchItem> _searchItems = <_SearchItem>[
  _SearchItem(
    title: 'День робототехники',
    meta: 'Лаборатория 3 · Студсовет',
    words: 'робо робот робототехника лаборатория железо схемы',
  ),
  _SearchItem(
    title: 'Вечер студенческих идей',
    meta: 'Актовый зал · Студсовет',
    words: 'идеи вечер питч актовый зал разговоры',
  ),
  _SearchItem(
    title: 'Открытие CampusLife',
    meta: 'Актовый зал · Студсовет',
    words: 'открытие лента старт campuslife сезон',
  ),
  _SearchItem(
    title: 'Баскетбольный турнир',
    meta: 'Спортзал · Спортклуб',
    words: 'баскетбол спорт турнир площадка мяч',
  ),
];

double _saturate(double value) => math.max(0.0, math.min(1.0, value));

class _FeedGeometry {
  const _FeedGeometry({
    required this.size,
    required this.mediaHeight,
    required this.action,
    required this.trackTravel,
    required this.trackThreshold,
  });

  final Size size;
  final double mediaHeight;
  final Offset action;
  final double trackTravel;
  final double trackThreshold;

  static _FeedGeometry of(Size size) {
    final double media = math.min(
      math.max(size.height * 0.6, 240),
      size.height - 210,
    );
    final double track = math.min(
      214.0,
      math.max(132.0, size.width * 0.55),
    );
    return _FeedGeometry(
      size: size,
      mediaHeight: math.max(180, media),
      action: Offset(size.width - 44, math.max(180, media) - 30),
      trackTravel: track * 0.72,
      trackThreshold: track * 0.4,
    );
  }
}

class _Session extends StatefulWidget {
  const _Session({required this.onFinish});

  final ValueChanged<ParticipantOnboardingResult> onFinish;

  @override
  State<_Session> createState() => _SessionState();
}

class _SessionState extends State<_Session> with TickerProviderStateMixin {
  static const int _stepCount = 11;

  late final AnimationController _demo;
  late final AnimationController _overlay;
  late final AnimationController _intro;
  late final AnimationController _burst;
  late final AnimationController _hold;
  late final AnimationController _return;
  late final AnimationController _pulse;
  late final PageController _pages;

  final TextEditingController _searchText = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final List<PageController> _mediaControllers = <PageController>[
    PageController(),
    PageController(),
  ];
  final ValueNotifier<double> _dragX = ValueNotifier<double>(0);

  _Phase _phase = _Phase.intro;
  _SheetKind _sheet = _SheetKind.none;
  _ProfileTab _tab = _ProfileTab.tickets;

  bool _reduceMotion = false;
  bool _finished = false;
  bool _demoActive = false;
  bool _overlayVisible = false;
  bool _overlayClosing = false;
  bool _introStarted = false;
  bool _mountedExit = false;

  int _feedIndex = 0;
  final Map<int, int> _mediaIndex = <int, int>{0: 0, 1: 0};
  bool _mediaDone = false;
  bool _favorite = false;
  bool _registered = false;
  bool _reminded = false;
  _ReminderChoice? _reminder;
  bool _descriptionRead = false;
  bool _shared = false;
  bool _reported = false;
  _ReportReason? _reportReason;
  String? _foundEvent;
  bool _profileOpen = false;
  bool _ticketOpened = false;
  bool _settingsVisited = false;
  bool _tooShort = false;

  bool _dragHeld = false;
  bool _dragArmed = false;
  bool _holdReady = false;
  double _dragStartX = 0;
  bool _dragPast = false;
  double _travel = 140;
  double _threshold = 80;

  String _searchQuery = '';
  Timer? _resume;

  @override
  void initState() {
    super.initState();
    _pages = PageController();
    _demo = AnimationController(vsync: this, duration: _D.demoSwipe);
    _overlay = AnimationController(vsync: this, duration: _D.base);
    _intro = AnimationController(vsync: this, duration: _D.stage);
    _burst = AnimationController(vsync: this, duration: _D.stage);
    _hold = AnimationController(vsync: this, duration: _D.hold)
      ..addStatusListener(_onHoldStatus);
    _return = AnimationController(vsync: this, duration: _D.base)
      ..addListener(_onReturnTick);
    _pulse = AnimationController(vsync: this, duration: _D.shimmer);
  }

  void _onReturnTick() {
    _dragX.value = _return.value;
  }

  void _onHoldStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (!_dragHeld || _holdReady) return;
    setState(() => _holdReady = true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool reduce = MediaQuery.disableAnimationsOf(context);
    _reduceMotion = reduce;
    if (reduce) {
      _demo.stop();
      _pulse.stop();
      _demoActive = false;
      _overlay.value = 0;
      _hold.stop();
      _burst.stop();
      _return.stop();
      if (_intro.value != 1) _intro.value = 1;
    } else {
      if (!_introStarted && _phase == _Phase.intro) {
        _introStarted = true;
        _intro.forward(from: 0);
      }
      if (!_pulse.isAnimating) _pulse.repeat();
    }
    _syncDemo();
  }

  @override
  void dispose() {
    _resume?.cancel();
    _demo.dispose();
    _overlay.dispose();
    _intro.dispose();
    _burst.dispose();
    _hold.dispose();
    _return.dispose();
    _pulse.dispose();
    _pages.dispose();
    for (final PageController controller in _mediaControllers) {
      controller.dispose();
    }
    _dragX.dispose();
    _searchText.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  int get _stepNumber {
    return switch (_phase) {
      _Phase.intro || _Phase.finale => _stepCount,
      _Phase.swipeFeed => 1,
      _Phase.media => 2,
      _Phase.favorite => 3,
      _Phase.register => 4,
      _Phase.reminder => 5,
      _Phase.description => 6,
      _Phase.share => 7,
      _Phase.report => 8,
      _Phase.search => 9,
      _Phase.profile => 10,
      _Phase.settings => 11,
    };
  }

  bool _isDone(_Phase phase) {
    return switch (phase) {
      _Phase.swipeFeed => _feedIndex >= 1,
      _Phase.media => _mediaDone,
      _Phase.favorite => _favorite,
      _Phase.register => _registered,
      _Phase.reminder => _reminded,
      _Phase.description => _descriptionRead,
      _Phase.share => _shared,
      _Phase.report => _reported,
      _Phase.search => _foundEvent != null,
      _Phase.profile => _ticketOpened,
      _Phase.settings => _settingsVisited,
      _ => false,
    };
  }

  _Phase? _nextPhase(_Phase phase) {
    return switch (phase) {
      _Phase.swipeFeed => _Phase.media,
      _Phase.media => _Phase.favorite,
      _Phase.favorite => _Phase.register,
      _Phase.register => _Phase.reminder,
      _Phase.reminder => _Phase.description,
      _Phase.description => _Phase.share,
      _Phase.share => _Phase.report,
      _Phase.report => _Phase.search,
      _Phase.search => _Phase.profile,
      _Phase.profile => _Phase.settings,
      _Phase.settings => _Phase.finale,
      _ => null,
    };
  }

  void _finish(ParticipantOnboardingResult result) {
    if (_finished) return;
    _finished = true;
    widget.onFinish(result);
  }

  void _setPhase(_Phase phase) {
    if (!mounted || _phase == phase) return;
    _resume?.cancel();
    if (phase == _Phase.finale && !_reduceMotion) _burst.forward(from: 0);
    final bool wasSearch = _phase == _Phase.search;
    setState(() {
      _phase = phase;
      _demoActive = false;
      _tooShort = false;
      if (wasSearch && phase != _Phase.search) {
        _profileOpen = false;
        _searchQuery = '';
        _searchText.clear();
      }
    });
    if (wasSearch) _searchFocus.unfocus();
    _syncDemo();
  }

  _DemoKind _demoKindFor(_Phase phase) {
    return switch (phase) {
      _Phase.swipeFeed => _DemoKind.none,
      _Phase.media => _DemoKind.swipeLeft,
      _Phase.favorite => _DemoKind.tapFish,
      _Phase.register => _DemoKind.holdDrag,
      _Phase.reminder => _DemoKind.tapBell,
      _Phase.description => _DemoKind.tapInfo,
      _Phase.share => _DemoKind.tapShare,
      _Phase.report => _DemoKind.tapFlag,
      _Phase.search => _DemoKind.tapSearch,
      _Phase.profile || _Phase.settings => _DemoKind.tapProfile,
      _ => _DemoKind.none,
    };
  }

  Duration _demoDuration(_DemoKind kind) {
    return switch (kind) {
      _DemoKind.holdDrag => _D.demoHold,
      _DemoKind.swipeUp || _DemoKind.swipeLeft => _D.demoSwipe,
      _ => _D.demoTap,
    };
  }

  bool get _overlayBlocksDemo =>
      _sheet != _SheetKind.none || _profileOpen || _overlayVisible;

  void _syncDemo() {
    final _DemoKind kind = _demoKindFor(_phase);
    final bool wants = !_reduceMotion &&
        kind != _DemoKind.none &&
        !_isDone(_phase) &&
        !_overlayBlocksDemo &&
        !_dragHeld;
    if (!wants) {
      if (_demo.isAnimating) _demo.stop();
      _demoActive = false;
      return;
    }
    if (!_demo.isAnimating) {
      _demo.duration = _demoDuration(kind);
      _demoActive = true;
      _demo.repeat();
    }
  }

  void _stopDemo() {
    _resume?.cancel();
    if (_demo.isAnimating) _demo.stop();
    if (_demoActive && mounted) setState(() => _demoActive = false);
    _scheduleResume();
  }

  void _scheduleResume() {
    _resume?.cancel();
    if (_reduceMotion) return;
    final _Phase phase = _phase;
    _resume = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted || _phase != phase) return;
      if (_isDone(phase) || _overlayBlocksDemo || _dragHeld) return;
      setState(() => _demoActive = true);
      _syncDemo();
    });
  }

  void _complete(_Phase phase) {
    if (!mounted || _phase != phase || _isDone(phase)) return;
    setState(() {
      switch (phase) {
        case _Phase.media:
          _mediaDone = true;
        case _Phase.favorite:
          _favorite = true;
        case _Phase.register:
          _registered = true;
          _dragHeld = false;
          _dragArmed = false;
          _holdReady = false;
          _dragPast = false;
          _dragX.value = 0;
          _hold
            ..stop()
            ..reset();
        case _Phase.reminder:
          _reminded = true;
        case _Phase.description:
          _descriptionRead = true;
        case _Phase.share:
          _shared = true;
        case _Phase.report:
          _reported = true;
        case _Phase.profile:
          _ticketOpened = true;
        case _Phase.settings:
          _settingsVisited = true;
        case _Phase.intro:
        case _Phase.swipeFeed:
        case _Phase.search:
        case _Phase.finale:
          break;
      }
      _demoActive = false;
    });
    if (phase == _Phase.favorite || phase == _Phase.register) {
      _burst.forward(from: 0);
    }
    _syncDemo();
  }

  void _advance() {
    final _Phase from = _phase;
    if (!_isDone(from)) return;
    final _Phase? next = _nextPhase(from);
    if (next == null) return;
    if (_sheet != _SheetKind.none) _closeSheet();
    _resume?.cancel();
    if (from == _Phase.search) {
      _searchFocus.unfocus();
      _profileOpen = false;
    }
    _setPhase(next);
  }

  void _openSheet(_SheetKind kind) {
    if (_sheet != _SheetKind.none || _overlayClosing) return;
    _resume?.cancel();
    _demo.stop();
    setState(() {
      _sheet = kind;
      _overlayVisible = true;
      _demoActive = false;
    });
    if (_reduceMotion) {
      _overlay.value = 1;
    } else {
      _overlay.forward(from: 0);
    }
  }

  Future<void> _closeSheet() async {
    if (_sheet == _SheetKind.none || _overlayClosing) return;
    _overlayClosing = true;
    if (_reduceMotion) {
      _overlay.value = 0;
    } else {
      await _overlay.reverse();
    }
    if (!mounted) {
      _overlayClosing = false;
      return;
    }
    setState(() {
      _sheet = _SheetKind.none;
      _overlayVisible = false;
      _overlayClosing = false;
    });
    _syncDemo();
  }

  void _onFishTap() {
    if (_phase == _Phase.favorite) {
      _complete(_Phase.favorite);
      return;
    }
    if (_phase == _Phase.register) {
      _stopDemo();
      setState(() => _tooShort = true);
    }
  }

  void _onLongPressDown(LongPressDownDetails details) {
    if (_phase != _Phase.register) return;
    _resume?.cancel();
    _demo.stop();
    _return.stop();
    final double width = MediaQuery.sizeOf(context).width;
    final double track = math.min(214.0, math.max(132.0, width * 0.55));
    setState(() {
      _dragHeld = true;
      _dragArmed = false;
      _holdReady = false;
      _dragPast = false;
      _dragStartX = details.globalPosition.dx;
      _tooShort = false;
      _demoActive = false;
      _travel = track * 0.72;
      _threshold = track * 0.4;
    });
    _dragX.value = 0;
    _hold.forward(from: 0);
  }

  void _onLongPressStart(LongPressStartDetails details) {
    if (_phase != _Phase.register || !_dragHeld) return;
    setState(() => _dragArmed = true);
  }

  void _onLongPressMove(LongPressMoveUpdateDetails details) {
    if (!_dragArmed || !_holdReady) return;
    final double dx =
        (details.globalPosition.dx - _dragStartX).clamp(-_travel, 0.0);
    _dragX.value = dx;
    final bool past = dx <= -_threshold;
    if (past != _dragPast) setState(() => _dragPast = past);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (!_dragArmed || !_holdReady) {
      _abortHold();
      return;
    }
    final double dx =
        (details.globalPosition.dx - _dragStartX).clamp(-_travel, 0.0);
    _dragX.value = dx;
    if (dx <= -_threshold) {
      _complete(_Phase.register);
      _return.stop();
      _dragX.value = 0;
      return;
    }
    _abortHold();
  }

  void _onLongPressCancel() {
    _abortHold();
  }

  void _abortHold() {
    _hold
      ..stop()
      ..reset();
    if (!mounted) return;
    final double from = _dragX.value;
    setState(() {
      _dragHeld = false;
      _dragArmed = false;
      _holdReady = false;
      _dragPast = false;
    });
    if (!_reduceMotion && from < -0.5) {
      _return
        ..value = from
        ..animateBack(0, duration: _D.base, curve: _E.main);
    } else {
      _dragX.value = 0;
    }
    _scheduleResume();
  }

  void _showEvent(int index) {
    if (index < 0 || index >= _events.length) return;
    if (index == _feedIndex) return;
    _stopDemo();
    setState(() => _feedIndex = index);
    if (_phase == _Phase.swipeFeed) {
      _setPhase(_Phase.media);
    } else {
      _syncDemo();
    }
  }

  void _jumpTo(int index) {
    if (index < 0 || index >= _events.length) return;
    if (index == _feedIndex) return;
    _stopDemo();
    if (_reduceMotion) {
      _pages.jumpToPage(index);
    } else {
      _pages.animateToPage(index, duration: _D.express, curve: _E.soft);
    }
    setState(() => _feedIndex = index);
    if (_phase == _Phase.swipeFeed) _setPhase(_Phase.media);
  }

  List<_SearchItem> _results() {
    final String q =
        _searchQuery.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
    if (q.isEmpty) return const <_SearchItem>[];
    return _searchItems
        .where(
          (_SearchItem item) =>
              item.title.toLowerCase().contains(q) ||
              item.meta.toLowerCase().contains(q) ||
              item.words.contains(q),
        )
        .toList(growable: false);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (_foundEvent != null) _foundEvent = null;
    });
  }

  void _onSearchPressed() {
    if (_phase != _Phase.search || _profileOpen) return;
    _resume?.cancel();
    _demo.stop();
    setState(() {
      _profileOpen = true;
      _demoActive = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_profileOpen) return;
      _searchFocus.requestFocus();
    });
  }

  void _leaveSearch() {
    _searchFocus.unfocus();
    if (!_profileOpen) return;
    setState(() => _profileOpen = false);
    _syncDemo();
  }

  void _selectResult(_SearchItem item) {
    if (_foundEvent != null) return;
    _searchFocus.unfocus();
    setState(() {
      _foundEvent = item.title;
      _profileOpen = false;
      _searchQuery = item.title;
      _searchText.text = item.title;
      _searchText.selection = TextSelection.collapsed(
        offset: _searchText.text.length,
      );
    });
    _syncDemo();
  }

  void _onProfilePressed() {
    if (_profileOpen) return;
    if (_phase != _Phase.profile && _phase != _Phase.settings) return;
    _resume?.cancel();
    _demo.stop();
    setState(() {
      _profileOpen = true;
      _demoActive = false;
      _tab = _phase == _Phase.settings
          ? _ProfileTab.settings
          : _ProfileTab.tickets;
      if (_phase == _Phase.settings) _settingsVisited = true;
    });
  }

  void _closeProfile() {
    if (!_profileOpen) return;
    setState(() => _profileOpen = false);
    _syncDemo();
  }

  void _selectTab(_ProfileTab tab) {
    if (_tab == tab) return;
    setState(() {
      _tab = tab;
      if (tab == _ProfileTab.settings && _phase == _Phase.settings) {
        _settingsVisited = true;
      }
    });
  }

  void _openTicket() {
    if (_tab != _ProfileTab.tickets) return;
    _openSheet(_SheetKind.ticket);
    if (_phase == _Phase.profile) {
      _complete(_Phase.profile);
      setState(() => _profileOpen = false);
    }
  }

  void _finishFinale() {
    _resume?.cancel();
    _setPhase(_Phase.finale);
  }

  void _trySettingsRow() {
    if (_phase != _Phase.settings) return;
    setState(() {
      _settingsVisited = true;
      _profileOpen = false;
    });
    _complete(_Phase.settings);
  }

  @override
  Widget build(BuildContext context) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1);
    return Material(
      color: _C.paper,
      child: DefaultTextStyle(
        style: _T.sans(14, color: _C.ink2),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;
            if (width <= 0 || height <= 0) return const SizedBox.shrink();
            final Size size = Size(width, height);
            if (_phase == _Phase.intro) {
              return SafeArea(child: _buildIntro(size, textScale));
            }
            if (_phase == _Phase.finale) {
              return PopScope(
                canPop: false,
                child: SafeArea(child: _buildFinale(size, textScale)),
              );
            }
            return Stack(
              children: <Widget>[
                Positioned.fill(child: _buildFeed(size, textScale)),
                if (_overlayVisible)
                  _buildSheetLayer(width, height, textScale),
              ],
            );
          },
        ),
      ),
    );
  }

  _RailAction? _actionFor(_Phase phase) {
    return switch (phase) {
      _Phase.reminder => _RailAction.bell,
      _Phase.favorite || _Phase.register => _RailAction.fish,
      _Phase.description => _RailAction.info,
      _Phase.share => _RailAction.share,
      _Phase.report => _RailAction.flag,
      _ => null,
    };
  }

  Widget _buildFeed(Size size, double textScale) {
    final _FeedGeometry geo = _FeedGeometry.of(size);
    final bool done = _isDone(_phase);
    return Stack(
      children: <Widget>[
        const Positioned.fill(child: ColoredBox(color: _C.paper)),
        Positioned.fill(
          child: PageView.builder(
            controller: _pages,
            scrollDirection: Axis.vertical,
            physics: done
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(parent: ClampingScrollPhysics()),
            itemCount: _events.length,
            onPageChanged: (int index) {
              if (index == _feedIndex) return;
              setState(() => _feedIndex = index);
              if (_phase == _Phase.swipeFeed) _setPhase(_Phase.media);
            },
            itemBuilder: (BuildContext context, int index) {
              return _FeedSlide(
                geo: geo,
                event: _events[index],
                index: index,
                active: index == _feedIndex,
                done: done && index == _feedIndex,
                reduceMotion: _reduceMotion,
                pulse: _pulse,
                feedController: _pages,
                mediaController: _mediaControllers[index],
                mediaIndex: _mediaIndex[index] ?? 0,
                onMediaChanged: (int value) => _onMediaChangedFor(index, value),
                reveal: _isDone(_phase),
                focusLabel: index == _feedIndex ? _focusLabel() : '',
                tooShort: _tooShort && index == _feedIndex,
                phase: _phase,
              );
            },
          ),
        ),
        if (!_reduceMotion && _demoActive && !_overlayBlocksDemo && !done)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _demo,
                  builder: (BuildContext context, Widget? child) {
                    return CustomPaint(
                      painter: _HandPainter(
                        kind: _demoKindFor(_phase),
                        t: _demo.value,
                        size: size,
                        mediaHeight: geo.mediaHeight,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        if (done && _phase != _Phase.settings)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragEnd: (DragEndDetails details) {
                final double velocity = details.primaryVelocity ?? 0;
                if (velocity > 160) _advance();
              },
              child: const SizedBox.expand(),
            ),
          ),
        if (_phase == _Phase.swipeFeed && !done)
          Positioned(
            left: 0,
            right: 0,
            bottom: 150,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: const BoxDecoration(
                    color: _C.surface,
                    borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(width: 6, height: 6, color: _C.accent),
                      const SizedBox(width: 7),
                      Text(
                        'Смахни вверх: следующее событие',
                        style: _T.sans(
                          12,
                          weight: FontWeight.w700,
                          color: _C.ink2,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    _C.paper.withValues(alpha: 0.92),
                    _C.paper.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            minimum: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: _TopBar(
              step: _stepNumber,
              total: _stepCount,
              done: done,
              onSkip: () => _finish(ParticipantOnboardingResult.skipped),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 150,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    _C.paper.withValues(alpha: 0.96),
                    _C.paper.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: _FocusedAction(
                  hint: _focusLabel(),
                  phase: _phase,
                  done: done,
                  reduceMotion: _reduceMotion,
                  hold: _hold,
                  dragX: _dragX,
                  travel: geo.trackTravel,
                  threshold: geo.trackThreshold,
                  past: _dragPast,
                  holdReady: _holdReady,
                  onTap: _onActionTap,
                  onLongPressDown: _onLongPressDown,
                  onLongPressStart: _onLongPressStart,
                  onLongPressMove: _onLongPressMove,
                  onLongPressEnd: _onLongPressEnd,
                  onLongPressCancel: _onLongPressCancel,
                  onNext: _phase == _Phase.settings ? _finishFinale : _advance,
                ),
              ),
            ),
          ),
        ),
        if (_dragHeld && _phase == _Phase.register)
          Positioned(
            left: 0,
            right: 0,
            bottom: 96,
            child: IgnorePointer(
              child: Center(
                child: _HoldTrack(
                  hold: _hold,
                  dragX: _dragX,
                  travel: geo.trackTravel,
                  threshold: geo.trackThreshold,
                  past: _dragPast,
                  ready: _holdReady,
                ),
              ),
            ),
          ),
        if (_profileOpen)
          Positioned.fill(
            child: _phase == _Phase.search
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: _SearchOverlay(
                      controller: _searchText,
                      focusNode: _searchFocus,
                      query: _searchQuery,
                      results: _results(),
                      selected: _foundEvent,
                      canSelect: true,
                      onChanged: _onSearchChanged,
                      onSelect: _selectResult,
                      onClose: _leaveSearch,
                    ),
                  )
                : _ProfileOverlay(
                    selected: _tab,
                    onTab: _selectTab,
                    onClose: _closeProfile,
                    onTicket: _openTicket,
                    onRetry: _trySettingsRow,
                    canOpenTicket: _phase == _Phase.profile,
                    canRetry: _phase == _Phase.settings,
                    ticketOpened: _ticketOpened,
                    settingsVisited: _settingsVisited,
                    canSettingsTab: _phase == _Phase.settings,
                  ),
          ),
      ],
    );
  }

  String _focusLabel() {
    return switch (_phase) {
      _Phase.swipeFeed => 'Смахни вверх — откроется второе событие',
      _Phase.media => 'Смахни влево — у события есть фото и видео',
      _Phase.favorite => 'Нажми на рыбку — сохраним событие в избранное',
      _Phase.register => 'Удерживай кнопку и веди влево — так ты записываешься',
      _Phase.reminder => 'Нажми на колокольчик и выбери, когда напомнить',
      _Phase.description => 'Открой описание: программа, место и условия',
      _Phase.share => 'Поделись событием с друзьями',
      _Phase.report => 'Сообщи, если с событием что-то не так',
      _Phase.search => 'Найди событие поиском: подойдёт запрос «робо»',
      _Phase.profile => 'Открой профиль: там билеты и избранное',
      _Phase.settings => 'Найди в настройках «Пройти обучение заново»',
      _ => '',
    };
  }

  void _onActionTap() {
    if (_isDone(_phase)) {
      if (_phase == _Phase.settings) {
        _finishFinale();
      } else {
        _advance();
      }
      return;
    }
    switch (_phase) {
      case _Phase.swipeFeed:
        _jumpTo(_feedIndex + 1);
      case _Phase.media:
        _nextMedia();
      case _Phase.favorite:
      case _Phase.register:
        _onFishTap();
      case _Phase.reminder:
        _openSheet(_SheetKind.reminder);
      case _Phase.description:
        _openSheet(_SheetKind.description);
      case _Phase.share:
        _openSheet(_SheetKind.share);
      case _Phase.report:
        _openSheet(_SheetKind.report);
      case _Phase.search:
        _onSearchPressed();
      case _Phase.profile:
      case _Phase.settings:
        _onProfilePressed();
      case _Phase.intro:
      case _Phase.finale:
        break;
    }
  }

  void _nextMedia() {
    final int current = _mediaIndex[_feedIndex] ?? 0;
    final int count = _events[_feedIndex].scenes.length;
    if (current >= count - 1) return;
    _stopDemo();
    _mediaControllers[_feedIndex]!.animateToPage(
      current + 1,
      duration: _D.express,
      curve: _E.soft,
    );
  }

  void _onMediaChangedFor(int index, int value) {
    _mediaIndex[index] = value;
    if (_phase == _Phase.media && index == _feedIndex && value >= 1) {
      if (!_mediaDone) _complete(_Phase.media);
    } else {
      setState(() {});
    }
  }

  Widget _buildIntro(Size size, double textScale) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const _FishMark(size: 26),
              const SizedBox(width: 10),
              Text(
                'CampusLife',
                style: _T.sans(15, weight: FontWeight.w800, letterSpacing: -0.2),
              ),
            ],
          ),
          const SizedBox(height: 34),
          _IntroArt(controller: _intro, reduceMotion: _reduceMotion),
          const SizedBox(height: 28),
          Text(
            'Твой кампус — в одном движении',
            style: _T.sans(
              textScale > 1.15 ? 27 : 32,
              weight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Одиннадцать коротких шагов на учебном событии. Всё можно пропустить.',
            style: _T.sans(15, color: _C.ink2, height: 1.45),
          ),
          const SizedBox(height: 20),
          const _MetaRow(),
          const SizedBox(height: 30),
          _PrimaryButton(
            label: 'Попробовать',
            onTap: () => _setPhase(_Phase.swipeFeed),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFinale(Size size, double textScale) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const _FishMark(size: 26),
              const SizedBox(width: 10),
              Text(
                'CampusLife',
                style: _T.sans(15, weight: FontWeight.w800, letterSpacing: -0.2),
              ),
            ],
          ),
          const SizedBox(height: 34),
          _FinaleArt(controller: _burst, reduceMotion: _reduceMotion),
          const SizedBox(height: 28),
          Text(
            'Готово. Теперь ты в потоке',
            style: _T.sans(
              textScale > 1.15 ? 27 : 32,
              weight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Листай события, сохраняй интересное и не теряй свои билеты.',
            style: _T.sans(15, color: _C.ink2, height: 1.45),
          ),
          const SizedBox(height: 22),
          const _FinaleSummary(),
          const SizedBox(height: 30),
          _PrimaryButton(
            label: 'Перейти к событиям',
            onTap: () => _finish(ParticipantOnboardingResult.completed),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetLayer(double width, double height, double textScale) {
    final double maxSheet = math.max(200, height - 120);
    return Positioned(
      top: 56,
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _overlay,
        builder: (BuildContext context, Widget? child) {
          final double t = Curves.easeOutCubic.transform(
            _saturate(_overlay.value),
          );
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _closeSheet,
                  child: ColoredBox(
                    color: _C.ink.withValues(alpha: 0.18 * t),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 44),
                      child: _buildSheetContent(width, maxSheet, textScale),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSheetContent(double width, double maxSheet, double textScale) {
    final Widget body = switch (_sheet) {
      _SheetKind.reminder => _ReminderSheet(
          selected: _reminder,
          onSelect: _selectReminder,
          onClose: _closeSheet,
        ),
      _SheetKind.description => _DescriptionSheet(
          event: _events[_feedIndex],
          done: _descriptionRead,
          onConfirm: _confirmDescription,
          onClose: _closeSheet,
        ),
      _SheetKind.share => _ShareSheet(
          copied: _shared,
          onCopy: _copyDemoLink,
          onClose: _closeSheet,
        ),
      _SheetKind.report => _ReportSheet(
          reason: _reportReason,
          sent: _reported,
          onReason: _selectReportReason,
          onSend: _sendReport,
          onClose: _closeSheet,
        ),
      _SheetKind.ticket => _TicketSheet(
          event: _events[_feedIndex],
          onClose: _closeSheet,
        ),
      _SheetKind.none => const SizedBox.shrink(),
    };
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(width, 560),
        maxHeight: maxSheet,
      ),
      child: body,
    );
  }

  void _selectReminder(_ReminderChoice choice) {
    if (_reminded) return;
    setState(() => _reminder = choice);
    _complete(_Phase.reminder);
    _closeSheet();
  }

  void _confirmDescription() {
    if (!_descriptionRead) _complete(_Phase.description);
    _closeSheet();
  }

  void _copyDemoLink() {
    if (_shared) return;
    _complete(_Phase.share);
  }

  void _selectReportReason(_ReportReason reason) {
    if (_reported) return;
    setState(() => _reportReason = reason);
  }

  void _sendReport() {
    if (_reportReason == null || _reported) return;
    _complete(_Phase.report);
  }
}


class _FeedSlide extends StatelessWidget {
  const _FeedSlide({
    required this.event,
    required this.index,
    required this.active,
    required this.done,
    required this.reduceMotion,
    required this.pulse,
    required this.feedController,
    required this.mediaController,
    required this.mediaIndex,
    required this.onMediaChanged,
    required this.reveal,
    required this.geo,
    required this.focusLabel,
    required this.tooShort,
    required this.phase,
  });

  final _EventSpec event;
  final int index;
  final bool active;
  final bool done;
  final bool reduceMotion;
  final Animation<double> pulse;
  final PageController feedController;
  final PageController mediaController;
  final int mediaIndex;
  final ValueChanged<int> onMediaChanged;
  final bool reveal;
  final _FeedGeometry geo;
  final String focusLabel;
  final bool tooShort;
  final _Phase phase;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: feedController,
      builder: (BuildContext context, Widget? child) {
        final double page = _pageValue();
        final double delta = (page - index).clamp(-1.0, 1.0);
        final double scale = 1 - delta.abs() * 0.06;
        final double fade = 1 - delta.abs() * 0.55;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: _saturate(fade),
            child: child,
          ),
        );
      },
      child: _buildBody(context),
    );
  }

  double _pageValue() {
    if (!feedController.hasClients) return index.toDouble();
    return feedController.page ?? index.toDouble();
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: geo.mediaHeight,
          child: RepaintBoundary(
            child: PageView.builder(
              controller: mediaController,
              itemCount: event.scenes.length,
              physics: const PageScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              onPageChanged: onMediaChanged,
              itemBuilder: (BuildContext context, int i) {
                final _SceneKind kind = event.scenes[i];
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _SceneArt(kind: kind, dimmed: !active),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: _MediaBadge(
                        count: event.scenes.length,
                        index: mediaIndex,
                        video: kind == _SceneKind.video,
                        active: active,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: geo.mediaHeight,
          bottom: 0,
          child: _SkeletonText(reveal: reveal, event: event),
        ),
        Positioned(
          right: 16,
          top: math.max(12, geo.mediaHeight - 132),
          child: _ActionGlyph(
            action: _actionFor(phase),
            focused: active,
            accent: phase == _Phase.reminder ||
                phase == _Phase.favorite ||
                phase == _Phase.register ||
                phase == _Phase.description ||
                phase == _Phase.share ||
                phase == _Phase.report,
          ),
        ),
        Positioned(
          left: 20,
          top: math.max(10, geo.mediaHeight - 134),
          child: _FocusDot(
            visible: active && focusLabel.isNotEmpty && !done,
            reduceMotion: reduceMotion,
            pulse: pulse,
          ),
        ),
        if (active && tooShort)
          Positioned(
            left: 16,
            right: 76,
            top: geo.mediaHeight - 64,
            child: const _TooShortNote(),
          ),
      ],
    );
  }
}

class _SceneArt extends StatelessWidget {
  const _SceneArt({required this.kind, required this.dimmed});

  final _SceneKind kind;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomPaint(
            painter: switch (kind) {
              _SceneKind.court => const _CourtPainter(),
              _SceneKind.lab => const _LabPainter(),
              _SceneKind.waves => const _WavesPainter(),
              _SceneKind.video => const _VideoPainter(),
            },
          ),
          Positioned.fill(
            child: ColoredBox(
              color: _C.paper.withValues(alpha: dimmed ? 0.55 : 0.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourtPainter extends CustomPainter {
  const _CourtPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.shade);
    final Paint soft = Paint()..color = _C.skeleton;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.22, size.width * 0.5, size.height * 0.2),
      soft,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.48, size.width * 0.34, size.height * 0.3),
      Paint()..color = _C.bone,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.52, size.height * 0.54, size.width * 0.36, size.height * 0.24),
      soft,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.82, size.width, size.height * 0.18),
      Paint()..color = _C.skeleton,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LabPainter extends CustomPainter {
  const _LabPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.shade);
    final Paint line = Paint()
      ..color = _C.bone
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    final Paint block = Paint()..color = _C.skeleton;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.14, size.height * 0.3, size.width * 0.24, size.height * 0.18),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.55, size.height * 0.42, size.width * 0.3, size.height * 0.26),
      Paint()..color = _C.bone,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.86, size.width, size.height * 0.14),
      block,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavesPainter extends CustomPainter {
  const _WavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.shade);
    final Paint wave = Paint()
      ..color = _C.bone
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < 6; i++) {
      final Path path = Path();
      final double base = size.height * (0.22 + i * 0.13);
      path.moveTo(0, base);
      for (double x = 0; x <= size.width; x += 10) {
        path.lineTo(x, base + math.sin(x / 46 + i) * 7);
      }
      canvas.drawPath(path, wave);
    }
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.3, size.width * 0.34, size.height * 0.16),
      Paint()..color = _C.skeleton,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VideoPainter extends CustomPainter {
  const _VideoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.shade);
    final Rect screen = Rect.fromLTWH(
      size.width * 0.12,
      size.height * 0.2,
      size.width * 0.76,
      size.height * 0.44,
    );
    canvas.drawRect(screen, Paint()..color = _C.skeleton);
    final Offset center = screen.center;
    canvas.drawCircle(center, 26, Paint()..color = _C.bone);
    final Path play = Path()
      ..moveTo(center.dx - 7, center.dy - 11)
      ..lineTo(center.dx + 12, center.dy)
      ..lineTo(center.dx - 7, center.dy + 11)
      ..close();
    canvas.drawPath(play, Paint()..color = _C.surface);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.12, size.height * 0.7, size.width * 0.76, 8),
      Paint()..color = _C.bone,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.step,
    required this.total,
    required this.done,
    required this.onSkip,
  });

  final int step;
  final int total;
  final bool done;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const _FishMark(size: 22),
        const SizedBox(width: 8),
        Text(
          'CampusLife',
          style: _T.sans(13.5, weight: FontWeight.w800, letterSpacing: -0.2),
        ),
        const Spacer(),
        _PixelProgress(step: step, total: total, done: done),
        const SizedBox(width: 2),
        Semantics(
          button: true,
          label: 'Пропустить обучение',
          excludeSemantics: true,
          child: TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              minimumSize: const Size(78, 44),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              foregroundColor: _C.muted,
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: Text(
              'Пропустить',
              style: _T.sans(12.5, weight: FontWeight.w700, color: _C.muted),
            ),
          ),
        ),
      ],
    );
  }
}

class _PixelProgress extends StatelessWidget {
  const _PixelProgress({
    required this.step,
    required this.total,
    required this.done,
  });

  final int step;
  final int total;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Прогресс обучения: шаг $step из $total',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 1; i <= total; i++)
            AnimatedContainer(
              duration: _D.base,
              curve: _E.main,
              width: i == step ? 14 : 5,
              height: 5,
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: i < step || (i == step && done)
                    ? _C.accent
                    : i == step
                        ? _C.ink.withValues(alpha: 0.45)
                        : _C.hairline,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
        ],
      ),
    );
  }
}

class _FishMark extends StatelessWidget {
  const _FishMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FishMarkPainter(color: _C.ink)),
    );
  }
}

class _FishMarkPainter extends CustomPainter {
  const _FishMarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / 10;
    const List<String> rows = <String>[
      '   ####   ',
      ' ##@@@@#  ',
      '#@@@@@@@# ',
      '#@#@@@@@##',
      '#@@@@@@@# ',
      ' ##@@@@#  ',
      '   ####   ',
    ];
    final Paint solid = Paint()..color = color;
    for (int y = 0; y < rows.length; y++) {
      for (int x = 0; x < rows[y].length; x++) {
        if (rows[y][x] == ' ') continue;
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell - 0.8, cell - 0.8),
          solid,
        );
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(cell * 2.6, cell * 1.6, cell * 0.9, cell * 0.9),
      Paint()..color = _C.surface,
    );
  }

  @override
  bool shouldRepaint(covariant _FishMarkPainter old) => old.color != color;
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: _D.quick,
        opacity: enabled ? 1 : 0.4,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onTap : null,
          child: Container(
            constraints: const BoxConstraints(minHeight: 54),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: _C.accent,
              borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: _T.sans(
                  15,
                  weight: FontWeight.w800,
                  color: _C.surface,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusedAction extends StatelessWidget {
  const _FocusedAction({
    required this.hint,
    required this.phase,
    required this.done,
    required this.reduceMotion,
    required this.hold,
    required this.dragX,
    required this.travel,
    required this.threshold,
    required this.past,
    required this.holdReady,
    required this.onTap,
    required this.onLongPressDown,
    required this.onLongPressStart,
    required this.onLongPressMove,
    required this.onLongPressEnd,
    required this.onLongPressCancel,
    required this.onNext,
  });

  final String hint;
  final _Phase phase;
  final bool done;
  final bool reduceMotion;
  final Animation<double> hold;
  final ValueListenable<double> dragX;
  final double travel;
  final double threshold;
  final bool past;
  final bool holdReady;
  final VoidCallback onTap;
  final GestureLongPressDownCallback onLongPressDown;
  final GestureLongPressStartCallback onLongPressStart;
  final GestureLongPressMoveUpdateCallback onLongPressMove;
  final GestureLongPressEndCallback onLongPressEnd;
  final GestureLongPressCancelCallback onLongPressCancel;
  final VoidCallback onNext;

  String get _label {
    if (done) {
      return phase == _Phase.settings ? 'Завершить обучение' : 'Далее';
    }
    return switch (phase) {
      _Phase.swipeFeed => 'Смахни вверх',
      _Phase.media => 'Пролистай медиа',
      _Phase.favorite => 'Сохрани в избранное',
      _Phase.register => 'Записаться на событие',
      _Phase.reminder => 'Напомнить',
      _Phase.description => 'Описание',
      _Phase.share => 'Поделиться',
      _Phase.report => 'Жалоба',
      _Phase.search => 'Поиск',
      _Phase.profile => 'Профиль',
      _Phase.settings => 'Настройки',
      _Phase.intro => 'Начать',
      _Phase.finale => 'Готово',
    };
  }

  String get _semanticLabel {
    if (done) return _label;
    return switch (phase) {
      _Phase.swipeFeed => 'Сменить событие',
      _Phase.media => 'Следующее медиа',
      _Phase.favorite => 'Рыбка: добавить в избранное',
      _Phase.register => 'Рыбка: удержание и свайп влево для записи',
      _Phase.reminder => 'Напомнить о событии',
      _Phase.description => 'Описание события',
      _Phase.share => 'Поделиться событием',
      _Phase.report => 'Пожаловаться на событие',
      _Phase.search => 'Поиск',
      _Phase.profile => 'Профиль',
      _Phase.settings => 'Настройки профиля',
      _Phase.intro => 'Начать обучение',
      _Phase.finale => 'Перейти к событиям',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bool isHold = phase == _Phase.register && !done;
    final bool isFish = (phase == _Phase.favorite || isHold) && !done;
    if (done && phase != _Phase.settings) {
      return Semantics(
        label: 'Готово. Смахни вниз, чтобы продолжить',
        excludeSemantics: true,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Готово. Смахни вниз',
                style: _T.sans(
                  14,
                  weight: FontWeight.w800,
                  color: _C.accent,
                  height: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              CustomPaint(
                size: const Size(12, 12),
                painter: _ArrowDownPainter(color: _C.accent),
              ),
            ],
          ),
        ),
      );
    }
    return Semantics(
      button: true,
      label: _semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: done ? onNext : onTap,
        onLongPressDown: isHold ? onLongPressDown : null,
        onLongPressStart: isHold ? onLongPressStart : null,
        onLongPressMoveUpdate: isHold ? onLongPressMove : null,
        onLongPressEnd: isHold ? onLongPressEnd : null,
        onLongPressCancel: isHold ? onLongPressCancel : null,
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[hold, dragX]),
          builder: (BuildContext context, Widget? child) {
            final double drag = _saturate(-dragX.value / math.max(1, travel));
            final double holdValue = _saturate(hold.value);
            return Container(
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
              decoration: BoxDecoration(
                color: _C.accent,
                borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: _C.accent.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  if (isFish)
                    SizedBox(
                      width: 26,
                      height: 26,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          CustomPaint(
                            size: const Size(24, 20),
                            painter: _FishGlyphPainter(
                              color: _C.surface,
                              wave: reduceMotion
                                  ? 0
                                  : math.sin(holdValue * math.pi * 2) * 0.2,
                            ),
                          ),
                          if (holdValue > 0 && holdValue < 1)
                            CustomPaint(
                              size: const Size(28, 28),
                              painter: _RingPainter(progress: holdValue),
                            ),
                        ],
                      ),
                    ),
                  if (isFish) const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          isHold && past ? 'Отпусти' : hint,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _T.sans(
                            13,
                            weight: FontWeight.w700,
                            color: _C.surface,
                            height: 1.24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _T.mono(
                            9,
                            color: _C.surface.withValues(alpha: 0.82),
                            letterSpacing: 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CustomPaint(
                          size: const Size(30, 30),
                          painter: _KnobPainter(progress: drag, past: past),
                        ),
                        if (holdReady || drag > 0)
                          CustomPaint(
                            size: const Size(22, 22),
                            painter: _ArrowLeftPainter(
                              color: _C.accent,
                              opacity: 0.5 + drag * 0.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * 0.46,
      ),
      -math.pi / 2,
      math.pi * 2 * _saturate(progress),
      false,
      Paint()
        ..color = _C.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

class _KnobPainter extends CustomPainter {
  const _KnobPainter({required this.progress, required this.past});

  final double progress;
  final bool past;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawCircle(
      rect.center,
      size.width / 2,
      Paint()..color = _C.surface.withValues(alpha: past ? 1 : 0.22),
    );
    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2 - 2),
      -math.pi / 2,
      math.pi * 2 * _saturate(progress),
      false,
      Paint()
        ..color = _C.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _KnobPainter old) =>
      old.progress != progress || old.past != past;
}

class _ArrowLeftPainter extends CustomPainter {
  const _ArrowLeftPainter({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color.withValues(alpha: _saturate(opacity))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final Path path = Path()
      ..moveTo(size.width * 0.66, size.height * 0.26)
      ..lineTo(size.width * 0.36, size.height * 0.5)
      ..lineTo(size.width * 0.66, size.height * 0.74);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _ArrowLeftPainter old) => old.opacity != opacity;
}

class _SkeletonText extends StatelessWidget {
  const _SkeletonText({required this.reveal, required this.event});

  final bool reveal;
  final _EventSpec event;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _D.stage,
      switchInCurve: _E.soft,
      switchOutCurve: _E.soft,
      child: reveal
          ? _ContentBlock(key: const ValueKey<String>('ready'), event: event)
          : const _LoadingBlock(key: ValueKey<String>('loading')),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Semantics(
        label: 'Описание события загружается',
        excludeSemantics: true,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Bone(width: 96, height: 18, radius: 9),
            SizedBox(height: 16),
            _Bone(width: double.infinity, height: 20, radius: 6),
            SizedBox(height: 9),
            _Bone(width: 210, height: 20, radius: 6),
            SizedBox(height: 16),
            _Bone(width: 148, height: 12, radius: 6),
            SizedBox(height: 8),
            _Bone(width: double.infinity, height: 12, radius: 6),
            SizedBox(height: 8),
            _Bone(width: 236, height: 12, radius: 6),
          ],
        ),
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _C.skeleton,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}

class _MediaBadge extends StatelessWidget {
  const _MediaBadge({
    required this.count,
    required this.index,
    required this.video,
    required this.active,
  });

  final int count;
  final int index;
  final bool video;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Медиа ${index + 1} из $count',
      excludeSemantics: true,
      child: Row(
        children: <Widget>[
          if (video)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: _C.accent,
                borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
              ),
              child: Text(
                'ВИДЕО',
                style: _T.mono(8.5, color: _C.surface, letterSpacing: 0.9),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: _C.surface.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
                border: Border.all(color: _C.hairline),
              ),
              child: Text(
                'ФОТО',
                style: _T.mono(8.5, color: _C.muted, letterSpacing: 0.9),
              ),
            ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < count; i++)
                AnimatedContainer(
                  duration: _D.base,
                  curve: _E.main,
                  width: i == index ? 16 : 5,
                  height: 5,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: i == index
                        ? (active ? _C.accent : _C.ink.withValues(alpha: 0.5))
                        : _C.ink.withValues(alpha: 0.22),
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FocusDot extends StatelessWidget {
  const _FocusDot({
    required this.visible,
    required this.reduceMotion,
    required this.pulse,
  });

  final bool visible;
  final bool reduceMotion;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Semantics(
      label: 'Текущий шаг подсвечен',
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: pulse,
        builder: (BuildContext context, Widget? child) {
          return SizedBox(
            width: 12,
            height: 12,
            child: CustomPaint(
              painter: _PulseDotPainter(
                t: reduceMotion ? 0 : pulse.value,
                reduceMotion: reduceMotion,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PulseDotPainter extends CustomPainter {
  const _PulseDotPainter({required this.t, required this.reduceMotion});

  final double t;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(
      Rect.fromCenter(center: rect.center, width: 6, height: 6),
      Paint()..color = _C.accent,
    );
    if (reduceMotion) return;
    final double wave = 0.5 + 0.5 * math.sin(t * math.pi * 2);
    canvas.drawRect(
      Rect.fromCenter(center: rect.center, width: 6 + wave * 4, height: 6 + wave * 4),
      Paint()
        ..color = _C.accent.withValues(alpha: 0.5 * (1 - wave))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _PulseDotPainter old) => old.t != t;
}

class _TooShortNote extends StatelessWidget {
  const _TooShortNote();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Нужно удержание: короткий тап не записывает',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
          border: Border.all(color: _C.accentLine),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(width: 6, height: 6, color: _C.accent),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Нужно удержание, тап не считается',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _T.sans(
                  11,
                  weight: FontWeight.w700,
                  color: _C.accent,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionGlyph extends StatelessWidget {
  const _ActionGlyph({
    required this.action,
    required this.focused,
    required this.accent,
  });

  final _RailAction? action;
  final bool focused;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final _RailAction? item = action;
    if (item == null) return const SizedBox.shrink();
    return Semantics(
      label: switch (item) {
        _RailAction.bell => 'Напомнить',
        _RailAction.fish => 'Избранное',
        _RailAction.info => 'Описание',
        _RailAction.share => 'Поделиться',
        _RailAction.flag => 'Жалоба',
      },
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: _D.base,
        curve: _E.main,
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: accent ? _C.accent : _C.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: CustomPaint(
          size: const Size(16, 16),
          painter: _RailGlyphPainter(
            action: item,
            color: accent
                ? _C.surface
                : _C.muted.withValues(alpha: focused ? 0.9 : 0.5),
          ),
        ),
      ),
    );
  }
}

class _RailGlyphPainter extends CustomPainter {
  const _RailGlyphPainter({required this.action, required this.color});

  final _RailAction action;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    switch (action) {
      case _RailAction.bell:
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.46), size.width * 0.28, stroke);
        canvas.drawLine(
          Offset(size.width * 0.42, size.height * 0.76),
          Offset(size.width * 0.58, size.height * 0.76),
          stroke,
        );
      case _RailAction.fish:
        canvas.drawRect(
          Rect.fromLTWH(size.width * 0.2, size.height * 0.36, size.width * 0.5, size.height * 0.28),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width * 0.7, size.height * 0.5),
          Offset(size.width * 0.9, size.height * 0.34),
          stroke,
        );
      case _RailAction.info:
        canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.4, stroke);
        canvas.drawLine(
          Offset(size.width / 2, size.height * 0.44),
          Offset(size.width / 2, size.height * 0.7),
          stroke,
        );
      case _RailAction.share:
        canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.26), size.width * 0.12, stroke);
        canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.5), size.width * 0.12, stroke);
        canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.74), size.width * 0.12, stroke);
        canvas.drawLine(
          Offset(size.width * 0.38, size.height * 0.44),
          Offset(size.width * 0.62, size.height * 0.3),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width * 0.38, size.height * 0.56),
          Offset(size.width * 0.62, size.height * 0.7),
          stroke,
        );
      case _RailAction.flag:
        canvas.drawLine(
          Offset(size.width * 0.32, size.height * 0.18),
          Offset(size.width * 0.32, size.height * 0.84),
          stroke,
        );
        canvas.drawRect(
          Rect.fromLTWH(size.width * 0.32, size.height * 0.22, size.width * 0.4, size.height * 0.3),
          stroke,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _RailGlyphPainter old) =>
      old.color != color || old.action != action;
}

class _HandPainter extends CustomPainter {
  const _HandPainter({
    required this.kind,
    required this.t,
    required this.size,
    required this.mediaHeight,
  });

  final _DemoKind kind;
  final double t;
  final Size size;
  final double mediaHeight;

  Offset get _start {
    final double cx = size.width / 2;
    final double cy = mediaHeight * 0.52;
    return switch (kind) {
      _DemoKind.swipeUp || _DemoKind.swipeLeft || _DemoKind.holdDrag =>
        Offset(cx, cy),
      _DemoKind.tapFish => Offset(size.width * 0.34, math.max(140, size.height - 46)),
      _DemoKind.tapBell ||
      _DemoKind.tapInfo ||
      _DemoKind.tapShare ||
      _DemoKind.tapFlag ||
      _DemoKind.tapSearch ||
      _DemoKind.tapProfile =>
        Offset(size.width * 0.5, math.max(120, size.height - 46)),
      _DemoKind.none => Offset(cx, cy),
    };
  }

  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (kind == _DemoKind.none) return;
    final double phase = t % 1;
    final Offset start = _start;
    Offset end = start;
    double press = 0;
    double fade = 1;
    if (kind == _DemoKind.swipeUp) {
      final double progress = Curves.easeInOutCubic.transform(phase.clamp(0.0, 0.62) / 0.62);
      end = start - Offset(0, 96 * progress);
      fade = phase < 0.05 ? phase / 0.05 : (phase > 0.62 ? _saturate((0.82 - phase) / 0.2) : 1);
      press = 0.9;
    } else if (kind == _DemoKind.swipeLeft) {
      final double progress = Curves.easeInOutCubic.transform(phase.clamp(0.0, 0.62) / 0.62);
      end = start - Offset(118 * progress, 0);
      fade = phase < 0.05 ? phase / 0.05 : (phase > 0.62 ? _saturate((0.82 - phase) / 0.2) : 1);
      press = 0.9;
    } else if (kind == _DemoKind.holdDrag) {
      final double hold = _saturate(phase / 0.46);
      final double drag = Curves.easeInOutCubic.transform(_saturate((phase - 0.4) / 0.42));
      end = start - Offset(120 * drag, 0);
      fade = phase > 0.86 ? _saturate((1 - phase) / 0.14) : 1;
      press = 1;
      canvas.drawArc(
        Rect.fromCircle(center: start, radius: 20),
        -math.pi / 2,
        math.pi * 2 * hold,
        false,
        Paint()
          ..color = _C.accent.withValues(alpha: 0.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
    } else {
      final double cycle = phase < 0.42 ? phase / 0.42 : _saturate((0.84 - phase) / 0.42);
      press = cycle;
      fade = phase > 0.86 ? _saturate((1 - phase) / 0.14) : 1;
    }
    final Offset pos = end;
    if (fade <= 0) return;
    final Paint halo = Paint()..color = _C.accent.withValues(alpha: 0.16 * fade);
    if (kind == _DemoKind.swipeUp ||
        kind == _DemoKind.swipeLeft ||
        kind == _DemoKind.holdDrag) {
      final int steps = 4;
      for (int i = 1; i <= steps; i++) {
        final Offset p = Offset.lerp(start, end, i / (steps + 1))!;
        canvas.drawRect(
          Rect.fromCenter(center: p, width: 3, height: 3),
          Paint()..color = _C.accent.withValues(alpha: 0.3 * fade * (i / steps)),
        );
      }
    }
    canvas.drawCircle(pos, 18, halo);
    canvas.drawCircle(
      pos,
      10.5,
      Paint()..color = _C.accent.withValues(alpha: 0.95 * fade),
    );
    canvas.drawCircle(
      pos,
      10.5,
      Paint()
        ..color = _C.surface.withValues(alpha: 0.9 * fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    final double ripple = (1 - press) * 16;
    if (ripple > 1) {
      canvas.drawCircle(
        pos,
        10.5 + ripple,
        Paint()
          ..color = _C.accent.withValues(alpha: 0.35 * press * fade)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HandPainter old) =>
      old.t != t || old.kind != kind || old.size != size;
}

class _HoldTrack extends StatelessWidget {
  const _HoldTrack({
    required this.hold,
    required this.dragX,
    required this.travel,
    required this.threshold,
    required this.past,
    required this.ready,
  });

  final Animation<double> hold;
  final ValueListenable<double> dragX;
  final double travel;
  final double threshold;
  final bool past;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[hold, dragX]),
      builder: (BuildContext context, Widget? child) {
        final double holdValue = _saturate(hold.value);
        final double dx = dragX.value;
        final double width = travel * 1.16;
        return SizedBox(
          width: width,
          height: 54,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _C.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
                  border: Border.all(color: _C.hairline),
                ),
                child: Text(
                  !ready ? 'Удерживай' : (past ? 'Отпусти' : 'Веди влево'),
                  style: _T.sans(
                    10.5,
                    weight: FontWeight.w800,
                    color: _C.accent,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: CustomPaint(
                  size: Size(width, 30),
                  painter: _TrackPainter(
                    progress: holdValue,
                    drag: dx,
                    travel: travel,
                    threshold: threshold,
                    ready: ready,
                    past: past,
                    width: width,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackPainter extends CustomPainter {
  const _TrackPainter({
    required this.progress,
    required this.drag,
    required this.travel,
    required this.threshold,
    required this.ready,
    required this.past,
    required this.width,
  });

  final double progress;
  final double drag;
  final double travel;
  final double threshold;
  final bool ready;
  final bool past;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;
    final Rect track = Rect.fromLTWH(0, midY - 6, size.width, 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(track, const Radius.circular(6)),
      Paint()..color = _C.ink.withValues(alpha: 0.06),
    );
    final double scale = track.width / (travel * 1.16);
    final double thresholdX = track.right - threshold * scale;
    canvas.drawRect(
      Rect.fromLTWH(thresholdX - 1, track.top - 4, 2, 20),
      Paint()..color = _C.ink.withValues(alpha: 0.28),
    );
    final double filled = (-drag).clamp(0.0, travel) * scale;
    if (filled > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(track.right - filled, track.top, filled, 12),
          const Radius.circular(6),
        ),
        Paint()..color = (past ? _C.accent : _C.accentLine),
      );
    }
    if (!ready) {
      canvas.drawRect(
        Rect.fromLTWH(track.left, midY - 2, track.width * progress, 4),
        Paint()..color = _C.accent.withValues(alpha: 0.5),
      );
    }
    final double knobX = track.right + drag * 0.92;
    canvas.drawCircle(
      Offset(knobX, midY),
      9,
      Paint()..color = past ? _C.accent : _C.ink,
    );
    canvas.drawCircle(
      Offset(knobX, midY),
      3.6,
      Paint()..color = _C.surface,
    );
  }

  @override
  bool shouldRepaint(covariant _TrackPainter old) =>
      old.progress != progress ||
      old.drag != drag ||
      old.ready != ready ||
      old.past != past;
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.eyebrow,
    required this.title,
    required this.child,
    required this.onClose,
    this.footer,
  });

  final String eyebrow;
  final String title;
  final Widget child;
  final VoidCallback onClose;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: const BoxDecoration(
                color: _C.hairline,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                eyebrow,
                                style: _T.mono(9.5, letterSpacing: 1.2),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                title,
                                style: _T.sans(
                                  21,
                                  weight: FontWeight.w800,
                                  height: 1.14,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _IconTap(
                          label: 'Закрыть',
                          onTap: onClose,
                          child: CustomPaint(
                            size: const Size(15, 15),
                            painter: _CrossPainter(color: _C.ink2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _C.paper,
        borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
      ),
      child: Text(
        text,
        style: _T.sans(
          11.5,
          color: _C.muted,
          height: 1.35,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  const _CrossPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.22),
      Offset(size.width * 0.78, size.height * 0.78),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.78, size.height * 0.22),
      Offset(size.width * 0.22, size.height * 0.78),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _CrossPainter old) => old.color != color;
}

class _BackPainter extends CustomPainter {
  const _BackPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.62, size.height * 0.2)
        ..lineTo(size.width * 0.32, size.height * 0.5)
        ..lineTo(size.width * 0.62, size.height * 0.8),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _BackPainter old) => old.color != color;
}

class _IconTap extends StatelessWidget {
  const _IconTap({
    required this.label,
    required this.onTap,
    required this.child,
    this.size = 44,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.label,
    required this.meta,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String meta;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: _D.quick,
          curve: _E.main,
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _C.accentSoft : _C.surface,
            borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            border: Border.all(
              color: selected ? _C.accent : _C.hairline,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              CustomPaint(
                size: const Size(20, 20),
                painter: _SelectPainter(selected: selected),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      label,
                      style: _T.sans(14, weight: FontWeight.w700, height: 1.2),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      style: _T.sans(11.5, color: _C.muted, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectPainter extends CustomPainter {
  const _SelectPainter({required this.selected});

  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    if (!selected) {
      canvas.drawCircle(
        rect.center,
        size.width / 2 - 1,
        Paint()
          ..color = _C.hairline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
      return;
    }
    canvas.drawCircle(rect.center, size.width / 2, Paint()..color = _C.accent);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.26, size.height * 0.52)
        ..lineTo(size.width * 0.44, size.height * 0.68)
        ..lineTo(size.width * 0.75, size.height * 0.32),
      Paint()
        ..color = _C.surface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SelectPainter old) => old.selected != selected;
}

class _ReminderSheet extends StatelessWidget {
  const _ReminderSheet({
    required this.selected,
    required this.onSelect,
    required this.onClose,
  });

  final _ReminderChoice? selected;
  final ValueChanged<_ReminderChoice> onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      eyebrow: 'НАПОМИНАНИЕ',
      title: 'Когда напомнить?',
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _SheetOption(
            label: 'За час',
            meta: 'Короткий сигнал перед началом',
            selected: selected == _ReminderChoice.hour,
            onTap: () => onSelect(_ReminderChoice.hour),
          ),
          const SizedBox(height: 8),
          _SheetOption(
            label: 'За день',
            meta: 'Чтобы успеть собраться',
            selected: selected == _ReminderChoice.day,
            onTap: () => onSelect(_ReminderChoice.day),
          ),
          const SizedBox(height: 14),
          const _DemoNotice(text: 'Учебный режим: уведомление не создаётся.'),
        ],
      ),
    );
  }
}

class _DescriptionSheet extends StatelessWidget {
  const _DescriptionSheet({
    required this.event,
    required this.done,
    required this.onConfirm,
    required this.onClose,
  });

  final _EventSpec event;
  final bool done;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      eyebrow: 'ОПИСАНИЕ',
      title: event.title,
      onClose: onClose,
      footer: _PrimaryButton(label: 'Понятно', onTap: onConfirm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _DescriptionRow(label: 'О событии', value: event.blurb),
          _DescriptionRow(label: 'Место', value: '${event.place}, кампус'),
          _DescriptionRow(
            label: 'Организатор',
            value: '${event.organizer}, студенческое объединение',
          ),
          _DescriptionRow(
            label: 'Условия участия',
            value: 'Вход по учебной записи, участие бесплатное',
          ),
          const SizedBox(height: 6),
          _DemoNotice(
            text: done
                ? 'Описание прочитано. Это учебный экран.'
                : 'Учебная информация: реальная запись не создаётся.',
          ),
        ],
      ),
    );
  }
}

class _DescriptionRow extends StatelessWidget {
  const _DescriptionRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: _T.mono(9.5, letterSpacing: 1.1)),
          const SizedBox(height: 3),
          Text(value, style: _T.sans(13.5, color: _C.ink2, height: 1.38)),
        ],
      ),
    );
  }
}

class _ShareSheet extends StatelessWidget {
  const _ShareSheet({
    required this.copied,
    required this.onCopy,
    required this.onClose,
  });

  final bool copied;
  final VoidCallback onCopy;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      eyebrow: 'ПОДЕЛИТЬСЯ',
      title: 'Пригласи друзей',
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: _C.paper,
              borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'campuslife.demo/event/1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _T.mono(11.5, color: _C.ink2, letterSpacing: 0.2),
                  ),
                ),
                if (copied)
                  Text(
                    'Готово',
                    style: _T.sans(
                      11.5,
                      weight: FontWeight.w800,
                      color: _C.accent,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _PrimaryButton(
            label: copied ? 'Готово' : 'Скопировать учебную ссылку',
            onTap: onCopy,
            enabled: !copied,
          ),
          const SizedBox(height: 12),
          const _DemoNotice(
            text: 'Это демонстрация: настоящая ссылка не копируется.',
          ),
        ],
      ),
    );
  }
}

class _ReportSheet extends StatelessWidget {
  const _ReportSheet({
    required this.reason,
    required this.sent,
    required this.onReason,
    required this.onSend,
    required this.onClose,
  });

  final _ReportReason? reason;
  final bool sent;
  final ValueChanged<_ReportReason> onReason;
  final VoidCallback onSend;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      eyebrow: 'ЖАЛОБА',
      title: 'Что не так с событием?',
      onClose: onClose,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _PrimaryButton(
            label: sent ? 'Жалоба отмечена' : 'Отправить учебную жалобу',
            onTap: onSend,
            enabled: reason != null && !sent,
          ),
          const SizedBox(height: 8),
          const _DemoNotice(
            text: 'Учебный режим. Жалоба никуда не отправится.',
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SheetOption(
            label: 'Неверная информация',
            meta: 'Место или организатор указаны неверно',
            selected: reason == _ReportReason.wrongInfo,
            onTap: () => onReason(_ReportReason.wrongInfo),
          ),
          const SizedBox(height: 8),
          _SheetOption(
            label: 'Неподходящий контент',
            meta: 'Материалы не для студенческой афиши',
            selected: reason == _ReportReason.inappropriate,
            onTap: () => onReason(_ReportReason.inappropriate),
          ),
          const SizedBox(height: 8),
          _SheetOption(
            label: 'Другая причина',
            meta: 'Расскажешь подробнее модератору',
            selected: reason == _ReportReason.other,
            onTap: () => onReason(_ReportReason.other),
          ),
          const SizedBox(height: 12),
          Text(
            reason == null
                ? 'Выбери причину, тогда кнопка станет активной.'
                : 'Причина выбрана, отправка доступна.',
            style: _T.sans(11.5, color: _C.muted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _ProfileOverlay extends StatelessWidget {
  const _ProfileOverlay({
    required this.selected,
    required this.onTab,
    required this.onClose,
    required this.onTicket,
    required this.onRetry,
    required this.canOpenTicket,
    required this.canRetry,
    required this.ticketOpened,
    required this.settingsVisited,
    required this.canSettingsTab,
  });

  final _ProfileTab selected;
  final ValueChanged<_ProfileTab> onTab;
  final VoidCallback onClose;
  final VoidCallback onTicket;
  final VoidCallback onRetry;
  final bool canOpenTicket;
  final bool canRetry;
  final bool ticketOpened;
  final bool settingsVisited;
  final bool canSettingsTab;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: _D.express,
      curve: _E.soft,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Material(
        color: _C.paper,
        child: Column(
          children: <Widget>[
            SafeArea(
              bottom: false,
              minimum: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: <Widget>[
                  _IconTap(
                    label: 'Закрыть профиль',
                    onTap: onClose,
                    child: CustomPaint(
                      size: const Size(18, 18),
                      painter: _BackPainter(color: _C.ink),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'УЧЕБНЫЙ ПРОФИЛЬ',
                    style: _T.mono(9.5, letterSpacing: 1.3),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
              child: Row(
                children: <Widget>[
                  _Avatar(size: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Аня Соколова',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _T.sans(
                            17,
                            weight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Участник · 2 курс · Поток CampusLife',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _T.sans(11.5, color: _C.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  for (final _ProfileTab tab in _ProfileTab.values)
                    Expanded(
                      child: _ProfileTabButton(
                        label: switch (tab) {
                          _ProfileTab.tickets => 'Билеты',
                          _ProfileTab.favorites => 'Избранное',
                          _ProfileTab.settings => 'Настройки',
                        },
                        selected: selected == tab,
                        hint: tab == _ProfileTab.settings && !canSettingsTab,
                        onTap: () => onTab(tab),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: _C.hairline),
            Expanded(
              child: switch (selected) {
                _ProfileTab.tickets => _ProfileTickets(
                    onTicket: onTicket,
                    canOpen: canOpenTicket,
                    ticketOpened: ticketOpened,
                  ),
                _ProfileTab.favorites => const _ProfileFavorites(),
                _ProfileTab.settings => _ProfileSettings(
                    canRetry: canRetry,
                    visited: settingsVisited,
                    onRetry: onRetry,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  const _ProfileTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.hint = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool hint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? _C.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (hint) ...<Widget>[
                Container(width: 5, height: 5, color: _C.accent),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _T.sans(
                    12.5,
                    weight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? _C.ink : _C.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTickets extends StatelessWidget {
  const _ProfileTickets({
    required this.onTicket,
    required this.canOpen,
    required this.ticketOpened,
  });

  final VoidCallback onTicket;
  final bool canOpen;
  final bool ticketOpened;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      children: <Widget>[
        Text(
          canOpen || ticketOpened
              ? 'Билеты на учебные события'
              : 'Здесь появятся твои билеты',
          style: _T.sans(13.5, weight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        _ProfileTicketRow(
          event: _events[0],
          enabled: canOpen || ticketOpened,
          opened: ticketOpened,
          onTap: onTicket,
        ),
        const SizedBox(height: 8),
        _ProfileTicketRow(
          event: _events[1],
          enabled: false,
          opened: false,
          onTap: onTicket,
        ),
        const SizedBox(height: 14),
        Text(
          canOpen
              ? 'Открой билет, чтобы посмотреть его вживую.'
              : 'Билет открыт, теперь доступно «Далее».',
          style: _T.sans(11.5, color: _C.muted, height: 1.35),
        ),
      ],
    );
  }
}

class _ProfileTicketRow extends StatelessWidget {
  const _ProfileTicketRow({
    required this.event,
    required this.enabled,
    required this.opened,
    required this.onTap,
  });

  final _EventSpec event;
  final bool enabled;
  final bool opened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: enabled,
      enabled: enabled,
      label: 'Билет: ${event.title}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: AnimatedOpacity(
          duration: _D.quick,
          opacity: enabled ? 1 : 0.5,
          child: Container(
            constraints: const BoxConstraints(minHeight: 58),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _C.surface,
              borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
              border: Border.all(color: _C.hairline),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _C.accentSoft,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(18, 18),
                      painter: _MiniTicketPainter(color: _C.accent),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _T.sans(13, weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.place,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _T.sans(11, color: _C.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  opened
                      ? 'ОТКРЫТ'
                      : enabled
                          ? 'ОТКРЫТЬ'
                          : 'ПОЗЖЕ',
                  style: _T.mono(
                    8.5,
                    color: enabled ? _C.accent : _C.muted,
                    letterSpacing: 0.8,
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

class _ProfileFavorites extends StatelessWidget {
  const _ProfileFavorites();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      children: <Widget>[
        Text('Избранное', style: _T.sans(13.5, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            border: Border.all(color: _C.hairline),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 22,
                height: 22,
                child: CustomPaint(
                  painter: _FishGlyphPainter(color: _C.accent, wave: 0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Открытие CampusLife',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _T.sans(13, weight: FontWeight.w700),
                ),
              ),
              Text(
                '1 СОХРАНЕНО',
                style: _T.mono(8.5, color: _C.muted, letterSpacing: 0.7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSettings extends StatelessWidget {
  const _ProfileSettings({
    required this.canRetry,
    required this.visited,
    required this.onRetry,
  });

  final bool canRetry;
  final bool visited;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      children: <Widget>[
        Semantics(
          button: true,
          label: 'Пройти обучение заново',
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canRetry ? onRetry : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 58),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: canRetry ? _C.accentSoft : _C.surface,
                borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
                border: Border.all(
                  color: canRetry ? _C.accent : _C.hairline,
                  width: canRetry ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Пройти обучение заново',
                      style: _T.sans(13.5, weight: FontWeight.w700),
                    ),
                  ),
                  if (canRetry)
                    Text(
                      visited ? 'НАЙДЕНО' : 'НАЖАТЬ',
                      style: _T.mono(8.5, color: _C.accent, letterSpacing: 0.8),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          canRetry
              ? 'В настоящем профиле эта строка снова откроет обучение.'
              : 'Строка откроется на шаге настроек.',
          style: _T.sans(11.5, color: _C.muted, height: 1.35),
        ),
        if (visited) ...<Widget>[
          const SizedBox(height: 10),
          const _DemoNotice(
            text: 'Учебный режим: строка только отмечает, что ты нашёл нужный пункт.',
          ),
        ],
        const SizedBox(height: 16),
        Text('ТЕМА', style: _T.mono(9.5, letterSpacing: 1.1)),
        const SizedBox(height: 6),
        Text(
          'Обучение всегда светлое, чтобы подсказки читались одинаково.',
          style: _T.sans(11.5, color: _C.muted, height: 1.35),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: _C.surface,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: _C.hairline)),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.62,
          height: size * 0.62,
          child: CustomPaint(painter: _AvatarPainter()),
        ),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / 7;
    final Paint ink = Paint()..color = _C.ink;
    const List<List<int>> head = <List<int>>[
      <int>[2, 0], <int>[3, 0], <int>[4, 0],
      <int>[1, 1], <int>[2, 1], <int>[3, 1], <int>[4, 1], <int>[5, 1],
      <int>[1, 2], <int>[2, 2], <int>[3, 2], <int>[4, 2], <int>[5, 2],
      <int>[1, 3], <int>[2, 3], <int>[3, 3], <int>[4, 3], <int>[5, 3],
    ];
    const List<List<int>> body = <List<int>>[
      <int>[0, 5], <int>[1, 5], <int>[2, 5], <int>[3, 5], <int>[4, 5], <int>[5, 5], <int>[6, 5],
      <int>[0, 6], <int>[1, 6], <int>[2, 6], <int>[3, 6], <int>[4, 6], <int>[5, 6], <int>[6, 6],
    ];
    for (final List<int> p in body) {
      canvas.drawRect(
        Rect.fromLTWH(p[0] * cell, p[1] * cell, cell, cell),
        Paint()..color = _C.hairline,
      );
    }
    for (final List<int> p in head) {
      canvas.drawRect(
        Rect.fromLTWH(p[0] * cell, p[1] * cell, cell, cell),
        ink,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SearchOverlay extends StatelessWidget {
  const _SearchOverlay({
    required this.controller,
    required this.focusNode,
    required this.query,
    required this.results,
    required this.selected,
    required this.canSelect,
    required this.onChanged,
    required this.onSelect,
    required this.onClose,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String query;
  final List<_SearchItem> results;
  final String? selected;
  final bool canSelect;
  final ValueChanged<String> onChanged;
  final ValueChanged<_SearchItem> onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final bool empty = query.trim().isEmpty;
    return Material(
      color: _C.paper,
      child: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            minimum: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: <Widget>[
                _IconTap(
                  label: 'Закрыть поиск',
                  onTap: onClose,
                  child: CustomPaint(
                    size: const Size(18, 18),
                    painter: _BackPainter(color: _C.ink),
                  ),
                ),
                const SizedBox(width: 4),
                Text('УЧЕБНЫЙ ПОИСК', style: _T.mono(9.5, letterSpacing: 1.3)),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Container(
              decoration: const BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: <Widget>[
                  CustomPaint(
                    size: const Size(16, 16),
                    painter: _SearchGlyphPainter(color: _C.muted),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      textInputAction: TextInputAction.search,
                      style: _T.sans(15, weight: FontWeight.w600, height: 1.2),
                      cursorColor: _C.accent,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Например, «робо»',
                        hintStyle: _T.sans(14, color: _C.muted),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  if (!empty)
                    _IconTap(
                      label: 'Очистить запрос',
                      onTap: () {
                        controller.clear();
                        onChanged('');
                        focusNode.requestFocus();
                      },
                      size: 36,
                      child: CustomPaint(
                        size: const Size(13, 13),
                        painter: _CrossPainter(color: _C.muted),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                empty
                    ? 'Данные только локальные: попробуй «робо».'
                    : results.isEmpty
                        ? 'Ничего не нашлось. Попробуй «робо» или «баскет».'
                        : 'Найдено: ${results.length}. Выбери событие.',
                style: _T.sans(11.5, color: _C.muted, height: 1.3),
              ),
            ),
          ),
          if (empty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final String sample in const <String>['робо', 'баскет', 'идеи'])
                    _ChipButton(
                      label: sample,
                      onTap: () {
                        controller.text = sample;
                        onChanged(sample);
                        focusNode.requestFocus();
                      },
                    ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int position) {
                final _SearchItem item = results[position];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SearchResultTile(
                    item: item,
                    selected: selected == item.title,
                    onTap: canSelect ? () => onSelect(item) : null,
                  ),
                );
              },
            ),
          ),
          if (selected != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _C.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
                    border: Border.all(color: _C.accent),
                  ),
                  child: Text(
                    'Найдено: $selected',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _T.sans(
                      11.5,
                      weight: FontWeight.w700,
                      color: _C.accent,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Запрос $label',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 38),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: const BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
          ),
          child: Text(
            label,
            style: _T.sans(12.5, weight: FontWeight.w700, color: _C.ink2),
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _SearchItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${item.title}, ${item.meta}',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: _D.quick,
          curve: _E.main,
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _C.accentSoft : _C.surface,
            borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            border: Border.all(
              color: selected ? _C.accent : _C.hairline,
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: _FishGlyphPainter(
                    color: selected ? _C.accent : _C.muted,
                    wave: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _T.sans(13.5, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _T.sans(11, color: _C.muted),
                    ),
                  ],
                ),
              ),
              if (selected)
                Text(
                  'ВЫБРАНО',
                  style: _T.mono(8.5, color: _C.accent, letterSpacing: 0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchGlyphPainter extends CustomPainter {
  const _SearchGlyphPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7;
    final double r = size.width * 0.32;
    final Offset center = Offset(size.width * 0.44, size.height * 0.44);
    canvas.drawCircle(center, r, stroke);
    canvas.drawLine(
      Offset(center.dx + r * 0.72, center.dy + r * 0.72),
      Offset(size.width * 0.86, size.height * 0.86),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _SearchGlyphPainter old) => old.color != color;
}

class _FishGlyphPainter extends CustomPainter {
  const _FishGlyphPainter({required this.color, required this.wave});

  final Color color;
  final double wave;

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / 10;
    const List<String> rows = <String>[
      '   ####   ',
      ' ##@@@@#  ',
      '#@@@@@@@# ',
      '#@#@@@@@##',
      '#@@@@@@@# ',
      ' ##@@@@#  ',
      '   ####   ',
    ];
    final Paint solid = Paint()..color = color;
    final double offset = wave * cell * 0.4;
    for (int y = 0; y < rows.length; y++) {
      for (int x = 0; x < rows[y].length; x++) {
        if (rows[y][x] == ' ') continue;
        canvas.drawRect(
          Rect.fromLTWH(
            x * cell,
            y * cell + offset * (y - 3) / 3,
            cell - 0.6,
            cell - 0.6,
          ),
          solid,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FishGlyphPainter old) =>
      old.color != color || old.wave != wave;
}

class _IntroArt extends StatelessWidget {
  const _IntroArt({required this.controller, required this.reduceMotion});

  final Animation<double> controller;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _IntroPainter(
              progress: reduceMotion ? 1 : controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _IntroPainter extends CustomPainter {
  const _IntroPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double t = Curves.easeOutCubic.transform(_saturate(progress));
    final Offset center = Offset(size.width * 0.5, size.height * 0.52);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.66, size.width, size.height * 0.34),
      Paint()..color = _C.accentSoft,
    );
    for (int i = 0; i < 12; i++) {
      final double angle = i * 0.86;
      final double radius = 34 + (i % 4) * 16;
      final Offset p = center + Offset(math.cos(angle), math.sin(angle) * 0.55) * radius;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(p.dx, p.dy + (1 - t) * 10),
          width: i.isEven ? 4 : 3,
          height: i.isEven ? 4 : 3,
        ),
        Paint()..color = _C.accent.withValues(alpha: 0.22 + 0.4 * t),
      );
    }
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(0.88 + t * 0.12);
    const double cell = 13;
    const List<String> rows = <String>[
      '    #####      ',
      '  ##@@@@@##    ',
      ' #@@@@@@@@@#   ',
      '##@@#@@@@@@@###',
      ' #@@@@@@@@@#   ',
      '  ##@@@@@##    ',
      '    #####      ',
    ];
    final Paint ink = Paint()..color = _C.ink;
    final Paint accent = Paint()..color = _C.accent;
    for (int y = 0; y < rows.length; y++) {
      for (int x = 0; x < rows[y].length; x++) {
        final String ch = rows[y][x];
        if (ch == ' ') continue;
        canvas.drawRect(
          Rect.fromLTWH(
            x * cell - cell * 7,
            y * cell - cell * 3.5,
            cell - 1.4,
            cell - 1.4,
          ),
          ch == '#' ? accent : ink,
        );
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(-cell * 4.6, -cell * 1.6, cell * 0.9, cell * 0.9),
      Paint()..color = _C.surface,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _IntroPainter old) => old.progress != progress;
}

class _FinaleArt extends StatelessWidget {
  const _FinaleArt({required this.controller, required this.reduceMotion});

  final Animation<double> controller;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _FinalePainter(
              progress: reduceMotion ? 1 : controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _FinalePainter extends CustomPainter {
  const _FinalePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double t = _saturate(progress);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      Paint()..color = _C.accentSoft,
    );
    final Offset center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 10; i++) {
      final double angle = i * (math.pi * 2 / 10);
      final double radius = 52 + 10 * math.sin(t * math.pi * 2 + i);
      final Offset p = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawRect(
        Rect.fromCenter(
          center: p,
          width: i.isEven ? 4 : 3,
          height: i.isEven ? 4 : 3,
        ),
        Paint()..color = _C.accent.withValues(alpha: 0.18 + 0.3 * t),
      );
    }
    canvas.drawCircle(center, 34, Paint()..color = _C.ink);
    canvas.save();
    canvas.translate(center.dx - 10, center.dy - 8);
    canvas.scale(0.62);
    const List<String> rows = <String>[
      '   ####   ',
      ' ##@@@@#  ',
      '#@@@@@@@# ',
      '#@#@@@@@##',
      '#@@@@@@@# ',
      ' ##@@@@#  ',
      '   ####   ',
    ];
    const double cell = 10;
    final Paint solid = Paint()..color = _C.surface;
    for (int y = 0; y < rows.length; y++) {
      for (int x = 0; x < rows[y].length; x++) {
        if (rows[y][x] == ' ') continue;
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell - 0.6, cell - 0.6),
          solid,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FinalePainter old) => old.progress != progress;
}

class _MetaRow extends StatelessWidget {
  const _MetaRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const <Widget>[
        _MetaPill(text: '11 шагов'),
        _MetaPill(text: 'Около 2 минут'),
        _MetaPill(text: 'Без реальной записи'),
        _MetaPill(text: 'Можно пропустить'),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
      ),
      child: Text(
        text,
        style: _T.sans(11.5, color: _C.ink2, weight: FontWeight.w600, height: 1.1),
      ),
    );
  }
}

class _FinaleSummary extends StatelessWidget {
  const _FinaleSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.all(Radius.circular(_R.card)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SummaryRow(text: 'Лента событий — свайпом вверх'),
          _SummaryRow(text: 'Медиа события — свайпом влево'),
          _SummaryRow(text: 'Избранное — коротким тапом по рыбке'),
          _SummaryRow(text: 'Запись — удержанием и свайпом влево'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: <Widget>[
          Container(width: 6, height: 6, color: _C.accent),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: _T.sans(
                12.5,
                color: _C.ink2,
                height: 1.3,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTicketPainter extends CustomPainter {
  const _MiniTicketPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect body = Rect.fromLTWH(
      0,
      size.height * 0.14,
      size.width,
      size.height * 0.72,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(3)),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );
    canvas.drawLine(
      Offset(size.width * 0.62, body.top),
      Offset(size.width * 0.62, body.bottom),
      Paint()
        ..color = color
        ..strokeWidth = 1,
    );
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.14 + i * size.width * 0.13,
          size.height * 0.42,
          size.width * 0.08,
          size.height * 0.08,
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniTicketPainter old) => old.color != color;
}

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({super.key, required this.event});

  final _EventSpec event;

  @override
  Widget build(BuildContext context) {
    final double textScale = MediaQuery.textScalerOf(context).scale(1);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: _D.stage,
      curve: _E.soft,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                color: _C.accentSoft,
                borderRadius: BorderRadius.all(Radius.circular(_R.pill)),
              ),
              child: Text(
                event.category,
                style: _T.mono(9, color: _C.accent, letterSpacing: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _T.sans(
                textScale > 1.2 ? 21 : 24,
                weight: FontWeight.w800,
                height: 1.14,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${event.organizer} · ${event.place}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _T.sans(12.5, color: _C.muted, weight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              event.blurb,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: _T.sans(13.5, color: _C.ink2, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketSheet extends StatelessWidget {
  const _TicketSheet({required this.event, required this.onClose});

  final _EventSpec event;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      eyebrow: 'УЧЕБНЫЙ БИЛЕТ',
      title: 'Твой билет',
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _TicketCard(event: event),
          const SizedBox(height: 12),
          const _DemoNotice(
            text: 'Учебный билет — не для входа. Квадратный узор не является QR-кодом.',
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.event});

  final _EventSpec event;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.all(Radius.circular(22)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x0F0D1117), blurRadius: 18, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'CAMPUSLIFE · УЧЕБНЫЙ БИЛЕТ',
                      style: _T.mono(9, color: _C.accent, letterSpacing: 1.1),
                    ),
                    const Spacer(),
                    Text(
                      '01',
                      style: _T.mono(9, color: _C.muted, letterSpacing: 0.8),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.title,
                  style: _T.sans(18, weight: FontWeight.w800, height: 1.16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.place} · ${event.organizer}',
                  style: _T.sans(11.5, color: _C.muted, weight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const _Perforation(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _TicketField(label: 'УЧАСТНИК', value: 'Аня Соколова'),
                      SizedBox(height: 10),
                      _TicketField(label: 'ФОРМАТ', value: 'Учебный режим'),
                      SizedBox(height: 10),
                      _TicketField(label: 'ВХОД', value: 'Не требуется'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: <Widget>[
                    Container(
                      width: 62,
                      height: 62,
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: _C.paper,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CustomPaint(painter: _PixelQrPainter()),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'НЕ QR',
                      style: _T.mono(7.5, color: _C.muted, letterSpacing: 0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: _C.paper,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Center(
              child: Text(
                'Учебный билет — не для входа',
                style: _T.sans(11, color: _C.ink2, weight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketField extends StatelessWidget {
  const _TicketField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: _T.mono(8.5, color: _C.muted, letterSpacing: 0.9)),
        const SizedBox(height: 2),
        Text(value, style: _T.sans(12, weight: FontWeight.w700, height: 1.2)),
      ],
    );
  }
}

class _Perforation extends StatelessWidget {
  const _Perforation();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final int count = math.max(8, (constraints.maxWidth / 12).floor());
          return Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 9,
                child: Row(
                  children: <Widget>[
                    for (int i = 0; i < count; i++)
                      Expanded(
                        child: Container(
                          height: 1.4,
                          margin: const EdgeInsets.only(right: 4),
                          color: _C.hairline,
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                left: -9,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: _C.paper,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -9,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: _C.paper,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PixelQrPainter extends CustomPainter {
  const _PixelQrPainter();

  static const List<String> _rows = <String>[
    '111111100101101111111',
    '100000101001001000001',
    '101110100110101011101',
    '101110101010101011101',
    '101110100101101011101',
    '100000101101001000001',
    '111111101010101111111',
    '000000001101000000000',
    '110101110011101101010',
    '001011001100010010101',
    '111000110101111010110',
    '010111001010001101001',
    '101010111101110010101',
    '000000001011001100110',
    '111111101101110101010',
    '100000100110001001101',
    '101110101010111010101',
    '101110100101001101011',
    '101110101101110010101',
    '100000101010011101010',
    '111111101101100101101',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final int side = _rows.length;
    final double cell = size.width / side;
    final Paint on = Paint()..color = _C.ink;
    for (int y = 0; y < side; y++) {
      for (int x = 0; x < side; x++) {
        if (_rows[y][x] != '1') continue;
        canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), on);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArrowDownPainter extends CustomPainter {
  const _ArrowDownPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.14),
      Offset(size.width * 0.5, size.height * 0.84),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.24, size.height * 0.58)
        ..lineTo(size.width * 0.5, size.height * 0.86)
        ..lineTo(size.width * 0.76, size.height * 0.58),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _ArrowDownPainter old) => old.color != color;
}
