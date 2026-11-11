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
  static const Color glow = Color(0xFF5FD4DE);
  static const Color line = Color(0x1F0D1117);
  static const Color lineSoft = Color(0x120D1117);
  static const Color lineStrong = Color(0x3D0D1117);
  static const Color accentSoft = Color(0x140E6B76);
  static const Color accentLine = Color(0x4D0E6B76);
  static const Color glowSoft = Color(0x2E5FD4DE);
  static const Color paperDeep = Color(0xFFEDEDE6);
  static const Color lab = Color(0xFFEAF1F1);
  static const Color mist = Color(0xFFE8EEF0);
  static const Color sand = Color(0xFFF3ECDD);
}

abstract final class _R {
  static const double control = 14;
  static const double card = 24;
  static const double sheet = 30;
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
}

abstract final class _E {
  static const Cubic main = Cubic(0.2, 0.8, 0.2, 1);
}

abstract final class _T {
  static const List<String> _sans = <String>['Inter', 'Roboto', 'Segoe UI', 'Arial'];
  static const List<String> _mono = <String>[
    'Roboto Mono',
    'Menlo',
    'Courier New',
  ];

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
    double letterSpacing = 0.9,
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

abstract final class _S {
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: Color(0x140D1117), blurRadius: 30, offset: Offset(0, 14)),
    BoxShadow(color: Color(0x0A0D1117), blurRadius: 6, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> floating = <BoxShadow>[
    BoxShadow(color: Color(0x1A0D1117), blurRadius: 20, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(color: Color(0x120D1117), blurRadius: 10, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> button = <BoxShadow>[
    BoxShadow(color: Color(0x2E0E6B76), blurRadius: 18, offset: Offset(0, 8)),
  ];
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

enum _HintGlyph { none, up, left, tap }

enum _HintTail { none, left, right, top }

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

class _HintSpec {
  const _HintSpec({
    required this.text,
    this.note,
    this.glyph = _HintGlyph.none,
    this.tail = _HintTail.none,
  });

  final String text;
  final String? note;
  final _HintGlyph glyph;
  final _HintTail tail;
}

class _FeedGeometry {
  const _FeedGeometry({
    required this.size,
    required this.card,
    required this.railRect,
    required this.railCenters,
    required this.railHorizontal,
    required this.panelHeight,
    required this.trackLength,
    required this.itemHeight,
  });

  final Size size;
  final Rect card;
  final Rect railRect;
  final List<Offset> railCenters;
  final bool railHorizontal;
  final double panelHeight;
  final double trackLength;
  final double itemHeight;

  Offset get bell => railCenters[0];
  Offset get fish => railCenters[1];
  Offset get info => railCenters[2];
  Offset get share => railCenters[3];
  Offset get flag => railCenters[4];
  double get mediaBottom => card.top + card.height - panelHeight;
  double get trackRight => railHorizontal ? fish.dx : railRect.right - 2;
  double get travel => trackLength * 0.72;
  double get threshold => trackLength * 0.4;

  static _FeedGeometry of(Size size, double textScale) {
    final double w = size.width;
    final double h = size.height;
    final double side = w < 340 ? 8 : (w < 420 ? 10 : 14);
    final Rect card = Rect.fromLTRB(side, 2, w - side, h);
    final bool short = h < 470;
    final double panelBase = short ? 116 : (h < 600 ? 152 : 172);
    final double panelHeight = math.min(
      panelBase * (0.84 + 0.16 * textScale),
      card.height * (short ? 0.42 : 0.46),
    );
    final double embedded = card.height - panelHeight;
    double itemHeight = 48;
    final bool horizontal = short || embedded < 300;
    if (!horizontal) {
      final double fit = (embedded - 66 - 16) / 5;
      itemHeight = fit.clamp(40.0, 48.0);
    }
    final List<Offset> centers = <Offset>[];
    late Rect railRect;
    if (horizontal) {
      final double bottom = card.top + embedded - 8;
      final double top = bottom - itemHeight;
      final double left = card.left + 10;
      final double right = card.right - 10;
      final double step = (right - left) / 5;
      for (int i = 0; i < 5; i++) {
        centers.add(Offset(left + step * (i + 0.5), top + itemHeight / 2));
      }
      railRect = Rect.fromLTRB(left, top, right, bottom);
    } else {
      final double right = card.right - 8;
      final double left = right - 52;
      final double bottom = card.top + embedded - 14;
      const double gap = 4;
      final double total = itemHeight * 5 + gap * 4;
      final double top = math.max(card.top + 66, bottom - total);
      for (int i = 0; i < 5; i++) {
        centers.add(
          Offset((left + right) / 2, top + i * (itemHeight + gap) + itemHeight / 2),
        );
      }
      railRect = Rect.fromLTRB(left, top, right, card.top + embedded - 8);
    }
    final double trackLength = math.min(
      horizontal ? 196 : 214,
      math.max(140, w * 0.62),
    );
    return _FeedGeometry(
      size: size,
      card: card,
      railRect: railRect,
      railCenters: centers,
      railHorizontal: horizontal,
      panelHeight: panelHeight,
      trackLength: trackLength,
      itemHeight: itemHeight,
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

  final PageController _mediaPages = PageController();
  final TextEditingController _searchText = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
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
    _demo = AnimationController(vsync: this, duration: _D.demoSwipe);
    _overlay = AnimationController(vsync: this, duration: _D.base);
    _intro = AnimationController(vsync: this, duration: _D.stage);
    _burst = AnimationController(vsync: this, duration: _D.stage);
    _hold = AnimationController(vsync: this, duration: _D.hold);
    _return = AnimationController(vsync: this, duration: _D.stage)
      ..addListener(_onReturnTick);
    _hold.addStatusListener(_onHoldStatus);
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
      _demoActive = false;
      _overlay.value = 0;
      _hold.stop();
      _burst.stop();
      _return.stop();
      if (_intro.value != 1) _intro.value = 1;
    } else if (!_introStarted && _phase == _Phase.intro) {
      _introStarted = true;
      _intro.forward(from: 0);
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
    _dragX.dispose();
    _mediaPages.dispose();
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
    if (phase == _Phase.finale && !_reduceMotion) {
      _burst.forward(from: 0);
    }
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
      _Phase.swipeFeed => _DemoKind.swipeUp,
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
    if (_demoActive && mounted) {
      setState(() => _demoActive = false);
    }
    _scheduleResume();
  }

  void _scheduleResume() {
    _resume?.cancel();
    if (_reduceMotion) return;
    final _Phase phase = _phase;
    _resume = Timer(const Duration(milliseconds: 1500), () {
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
    final double trackLength = math.min(214.0, math.max(140.0, width * 0.62));
    setState(() {
      _dragHeld = true;
      _dragArmed = false;
      _holdReady = false;
      _dragPast = false;
      _dragStartX = details.globalPosition.dx;
      _tooShort = false;
      _demoActive = false;
      _travel = trackLength * 0.72;
      _threshold = trackLength * 0.4;
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

  void _onMediaChanged(int index) {
    if (_feedIndex >= _mediaIndex.length) return;
    _mediaIndex[_feedIndex] = index;
    if (_phase == _Phase.media && index >= 1) {
      if (!_mediaDone) _complete(_Phase.media);
    } else {
      setState(() {});
    }
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
    if (!_reduceMotion) _burst.forward(from: 0);
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
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(10, 6, 10, 8),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Column(
                      children: <Widget>[
                        _Header(
                          phase: _phase,
                          step: _stepNumber,
                          total: _stepCount,
                          done: _isDone(_phase),
                          onSkip: () =>
                              _finish(ParticipantOnboardingResult.skipped),
                          onNext: _advance,
                        ),
                        const SizedBox(height: 6),
                        Expanded(child: _buildBody(width, textScale)),
                      ],
                    ),
                  ),
                  if (_overlayVisible) _buildSheetLayer(width, height, textScale),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(double width, double textScale) {
    if (_phase == _Phase.intro) {
      return _buildIntro(width, textScale);
    }
    if (_phase == _Phase.finale) {
      return _buildFinale(width, textScale);
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size area = Size(constraints.maxWidth, constraints.maxHeight);
        if (area.width >= 720) return _buildWide(area, textScale);
        final double feedWidth = math.min(area.width, 520);
        return Center(
          child: SizedBox(
            width: feedWidth,
            height: area.height,
            child: _buildFeedPage(Size(feedWidth, area.height), textScale),
          ),
        );
      },
    );
  }

  Widget _buildWide(Size area, double textScale) {
    final double panelWidth = math.min(area.width * 0.4, 360);
    final double feedWidth = math.min(area.width - panelWidth - 16, 560);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Center(
            child: SizedBox(
              width: feedWidth,
              height: area.height,
              child: _buildFeedPage(Size(feedWidth, area.height), textScale),
            ),
          ),
        ),
        SizedBox(
          width: panelWidth,
          height: area.height,
          child: _buildSidePanel(textScale),
        ),
      ],
    );
  }

  Widget _buildFeedPage(Size size, double textScale) {
    final _FeedGeometry geo = _FeedGeometry.of(size, textScale);
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: <Widget>[
        Positioned.fromRect(
          rect: geo.card,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragEnd: (DragEndDetails details) {
              final double velocity = details.primaryVelocity ?? 0;
              if (velocity < -220) {
                _showEvent(_feedIndex + 1);
              } else if (velocity > 220) {
                _showEvent(_feedIndex - 1);
              }
            },
            child: _buildCard(geo, textScale),
          ),
        ),
        Positioned.fromRect(
          rect: geo.railRect,
          child: _buildRail(geo, textScale),
        ),
        if (!_reduceMotion && _demoActive && !_overlayBlocksDemo)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _demo,
                  builder: (BuildContext context, Widget? child) {
                    return CustomPaint(
                      painter: _TouchDemoPainter(
                        kind: _demoKindFor(_phase),
                        t: _demo.value,
                        geo: geo,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        if (_phase == _Phase.settings && _settingsVisited)
          Positioned(
            left: 14,
            right: 14,
            bottom: geo.panelHeight + 12,
            child: _FinishCta(onTap: _finishFinale),
          ),
        if (_phase == _Phase.register && _dragHeld)
          Positioned.fill(
            child: IgnorePointer(
              child: _HoldTrack(
                hold: _hold,
                dragX: _dragX,
                travel: _travel,
                threshold: _threshold,
                anchor: geo.fish,
                past: _dragPast,
                ready: _holdReady,
              ),
            ),
          ),
        if (_phase != _Phase.settings)
          _buildHint(geo, textScale),
        if (_profileOpen)
          Positioned.fill(child: _buildProfileOverlay(geo, textScale)),
      ],
    );
  }

  Widget _buildCard(_FeedGeometry geo, double textScale) {
    final _EventSpec event = _events[_feedIndex];
    final int mediaIndex = _mediaIndex[_feedIndex] ?? 0;
    final bool registered = _registered;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.all(Radius.circular(_R.card)),
        boxShadow: _S.card,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_R.card)),
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildMedia(),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _CircleButton(
                        semanticLabel: 'Профиль',
                        onTap: _onProfilePressed,
                        enabled:
                            _phase == _Phase.profile || _phase == _Phase.settings,
                        highlight: _phase == _Phase.profile && !_profileOpen,
                        child: const _Avatar(size: 22),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _CircleButton(
                        semanticLabel: 'Поиск',
                        onTap: _onSearchPressed,
                        enabled: _phase == _Phase.search,
                        highlight: _phase == _Phase.search,
                        child: _GlyphIcon(
                          painter: _SearchGlyphPainter(
                            color: _phase == _Phase.search ? _C.ink : _C.muted,
                          ),
                          size: 19,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: _MediaIndicator(
                        count: event.scenes.length,
                        index: mediaIndex,
                        textScale: textScale,
                      ),
                    ),
                    if (registered)
                      const Positioned(right: 14, bottom: 48, child: _TicketPin()),
                  ],
                ),
              ),
              SizedBox(
                height: geo.panelHeight,
                child: _buildPanel(geo, textScale, event, registered),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedia() {
    final _EventSpec event = _events[_feedIndex];
    return PageView.builder(
      controller: _mediaPages,
      itemCount: event.scenes.length,
      physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
      onPageChanged: _onMediaChanged,
      itemBuilder: (BuildContext context, int index) {
        return _SceneArt(kind: event.scenes[index]);
      },
    );
  }

  Widget _buildPanel(
    _FeedGeometry geo,
    double textScale,
    _EventSpec event,
    bool registered,
  ) {
    final bool compact = geo.panelHeight < 160;
    final String? status = switch (_phase) {
      _Phase.favorite when _favorite => 'Сохранено в избранном',
      _Phase.register when registered => 'Ты записан. Билет в профиле',
      _Phase.reminder when _reminded => _reminder == _ReminderChoice.hour
          ? 'Напомним за час'
          : 'Напомним за день',
      _Phase.description when _descriptionRead => 'Описание прочитано',
      _Phase.share when _shared => 'Ссылка готова к отправке',
      _Phase.report when _reported => 'Жалоба отмечена',
      _Phase.register when _tooShort => 'Нужно удержание: тап не записывает',
      _ => null,
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(16, compact ? 10 : 12, 16, compact ? 8 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(child: _CategoryChip(text: event.category)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  registered ? 'Ты записан' : 'Учебный режим',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _T.mono(
                    compact ? 9.5 : 10,
                    color: registered ? _C.accent : _C.muted,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _T.sans(
              compact ? 18 : 21,
              weight: FontWeight.w800,
              height: 1.12,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${event.organizer} · ${event.place}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _T.sans(
              compact ? 11.5 : 12.5,
              color: _C.muted,
              weight: FontWeight.w600,
            ),
          ),
          if (!compact) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              event.blurb,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _T.sans(13, color: _C.ink2, height: 1.32),
            ),
          ],
          if (status != null && !geo.railHorizontal) ...<Widget>[
            const SizedBox(height: 7),
            _StatusLine(text: status),
          ],
        ],
      ),
    );
  }

  Widget _buildRail(_FeedGeometry geo, double textScale) {
    final Widget content = geo.railHorizontal
        ? Row(
            children: <Widget>[
              for (final _RailAction action in _RailAction.values)
                Expanded(child: _buildRailSlot(action, geo, true)),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              for (final _RailAction action in _RailAction.values)
                _buildRailSlot(action, geo, false),
            ],
          );
    return content;
  }

  Widget _buildRailSlot(_RailAction action, _FeedGeometry geo, bool horizontal) {
    final bool enabled = _railEnabled(action);
    final bool highlight = enabled && _phase != _Phase.register;
    final Widget icon = switch (action) {
      _RailAction.bell => _GlyphIcon(
          painter: _BellGlyphPainter(
            color: enabled
                ? (_reminded ? _C.accent : _C.ink)
                : _C.muted.withValues(alpha: 0.5),
            active: _reminded,
          ),
          size: 21,
        ),
      _RailAction.fish => _RailFish(
          enabled: enabled,
          active: _favorite,
          registered: _registered,
          armed: _dragArmed,
          hold: _hold,
          dragX: _dragX,
          burst: _burst,
          burstPhase: _phase,
          reduceMotion: _reduceMotion,
        ),
      _RailAction.info => _GlyphIcon(
          painter: _InfoGlyphPainter(
            color: enabled
                ? (_descriptionRead ? _C.accent : _C.ink)
                : _C.muted.withValues(alpha: 0.5),
          ),
          size: 21,
        ),
      _RailAction.share => _GlyphIcon(
          painter: _ShareGlyphPainter(
            color: enabled
                ? (_shared ? _C.accent : _C.ink)
                : _C.muted.withValues(alpha: 0.5),
          ),
          size: 21,
        ),
      _RailAction.flag => _GlyphIcon(
          painter: _FlagGlyphPainter(
            color: enabled
                ? (_reported ? _C.accent : _C.ink)
                : _C.muted.withValues(alpha: 0.5),
          ),
          size: 21,
        ),
    };
    final bool showCount = action == _RailAction.fish && !horizontal;
    return _RailButton(
      label: switch (action) {
        _RailAction.bell => 'Напомнить о событии',
        _RailAction.fish => 'Рыбка: избранное и запись на событие',
        _RailAction.info => 'Описание события',
        _RailAction.share => 'Поделиться событием',
        _RailAction.flag => 'Пожаловаться на событие',
      },
      enabled: enabled,
      height: geo.itemHeight,
      highlight: highlight && !_reduceMotion,
      demo: _demo,
      demoActive: _demoActive && highlight,
      onTap: () => _onRailTap(action),
      onLongPressDown: action == _RailAction.fish && _phase == _Phase.register
          ? _onLongPressDown
          : null,
      onLongPressStart: action == _RailAction.fish && _phase == _Phase.register
          ? _onLongPressStart
          : null,
      onLongPressMove: action == _RailAction.fish && _phase == _Phase.register
          ? _onLongPressMove
          : null,
      onLongPressEnd: action == _RailAction.fish && _phase == _Phase.register
          ? _onLongPressEnd
          : null,
      onLongPressCancel: action == _RailAction.fish && _phase == _Phase.register
          ? _onLongPressCancel
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          if (showCount)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                _favorite ? '129' : '128',
                style: _T.mono(
                  8.5,
                  color: enabled ? _C.ink2 : _C.muted,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          if (horizontal)
            Text(
              switch (action) {
                _RailAction.bell => 'Напомнить',
                _RailAction.fish => 'Рыбка',
                _RailAction.info => 'Описание',
                _RailAction.share => 'Поделиться',
                _RailAction.flag => 'Жалоба',
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _T.mono(
                8,
                color: enabled ? _C.ink2 : _C.muted,
                letterSpacing: 0.1,
              ),
            ),
        ],
      ),
    );
  }

  bool _railEnabled(_RailAction action) {
    return switch (action) {
      _RailAction.bell => _phase == _Phase.reminder,
      _RailAction.fish =>
        _phase == _Phase.favorite || _phase == _Phase.register,
      _RailAction.info => _phase == _Phase.description,
      _RailAction.share => _phase == _Phase.share,
      _RailAction.flag => _phase == _Phase.report,
    };
  }

  void _onRailTap(_RailAction action) {
    if (!_railEnabled(action)) return;
    switch (action) {
      case _RailAction.bell:
        _openSheet(_SheetKind.reminder);
      case _RailAction.fish:
        _onFishTap();
      case _RailAction.info:
        _openSheet(_SheetKind.description);
      case _RailAction.share:
        _openSheet(_SheetKind.share);
      case _RailAction.flag:
        _openSheet(_SheetKind.report);
    }
  }

  _HintSpec? _hintSpec(_Phase phase) {
    return switch (phase) {
      _Phase.swipeFeed => const _HintSpec(
        text: 'Смахни вверх — откроется следующее мероприятие',
        note: 'Короткое движение вверх по карточке',
        glyph: _HintGlyph.up,
      ),
      _Phase.media => const _HintSpec(
        text: 'Смахни влево — у события могут быть фото и видео',
        note: 'Счётчик снизу покажет, где ты',
        glyph: _HintGlyph.left,
      ),
      _Phase.favorite => const _HintSpec(
        text: 'Нажми на рыбку — сохранишь событие в избранном',
        note: 'Короткий тап по рыбке справа',
        glyph: _HintGlyph.tap,
      ),
      _Phase.register => const _HintSpec(
        text: 'Удерживай рыбку, затем проведи влево и отпусти у отметки',
        note: 'Около секунды на удержание, отпускай только после «Отпусти»',
        glyph: _HintGlyph.left,
      ),
      _Phase.reminder => const _HintSpec(
        text: 'Нажми на колокольчик — выбери, когда напомнить',
        glyph: _HintGlyph.tap,
      ),
      _Phase.description => const _HintSpec(
        text: 'Открой описание — здесь программа, место и условия участия',
        glyph: _HintGlyph.tap,
      ),
      _Phase.share => const _HintSpec(
        text: 'Нажми «Поделиться», чтобы пригласить друзей',
        glyph: _HintGlyph.tap,
      ),
      _Phase.report => const _HintSpec(
        text: 'Если с событием что-то не так — сообщи об этом',
        glyph: _HintGlyph.tap,
      ),
      _Phase.search => const _HintSpec(
        text: 'Нажми на лупу — найди интересное событие',
        note: 'В поиске подойдёт запрос «робо»',
        glyph: _HintGlyph.tap,
      ),
      _Phase.profile => const _HintSpec(
        text: 'Открой профиль — здесь твои билеты и сохранённые события',
        glyph: _HintGlyph.tap,
      ),
      _ => null,
    };
  }

  Rect _safeRect(double left, double top, double right, double bottom) {
    final double l = math.min(left, right - 120);
    final double t = math.min(top, bottom - 64);
    return Rect.fromLTRB(l, t, math.max(right, l + 120), math.max(bottom, t + 64));
  }

  _HintArea _hintArea(_FeedGeometry geo, _HintSpec spec) {
    final Rect card = geo.card;
    final double leftEdge = card.left + 12;
    final double rightEdge = card.right - 12;
    final double contentTop = card.top + 58;
    final double freeBottom = geo.railHorizontal
        ? geo.railRect.top - 8
        : card.top + card.height - geo.panelHeight - 12;
    final double railEdge = geo.railHorizontal
        ? rightEdge
        : geo.railRect.left - 14;
    final double top = card.top + (freeBottom - card.top) * 0.44;
    switch (_phase) {
      case _Phase.swipeFeed:
        return _HintArea(
          rect: _safeRect(leftEdge, contentTop, rightEdge, freeBottom),
          align: Alignment.bottomCenter,
          tail: _HintTail.bottom,
        );
      case _Phase.media:
        return _HintArea(
          rect: _safeRect(leftEdge, top, rightEdge, freeBottom),
          align: Alignment.topCenter,
          tail: _HintTail.top,
        );
      case _Phase.favorite:
      case _Phase.register:
        if (geo.railHorizontal) {
          return _HintArea(
            rect: _safeRect(leftEdge, contentTop, rightEdge, freeBottom),
            align: Alignment.bottomCenter,
            tail: _HintTail.bottom,
          );
        }
        final double anchor = _phase == _Phase.favorite
            ? geo.fish.dy - 32
            : geo.fish.dy + 44;
        return _HintArea(
          rect: _safeRect(leftEdge, anchor, railEdge, freeBottom),
          align: Alignment.topRight,
          tail: _HintTail.top,
        );
      case _Phase.reminder:
      case _Phase.description:
      case _Phase.share:
      case _Phase.report:
        if (geo.railHorizontal) {
          return _HintArea(
            rect: _safeRect(leftEdge, contentTop, rightEdge, freeBottom),
            align: Alignment.bottomCenter,
            tail: _HintTail.bottom,
          );
        }
        final Offset target = switch (_phase) {
          _Phase.reminder => geo.bell,
          _Phase.description => geo.info,
          _Phase.share => geo.share,
          _ => geo.flag,
        };
        return _HintArea(
          rect: _safeRect(
            leftEdge,
            math.max(contentTop, target.dy - 70),
            railEdge,
            math.min(freeBottom, target.dy + 70),
          ),
          align: Alignment.centerRight,
          tail: _HintTail.right,
        );
      case _Phase.search:
      case _Phase.profile:
        return _HintArea(
          rect: _safeRect(
            leftEdge,
            contentTop,
            math.max(leftEdge + 120, railEdge),
            math.min(freeBottom, contentTop + 152),
          ),
          align: Alignment.topLeft,
          tail: _HintTail.top,
        );
      case _Phase.settings:
      case _Phase.intro:
      case _Phase.finale:
        return _HintArea(
          rect: _safeRect(leftEdge, contentTop, rightEdge, freeBottom),
          align: Alignment.topCenter,
          tail: _HintTail.none,
        );
    }
  }

  Widget _buildHint(_FeedGeometry geo, double textScale) {
    final _HintSpec? spec = _hintSpec(_phase);
    if (spec == null) return const SizedBox.shrink();
    final _HintArea area = _hintArea(geo, spec);
    final bool showAlt = _phase == _Phase.swipeFeed ||
        _phase == _Phase.media ||
        _phase == _Phase.register;
    return Positioned.fromRect(
      rect: area.rect,
      child: Align(
        alignment: area.align,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: math.min(area.rect.width, 268),
            maxHeight: area.rect.height,
          ),
          child: _HintCard(
            spec: spec,
            tail: area.tail,
            textScale: textScale,
            reduceMotion: _reduceMotion,
            demoActive: _demoActive,
            demo: _demo,
            onAlt: showAlt ? _onAccessibleAlt : null,
            altLabel: switch (_phase) {
              _Phase.swipeFeed => 'Сменить событие',
              _Phase.media => 'Следующее медиа',
              _Phase.register => 'Подтвердить запись',
              _ => null,
            },
          ),
        ),
      ),
    );
  }

  void _onAccessibleAlt() {
    switch (_phase) {
      case _Phase.swipeFeed:
        _accessibleNextEvent();
      case _Phase.media:
        _accessibleNextMedia();
      case _Phase.register:
        if (_registered) {
          _advance();
        } else {
          _complete(_Phase.register);
        }
      default:
        break;
    }
  }

  void _accessibleNextEvent() {
    _showEvent(_feedIndex + 1);
  }

  void _accessibleNextMedia() {
    final int current = _mediaIndex[_feedIndex] ?? 0;
    final int count = _events[_feedIndex].scenes.length;
    if (current >= count - 1) return;
    _stopDemo();
    _mediaPages.animateToPage(
      current + 1,
      duration: _D.base,
      curve: _E.main,
    );
  }

  Widget _buildIntro(double width, double textScale) {
    final double artHeight = math.min(
      math.max(140, MediaQuery.sizeOf(context).height * 0.3),
      260,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _IntroArt(
            controller: _intro,
            height: artHeight,
            reduceMotion: _reduceMotion,
          ),
          const SizedBox(height: 20),
          Text(
            'Твой кампус — в одном движении',
            style: _T.sans(
              textScale > 1.15 ? 26 : 30,
              weight: FontWeight.w800,
              height: 1.08,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Попробуем основные действия на учебном событии. Это займёт пару минут.',
            style: _T.sans(15, color: _C.ink2, height: 1.42),
          ),
          const SizedBox(height: 18),
          const _MetaRow(),
          const SizedBox(height: 22),
          _PrimaryButton(
            label: 'Попробовать',
            onTap: () => _setPhase(_Phase.swipeFeed),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => _finish(ParticipantOnboardingResult.skipped),
              style: TextButton.styleFrom(
                minimumSize: const Size(120, 48),
                foregroundColor: _C.ink2,
              ),
              child: Text(
                'Пропустить',
                style: _T.sans(14, weight: FontWeight.w700, color: _C.ink2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinale(double width, double textScale) {
    final double artHeight = math.min(
      math.max(150, MediaQuery.sizeOf(context).height * 0.32),
      280,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _FinaleArt(controller: _burst, height: artHeight),
          const SizedBox(height: 20),
          Text(
            'Готово. Теперь ты в потоке',
            style: _T.sans(
              textScale > 1.15 ? 26 : 30,
              weight: FontWeight.w800,
              height: 1.08,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Листай события, сохраняй интересное и встречайся с друзьями.',
            style: _T.sans(15, color: _C.ink2, height: 1.42),
          ),
          const SizedBox(height: 20),
          const _FinaleSummary(),
          const SizedBox(height: 22),
          _PrimaryButton(
            label: 'Перейти к событиям',
            onPressed: () => _finish(ParticipantOnboardingResult.completed),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel(double textScale) {
    final _HintSpec? spec = _hintSpec(_phase);
    final bool done = _isDone(_phase);
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ОБУЧЕНИЕ УЧАСТНИКА',
              style: _T.mono(10, color: _C.muted, letterSpacing: 1.6),
            ),
            const SizedBox(height: 8),
            Text(
              'Учебный экран ${_stepNumber.toString().padLeft(2, '0')} из $_stepCount',
              style: _T.sans(22, weight: FontWeight.w800, height: 1.15),
            ),
            const SizedBox(height: 12),
            if (spec != null)
              _HintCard(
                spec: spec,
                tail: _HintTail.none,
                textScale: textScale,
                reduceMotion: _reduceMotion,
                demoActive: _demoActive,
                demo: _demo,
                onAlt: _phase == _Phase.swipeFeed || _phase == _Phase.media
                    ? _onAccessibleAlt
                    : null,
                altLabel: _phase == _Phase.swipeFeed
                    ? 'Сменить событие'
                    : _phase == _Phase.media
                        ? 'Следующее медиа'
                        : _phase == _Phase.register
                            ? 'Подтвердить запись'
                            : null,
              ),
            const SizedBox(height: 14),
            if (done)
              _PrimaryButton(label: 'Далее', onTap: _advance)
            else
              Text(
                'Выполни действие на карточке — «Далее» появится после него.',
                style: _T.sans(12.5, color: _C.muted, height: 1.35),
              ),
            const SizedBox(height: 18),
            _SideLegend(phase: _phase),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetLayer(double width, double height, double textScale) {
    final double maxSheet = math.max(200, height - 108);
    return Positioned(
      top: 52,
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _overlay,
        builder: (BuildContext context, Widget? child) {
          final double t = Curves.easeOutCubic.transform(
            _overlay.value.clamp(0.0, 1.0),
          );
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _searchFocus.unfocus();
                    _closeSheet();
                  },
                  child: ColoredBox(
                    color: _C.ink.withValues(alpha: 0.26 * t),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 48),
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
      constraints: BoxConstraints(maxWidth: math.min(width, 560), maxHeight: maxSheet),
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

  Widget _buildProfileOverlay(_FeedGeometry geo, double textScale) {
    if (_phase == _Phase.search) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: _SearchOverlay(
          controller: _searchText,
          focusNode: _searchFocus,
          query: _searchQuery,
          results: _results(),
          selected: _foundEvent,
          canSelect: _phase == _Phase.search,
          onChanged: _onSearchChanged,
          onSelect: _selectResult,
          onClose: _leaveSearch,
        ),
      );
    }
    final bool settingsPhase = _phase == _Phase.settings;
    return _ProfileOverlay(
      selected: _tab,
      onTab: _selectTab,
      onClose: _closeProfile,
      onTicket: _openTicket,
      onRetry: _trySettingsRow,
      canOpenTicket: _phase == _Phase.profile,
      canRetry: settingsPhase,
      ticketOpened: _ticketOpened,
      settingsVisited: _settingsVisited,
      canSettingsTab: settingsPhase,
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.label,
    required this.enabled,
    required this.height,
    required this.highlight,
    required this.demo,
    required this.demoActive,
    required this.onTap,
    required this.child,
    this.onLongPressDown,
    this.onLongPressStart,
    this.onLongPressMove,
    this.onLongPressEnd,
    this.onLongPressCancel,
  });

  final String label;
  final bool enabled;
  final double height;
  final bool highlight;
  final Animation<double> demo;
  final bool demoActive;
  final VoidCallback onTap;
  final Widget child;
  final GestureLongPressDownCallback? onLongPressDown;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressMoveUpdateCallback? onLongPressMove;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressCancelCallback? onLongPressCancel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPressDown: onLongPressDown,
        onLongPressStart: onLongPressStart,
        onLongPressMoveUpdate: onLongPressMove,
        onLongPressEnd: onLongPressEnd,
        onLongPressCancel: onLongPressCancel,
        child: SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (highlight)
                AnimatedBuilder(
                  animation: demo,
                  builder: (BuildContext context, Widget? _) {
                    final double pulse = demoActive
                        ? 0.5 + 0.5 * math.sin(demo.value * math.pi * 2)
                        : 0.5;
                    return Container(
                      width: 42 + pulse * 5,
                      height: 42 + pulse * 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _C.accent.withValues(alpha: 0.05 + pulse * 0.06),
                        border: Border.all(
                          color: _C.accentLine.withValues(
                            alpha: 0.4 + pulse * 0.25,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _RailFish extends StatelessWidget {
  const _RailFish({
    required this.enabled,
    required this.active,
    required this.registered,
    required this.armed,
    required this.hold,
    required this.dragX,
    required this.burst,
    required this.burstPhase,
    required this.reduceMotion,
  });

  final bool enabled;
  final bool active;
  final bool registered;
  final bool armed;
  final Animation<double> hold;
  final ValueListenable<double> dragX;
  final Animation<double> burst;
  final _Phase burstPhase;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[hold, dragX, burst]),
      builder: (BuildContext context, Widget? _) {
        final double dx = dragX.value;
        final bool dragging = dx < -0.5;
        final bool bursting = burstPhase == _Phase.register &&
            burst.value > 0 &&
            burst.value < 1;
        return SizedBox(
          width: 44,
          height: 30,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              if (bursting)
                Positioned(
                  left: -22 + dx,
                  top: -12,
                  child: IgnorePointer(
                    child: CustomPaint(
                      size: const Size(88, 54),
                      painter: _PixelBurstPainter(
                        progress: burst.value,
                        origin: const Offset(44 + dx, 12),
                        color: _C.accent,
                        count: 12,
                        reduced: false,
                      ),
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(dx, 0),
                child: SizedBox(
                  width: 34,
                  height: 28,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CustomPaint(
                        size: const Size(34, 28),
                        painter: _FishPainter(
                          color: !enabled
                              ? _C.muted.withValues(alpha: 0.45)
                              : active || registered
                                  ? _C.accent
                                  : _C.ink,
                          fill: active || registered,
                          glow: active || registered,
                          wiggle: reduceMotion
                              ? 0
                              : math.sin(dragX.value * 0.15) * 0.45,
                        ),
                      ),
                      if (hold.value > 0 && hold.value < 1 && !registered)
                        CustomPaint(
                          size: const Size(40, 34),
                          painter: _HoldRingPainter(
                            progress: hold.value,
                            armed: armed,
                          ),
                        ),
                    ],
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

class _HintCard extends StatelessWidget {
  const _HintCard({
    required this.spec,
    required this.tail,
    required this.textScale,
    required this.reduceMotion,
    required this.demoActive,
    required this.demo,
    this.onAlt,
    this.altLabel,
  });

  final _HintSpec spec;
  final _HintTail tail;
  final double textScale;
  final bool reduceMotion;
  final bool demoActive;
  final Animation<double> demo;
  final VoidCallback? onAlt;
  final String? altLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool tightWidth = constraints.maxWidth < 190;
        final bool tightHeight = constraints.maxHeight < 132;
        final Widget content = Container(
          padding: EdgeInsets.fromLTRB(
            tightWidth ? 10 : 13,
            tightHeight ? 8 : 11,
            tightWidth ? 10 : 13,
            tightHeight ? 8 : 11,
          ),
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            border: Border.all(color: _C.line),
            boxShadow: _S.floating,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (spec.glyph != _HintGlyph.none) ...<Widget>[
                    _HintGlyphBox(
                      glyph: spec.glyph,
                      reduceMotion: reduceMotion,
                      demo: demo,
                      demoActive: demoActive,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: SingleChildScrollView(
                      physics: tightHeight
                          ? const ClampingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            spec.text,
                            style: _T.sans(
                              tightWidth ? 12.5 : 13.5,
                              weight: FontWeight.w700,
                              height: 1.3,
                              color: _C.ink,
                            ),
                          ),
                          if (spec.note != null && !tightHeight) ...<Widget>[
                            const SizedBox(height: 4),
                            Text(
                              spec.note!,
                              style: _T.sans(
                                tightWidth ? 11 : 11.5,
                                color: _C.muted,
                                height: 1.3,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (onAlt != null && altLabel != null) ...<Widget>[
                            const SizedBox(height: 6),
                            _AltAction(label: altLabel!, onTap: onAlt!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        if (tail == _HintTail.none) return content;
        return _TailedCard(tail: tail, child: content);
      },
    );
  }
}

class _TailedCard extends StatelessWidget {
  const _TailedCard({required this.tail, required this.child});

  final _HintTail tail;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TailPainter(tail: tail),
      child: child,
    );
  }
}

class _TailPainter extends CustomPainter {
  const _TailPainter({required this.tail});

  final _HintTail tail;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..color = _C.surface;
    final Paint stroke = Paint()
      ..color = _C.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const double tailSize = 6;
    switch (tail) {
      case _HintTail.left:
        final Path path = Path()
          ..moveTo(0, size.height * 0.5 - tailSize)
          ..lineTo(-tailSize, size.height * 0.5)
          ..lineTo(0, size.height * 0.5 + tailSize)
          ..close();
        canvas.drawPath(path, fill);
      case _HintTail.right:
        final Path path = Path()
          ..moveTo(size.width, size.height * 0.5 - tailSize)
          ..lineTo(size.width + tailSize, size.height * 0.5)
          ..lineTo(size.width, size.height * 0.5 + tailSize)
          ..close();
        canvas.drawPath(path, fill);
        canvas.drawLine(
          Offset(size.width, size.height * 0.5 - tailSize + 1),
          Offset(size.width + tailSize - 1.5, size.height * 0.5),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width + tailSize - 1.5, size.height * 0.5),
          Offset(size.width, size.height * 0.5 + tailSize - 1),
          stroke,
        );
      case _HintTail.top:
        final Path path = Path()
          ..moveTo(size.width * 0.5 - tailSize, 0)
          ..lineTo(size.width * 0.5, -tailSize)
          ..lineTo(size.width * 0.5 + tailSize, 0)
          ..close();
        canvas.drawPath(path, fill);
      case _HintTail.bottom:
        final Path path = Path()
          ..moveTo(size.width * 0.5 - tailSize, size.height)
          ..lineTo(size.width * 0.5, size.height + tailSize)
          ..lineTo(size.width * 0.5 + tailSize, size.height)
          ..close();
        canvas.drawPath(path, fill);
      case _HintTail.none:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _TailPainter old) => old.tail != tail;
}

class _HintGlyphBox extends StatelessWidget {
  const _HintGlyphBox({
    required this.glyph,
    required this.reduceMotion,
    required this.demo,
    required this.demoActive,
  });

  final _HintGlyph glyph;
  final bool reduceMotion;
  final Animation<double> demo;
  final bool demoActive;

  @override
  Widget build(BuildContext context) {
    final String label = switch (glyph) {
      _HintGlyph.up => 'Стрелка вверх',
      _HintGlyph.left => 'Стрелка влево',
      _ => 'Точка касания',
    };
    return Semantics(
      label: label,
      child: SizedBox(
        width: 26,
        height: 34,
        child: AnimatedBuilder(
          animation: demo,
          builder: (BuildContext context, Widget? child) {
            final double t = demoActive && !reduceMotion ? demo.value : 0.0;
            return CustomPaint(
              painter: _HintGlyphPainter(
                glyph: glyph,
                t: t,
                reduceMotion: reduceMotion,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HintGlyphPainter extends CustomPainter {
  const _HintGlyphPainter({
    required this.glyph,
    required this.t,
    required this.reduceMotion,
  });

  final _HintGlyph glyph;
  final double t;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = _C.accent
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Offset center = Offset(size.width / 2, size.height / 2);
    switch (glyph) {
      case _HintGlyph.up:
        final double offset = reduceMotion ? 0 : math.sin(t * math.pi * 2) * 2.5;
        _arrow(canvas, center + Offset(0, 4 - offset), paint, -math.pi / 2, size);
      case _HintGlyph.left:
        final double offset = reduceMotion ? 0 : math.sin(t * math.pi * 2) * 2.0;
        _arrow(canvas, center + Offset(offset, 0), paint, math.pi, size);
      case _HintGlyph.tap:
        final double pulse = reduceMotion ? 0.0 : math.sin(t * math.pi * 2) * 1.5;
        final Offset dot = center + Offset(0, 2);
        canvas.drawCircle(
          dot,
          4.2 + pulse,
          Paint()..color = _C.accent.withValues(alpha: 0.14),
        );
        canvas.drawCircle(dot, 4.2, paint);
        canvas.drawCircle(
          dot,
          14,
          Paint()
            ..color = _C.accent.withValues(alpha: 0.45)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      case _HintGlyph.none:
        break;
    }
  }

  void _arrow(Canvas canvas, Offset at, Paint paint, double angle, Size size) {
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle);
    final double length = math.min(size.height * 0.34, 12);
    canvas.drawLine(Offset(-2, 0), Offset(-2, length), paint);
    final Path head = Path()
      ..moveTo(-6.5, length - 6)
      ..lineTo(-2, length - 1.2)
      ..lineTo(2.5, length - 6);
    canvas.drawPath(head, paint);
    canvas.drawCircle(Offset(-2, -3), 2.4, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HintGlyphPainter old) =>
      old.glyph != glyph || old.t != t || old.reduceMotion != reduceMotion;
}

class _AltAction extends StatelessWidget {
  const _AltAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 32),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: _C.accentSoft,
            borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
            border: Border.all(color: _C.accentLine),
          ),
          child: Text(
            label,
            style: _T.sans(
              11.5,
              weight: FontWeight.w700,
              color: _C.accent,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.phase,
    required this.step,
    required this.total,
    required this.done,
    required this.onSkip,
    required this.onNext,
  });

  final _Phase phase;
  final int step;
  final int total;
  final bool done;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  bool get _showNext {
    return done &&
        phase != _Phase.intro &&
        phase != _Phase.finale &&
        phase != _Phase.swipeFeed;
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress = phase != _Phase.intro && phase != _Phase.finale;
    final String label = phase == _Phase.intro
        ? 'Вступление'
        : phase == _Phase.finale
            ? 'Финал'
            : 'Шаг $step из $total';
    return SizedBox(
      height: 46,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool narrow = constraints.maxWidth < 392;
          return Row(
            children: <Widget>[
              const _PixelFishMark(size: 26),
              if (!narrow) ...<Widget>[
                const SizedBox(width: 9),
                Text(
                  'CampusLife',
                  style: _T.sans(
                    14.5,
                    weight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
              const SizedBox(width: 10),
              if (showProgress) ...<Widget>[
                if (!narrow) ...<Widget>[
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _T.mono(9.5, color: _C.muted, letterSpacing: 0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                SizedBox(
                  width: 56,
                  height: 8,
                  child: _PixelProgress(step: step, total: total, done: done),
                ),
              ],
              const Spacer(),
              if (_showNext)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Semantics(
                    button: true,
                    label: 'Далее',
                    excludeSemantics: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onNext,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 64,
                          minHeight: 38,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          color: _C.accent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(_R.pill),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Далее',
                              style: _T.sans(
                                12.5,
                                weight: FontWeight.w800,
                                color: _C.surface,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(width: 5),
                            CustomPaint(
                              size: const Size(11, 11),
                              painter: _ArrowPainter(color: _C.surface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Semantics(
                button: true,
                label: 'Пропустить обучение',
                excludeSemantics: true,
                child: TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(74, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    foregroundColor: _C.ink2,
                    tapTargetSize: MaterialTapTargetSize.padded,
                  ),
                  child: Text(
                    'Пропустить',
                    style: _T.sans(
                      12.5,
                      weight: FontWeight.w700,
                      color: _C.ink2,
                      height: 1.1,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 1; i <= total; i++)
            Container(
              width: 3.2,
              height: i == step ? 8 : 5,
              margin: const EdgeInsets.only(right: 1.8),
              decoration: BoxDecoration(
                color: i < step || (i == step && done)
                    ? _C.accent
                    : i == step
                        ? _C.ink
                        : _C.lineStrong,
                borderRadius: const BorderRadius.all(Radius.circular(1)),
              ),
            ),
        ],
      ),
    );
  }
}

abstract final class _SheetShell {
  static Widget wrap({
    required String eyebrow,
    required String title,
    required Widget child,
    required VoidCallback onClose,
    Widget? footer,
    bool showClose = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color(0x1F0D1117), blurRadius: 40, offset: Offset(0, -8)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: _C.lineStrong,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
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
                                    20,
                                    weight: FontWeight.w800,
                                    height: 1.15,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (showClose)
                            _IconTap(
                              label: 'Закрыть',
                              size: 44,
                              onTap: onClose,
                              child: CustomPaint(
                                size: const Size(16, 16),
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
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                  child: footer,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice({required this.text, this.icon = true});

  final String text;
  final bool icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _C.paper,
        borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
        border: Border.all(color: _C.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon) ...<Widget>[
            CustomPaint(
              size: const Size(14, 14),
              painter: _InfoDotPainter(),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: _T.sans(
                11.5,
                color: _C.ink2,
                height: 1.35,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = _C.muted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 1, stroke);
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.32),
      1.1,
      Paint()..color = _C.muted,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.45),
      Offset(size.width / 2, size.height * 0.72),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    return _SheetShell.wrap(
      eyebrow: 'НАПОМИНАНИЕ',
      title: 'Когда напомнить?',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const _DemoNotice(
            text: 'Учебный режим — уведомление не будет создано.',
          ),
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
    return _SheetShell.wrap(
      eyebrow: 'ОПИСАНИЕ',
      title: event.title,
      onClose: onClose,
      footer: _PrimaryButton(
        label: 'Понятно',
        onTap: onConfirm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _DescriptionRow(
            label: 'О событии',
            value: event.blurb,
          ),
          _DescriptionRow(
            label: 'Место',
            value: '${event.place}, кампус',
          ),
          _DescriptionRow(
            label: 'Организатор',
            value: '${event.organizer}, студенческое объединение',
          ),
          _DescriptionRow(
            label: 'Условия участия',
            value: 'Вход по учебной записи, участие бесплатное',
          ),
          const SizedBox(height: 10),
          _DemoNotice(
            text: done
                ? 'Описание прочитано. Это учебный экран.'
                : 'Учебная информация — реальная запись не создаётся.',
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
          Text(
            value,
            style: _T.sans(13.5, color: _C.ink2, height: 1.38),
          ),
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
    return _SheetShell.wrap(
      eyebrow: 'ПОДЕЛИТЬСЯ',
      title: 'Пригласи друзей',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: _C.paper,
              borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
              border: Border.all(color: _C.line),
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
                const SizedBox(width: 8),
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
            tone: copied ? _ButtonTone.ghost : _ButtonTone.solid,
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
    return _SheetShell.wrap(
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
            tone: sent ? _ButtonTone.ghost : _ButtonTone.solid,
          ),
          const SizedBox(height: 8),
          const _DemoNotice(
            text: 'Учебный режим. Жалоба никуда не отправится.',
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _SheetOption(
            label: 'Неверная информация',
            meta: 'Дата, место или организатор указаны неверно',
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
            meta: 'Расскажем модератору в комментарии',
            selected: reason == _ReportReason.other,
            onTap: () => onReason(_ReportReason.other),
          ),
          const SizedBox(height: 12),
          Text(
            reason == null
                ? 'Выбери причину — кнопка отправки станет активной.'
                : 'Причина выбрана. Кнопка отправки доступна.',
            style: _T.sans(11.5, color: _C.muted, height: 1.35),
          ),
        ],
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
    return _SheetShell.wrap(
      eyebrow: 'УЧЕБНЫЙ БИЛЕТ',
      title: 'Твой билет',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _TicketCard(event: event, compact: false),
          const SizedBox(height: 12),
          const _DemoNotice(
            text: 'Учебный билет — не для входа. Квадратный узор не является QR-кодом.',
          ),
        ],
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
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _C.accentSoft : _C.surface,
            borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            border: Border.all(
              color: selected ? _C.accentLine : _C.line,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              CustomPaint(
                size: const Size(20, 20),
                painter: _SelectPainter(selected: selected),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      label,
                      style: _T.sans(
                        14,
                        weight: FontWeight.w700,
                        color: _C.ink,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      style: _T.sans(
                        11.5,
                        color: _C.muted,
                        height: 1.28,
                        weight: FontWeight.w500,
                      ),
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
          ..color = _C.lineStrong
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
      return;
    }
    canvas.drawCircle(rect.center, size.width / 2, Paint()..color = _C.accent);
    final Path check = Path()
      ..moveTo(size.width * 0.26, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.68)
      ..lineTo(size.width * 0.75, size.height * 0.32);
    canvas.drawPath(
      check,
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

enum _ButtonTone { solid, ghost }

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.tone = _ButtonTone.solid,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final _ButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final bool solid = tone == _ButtonTone.solid && enabled;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: _D.quick,
        opacity: enabled ? 1 : 0.45,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onTap : null,
          child: AnimatedContainer(
            duration: _D.base,
            curve: _E.main,
            constraints: const BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: solid ? _C.accent : _C.surface,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: solid ? Colors.transparent : _C.line),
              boxShadow: solid ? _S.button : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: _T.sans(
                      14.5,
                      weight: FontWeight.w800,
                      color: solid ? _C.surface : _C.ink,
                      height: 1.2,
                    ),
                  ),
                ),
                if (solid) ...<Widget>[
                  const SizedBox(width: 8),
                  CustomPaint(
                    size: const Size(14, 14),
                    painter: _ArrowPainter(color: _C.surface),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.semanticLabel,
    required this.onTap,
    required this.enabled,
    required this.child,
    this.highlight = false,
  });

  final String semanticLabel;
  final VoidCallback onTap;
  final bool enabled;
  final Widget child;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: _D.base,
          curve: _E.main,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _C.surface.withValues(alpha: highlight ? 1 : 0.9),
            shape: BoxShape.circle,
            border: Border.all(
              color: highlight ? _C.accentLine : _C.line,
              width: highlight ? 1.4 : 1,
            ),
            boxShadow: _S.soft,
          ),
          child: Center(
            child: Opacity(opacity: enabled ? 1 : 0.55, child: child),
          ),
        ),
      ),
    );
  }
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
      curve: _E.main,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 26),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.all(Radius.circular(_R.card)),
          boxShadow: _S.card,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(_R.card)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
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
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: _C.paper,
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(color: _C.line),
                      ),
                      child: const Center(child: _PixelAvatar(size: 38)),
                    ),
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
                              16.5,
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          locked: tab == _ProfileTab.settings && !canSettingsTab,
                          hint: tab == _ProfileTab.settings && !canSettingsTab,
                          onTap: () => onTab(tab),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1, color: _C.line),
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
      ),
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  const _ProfileTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.locked = false,
    this.hint = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool locked;
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
          height: 44,
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
                CustomPaint(
                  size: const Size(5, 5),
                  painter: _DotPainter(color: _C.accent),
                ),
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
                    color: selected
                        ? _C.ink
                        : locked
                            ? _C.muted.withValues(alpha: 0.7)
                            : _C.ink2,
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

class _DotPainter extends CustomPainter {
  const _DotPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _DotPainter old) => old.color != color;
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Text(
          canOpen || ticketOpened
              ? 'Билеты на учебные события'
              : 'Здесь появятся твои билеты',
          style: _T.sans(13.5, weight: FontWeight.w700, color: _C.ink),
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
        const SizedBox(height: 12),
        Text(
          canOpen
              ? 'Открой билет, чтобы посмотреть его вживую.'
              : 'Билет уже открыт — «Далее» доступно под карточкой.',
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
          opacity: enabled ? 1 : 0.55,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _C.paper,
              borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
              border: Border.all(color: _C.line),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _C.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: _C.line),
                  ),
                  child: const Center(child: _MiniTicket(size: 22)),
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
                    9,
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Text(
          'Избранное',
          style: _T.sans(13.5, weight: FontWeight.w700, color: _C.ink),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: _C.paper,
            borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            border: Border.all(color: _C.line),
          ),
          child: Row(
            children: <Widget>[
              const PixelFishMark(size: 20, fill: true),
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
                style: _T.mono(9, color: _C.muted, letterSpacing: 0.8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Событие попадёт сюда после короткого тапа по рыбке.',
          style: _T.sans(11.5, color: _C.muted, height: 1.35),
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: <Widget>[
        Semantics(
          button: true,
          label: 'Пройти обучение заново',
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canRetry ? onRetry : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: canRetry ? _C.accentSoft : _C.paper,
                borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
                border: Border.all(
                  color: canRetry ? _C.accentLine : _C.line,
                ),
              ),
              child: Row(
                children: <Widget>[
                  CustomPaint(
                    size: const Size(18, 18),
                    painter: _LoopPainter(
                      color: canRetry ? _C.accent : _C.muted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Пройти обучение заново',
                      style: _T.sans(
                        13.5,
                        weight: FontWeight.w700,
                        color: _C.ink,
                      ),
                    ),
                  ),
                  if (canRetry)
                    Text(
                      visited ? 'НАЙДЕНО' : 'НАЖАТЬ',
                      style: _T.mono(9, color: _C.accent, letterSpacing: 0.8),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          canRetry
              ? 'В настоящем профиле эта кнопка снова откроет обучение.'
              : 'Обучение повторяется из этой строки. Она откроется на шаге настроек.',
          style: _T.sans(11.5, color: _C.muted, height: 1.35),
        ),
        if (visited) ...<Widget>[
          const SizedBox(height: 10),
          const _DemoNotice(
            text: 'Учебный режим: строка не перезапускает сценарий, она только отмечает, что ты нашёл нужный пункт.',
          ),
        ],
        const SizedBox(height: 14),
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
      color: _C.surface,
      elevation: 0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                Text(
                  'УЧЕБНЫЙ ПОИСК',
                  style: _T.mono(9.5, letterSpacing: 1.3),
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
            child: Container(
              decoration: BoxDecoration(
                color: _C.paper,
                borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
                border: Border.all(color: _C.line),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  CustomPaint(
                    size: const Size(17, 17),
                    painter: _SearchGlyphPainter(color: _C.muted),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      textInputAction: TextInputAction.search,
                      style: _T.sans(14.5, weight: FontWeight.w600, height: 1.2),
                      cursorColor: _C.accent,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Например, «робо»',
                        hintStyle: _T.sans(14, color: _C.muted),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                        size: const Size(14, 14),
                        painter: _CrossPainter(color: _C.muted),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    empty
                        ? 'Данные только локальные: попробуй запрос «робо».'
                        : results.isEmpty
                            ? 'Ничего не нашлось. Попробуй «робо» или «баскет».'
                            : 'Найдено: ${results.length}. Выбери событие.',
                    style: _T.sans(11.5, color: _C.muted, height: 1.3),
                  ),
                ),
              ],
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
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                final _SearchItem item = results[index];
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
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                children: <Widget>[
                  _StatusLine(text: 'Найдено: $selected', accent: true),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          const SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 6),
            child: SizedBox(height: 2),
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
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _C.accentSoft,
            borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
            border: Border.all(color: _C.accentLine),
          ),
          child: Text(
            label,
            style: _T.sans(12, weight: FontWeight.w700, color: _C.accent),
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
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _C.accentSoft : _C.paper,
            borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
            border: Border.all(color: selected ? _C.accentLine : _C.line),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _C.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: _C.line),
                ),
                child: const Center(child: PixelFishMark(size: 18)),
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
                  style: _T.mono(8.5, color: _C.accent, letterSpacing: 0.8),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideLegend extends StatelessWidget {
  const _SideLegend({required this.phase});

  final _Phase phase;

  static const List<String> _names = <String>[
    'Свайп',
    'Медиа',
    'Избранное',
    'Запись',
    'Напоминание',
    'Описание',
    'Поделиться',
    'Жалоба',
    'Поиск',
    'Профиль',
    'Настройки',
  ];

  int get _current {
    return switch (phase) {
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
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('СЦЕНАРИЙ', style: _T.mono(9.5, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        for (int i = 0; i < _names.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: <Widget>[
                Container(
                  width: 5,
                  height: 5,
                  color: i + 1 < _current
                      ? _C.accent
                      : i + 1 == _current
                          ? _C.ink
                          : _C.lineStrong,
                ),
                const SizedBox(width: 8),
                Text(
                  '${i + 1}'.padLeft(2, '0'),
                  style: _T.mono(
                    9,
                    color: i + 1 == _current ? _C.ink : _C.muted,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _names[i],
                  style: _T.sans(
                    11.5,
                    weight: i + 1 == _current ? FontWeight.w800 : FontWeight.w500,
                    color: i + 1 == _current
                        ? _C.ink
                        : i + 1 < _current
                            ? _C.ink2
                            : _C.muted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
        border: Border.all(color: _C.line),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _T.mono(9, color: _C.ink2, letterSpacing: 0.7),
      ),
    );
  }
}

class _MediaIndicator extends StatelessWidget {
  const _MediaIndicator({
    required this.count,
    required this.index,
    required this.textScale,
  });

  final int count;
  final int index;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Медиа ${index + 1} из $count',
      excludeSemantics: true,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: _C.surface.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
              border: Border.all(color: _C.line),
            ),
            child: Text(
              '${index + 1}/$count',
              style: _T.mono(9.5, color: _C.ink2, letterSpacing: 0.6),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < count; i++)
                AnimatedContainer(
                  duration: _D.base,
                  curve: _E.main,
                  width: i == index ? 12 : 5,
                  height: 5,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: i == index ? _C.accent : _C.ink.withValues(alpha: 0.28),
                    borderRadius: const BorderRadius.all(Radius.circular(1.5)),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: _C.surface.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
              border: Border.all(color: _C.line),
            ),
            child: Text(
              'УЧЕБНЫЕ МЕДИА',
              style: _T.mono(8, color: _C.muted, letterSpacing: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.text, this.accent = false});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: text,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: accent ? _C.accentSoft : _C.surface,
          borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
          border: Border.all(color: accent ? _C.accentLine : _C.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: accent ? _C.accent : _C.ink2,
                borderRadius: const BorderRadius.all(Radius.circular(1.5)),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _T.sans(
                  11.5,
                  weight: FontWeight.w700,
                  color: accent ? _C.accent : _C.ink2,
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

class _HintArea {
  const _HintArea({
    required this.rect,
    required this.align,
    required this.tail,
  });

  final Rect rect;
  final Alignment align;
  final _HintTail tail;
}

class _GlyphIcon extends StatelessWidget {
  const _GlyphIcon({required this.painter, required this.size});

  final CustomPainter painter;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: painter);
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
      ..strokeWidth = 1.8;
    final double r = size.width * 0.3;
    final Offset center = Offset(size.width * 0.43, size.height * 0.43);
    canvas.drawCircle(center, r, stroke);
    canvas.drawLine(
      Offset(center.dx + r * 0.75, center.dy + r * 0.75),
      Offset(size.width * 0.86, size.height * 0.86),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _SearchGlyphPainter old) => old.color != color;
}

class _BellGlyphPainter extends CustomPainter {
  const _BellGlyphPainter({required this.color, required this.active});

  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;
    final Path bell = Path()
      ..moveTo(size.width * 0.2, size.height * 0.66)
      ..lineTo(size.width * 0.28, size.height * 0.54)
      ..lineTo(size.width * 0.28, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.16,
        size.width * 0.72,
        size.height * 0.42,
      )
      ..lineTo(size.width * 0.72, size.height * 0.54)
      ..lineTo(size.width * 0.8, size.height * 0.66)
      ..close();
    canvas.drawPath(bell, paint);
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.74),
      Offset(size.width * 0.58, size.height * 0.74),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.74),
      Offset(size.width * 0.5, size.height * 0.8),
      paint,
    );
    if (active) {
      canvas.drawCircle(
        Offset(size.width * 0.78, size.height * 0.24),
        2.6,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BellGlyphPainter old) =>
      old.color != color || old.active != active;
}

class _InfoGlyphPainter extends CustomPainter {
  const _InfoGlyphPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.4,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.33),
      1.2,
      Paint()..color = color,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.46),
      Offset(size.width / 2, size.height * 0.69),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _InfoGlyphPainter old) => old.color != color;
}

class _ShareGlyphPainter extends CustomPainter {
  const _ShareGlyphPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    final Offset top = Offset(size.width * 0.68, size.height * 0.24);
    final Offset left = Offset(size.width * 0.26, size.height * 0.5);
    final Offset bottom = Offset(size.width * 0.68, size.height * 0.76);
    canvas.drawLine(top, left, stroke);
    canvas.drawLine(left, bottom, stroke);
    canvas.drawCircle(top, size.width * 0.11, stroke);
    canvas.drawCircle(left, size.width * 0.11, stroke);
    canvas.drawCircle(bottom, size.width * 0.11, stroke);
  }

  @override
  bool shouldRepaint(covariant _ShareGlyphPainter old) => old.color != color;
}

class _FlagGlyphPainter extends CustomPainter {
  const _FlagGlyphPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round;
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.16),
      Offset(size.width * 0.3, size.height * 0.84),
      stroke,
    );
    final Path flag = Path()
      ..moveTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.76, size.height * 0.2)
      ..lineTo(size.width * 0.64, size.height * 0.36)
      ..lineTo(size.width * 0.76, size.height * 0.52)
      ..lineTo(size.width * 0.3, size.height * 0.52)
      ..close();
    canvas.drawPath(flag, stroke);
  }

  @override
  bool shouldRepaint(covariant _FlagGlyphPainter old) => old.color != color;
}

class _CrossPainter extends CustomPainter {
  const _CrossPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..strokeWidth = 1.7
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
    final Path path = Path()
      ..moveTo(size.width * 0.62, size.height * 0.2)
      ..lineTo(size.width * 0.32, size.height * 0.5)
      ..lineTo(size.width * 0.62, size.height * 0.8);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _BackPainter old) => old.color != color;
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.5),
      Offset(size.width * 0.82, size.height * 0.5),
      stroke,
    );
    final Path head = Path()
      ..moveTo(size.width * 0.58, size.height * 0.24)
      ..lineTo(size.width * 0.84, size.height * 0.5)
      ..lineTo(size.width * 0.58, size.height * 0.76);
    canvas.drawPath(head, stroke);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter old) => old.color != color;
}

class _LoopPainter extends CustomPainter {
  const _LoopPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * 0.33,
      ),
      0.5,
      5.2,
      false,
      stroke,
    );
    final Path head = Path()
      ..moveTo(size.width * 0.66, size.height * 0.18)
      ..lineTo(size.width * 0.86, size.height * 0.3)
      ..lineTo(size.width * 0.64, size.height * 0.36);
    canvas.drawPath(head, stroke);
  }

  @override
  bool shouldRepaint(covariant _LoopPainter old) => old.color != color;
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: const _AvatarPainter(),
    );
  }
}

class _PixelAvatar extends StatelessWidget {
  const _PixelAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: const _PixelAvatarPainter()),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / 8;
    final Paint ink = Paint()..color = _C.ink;
    final Paint soft = Paint()..color = _C.lineStrong;
    final List<Offset> head = <Offset>[
      const Offset(2, 1),
      const Offset(3, 1),
      const Offset(4, 1),
      const Offset(2, 2),
      const Offset(3, 2),
      const Offset(4, 2),
      const Offset(5, 2),
      const Offset(2, 3),
      const Offset(3, 3),
      const Offset(4, 3),
      const Offset(5, 3),
    ];
    final List<Offset> body = <Offset>[
      const Offset(1, 5),
      const Offset(2, 5),
      const Offset(3, 5),
      const Offset(4, 5),
      const Offset(5, 5),
      const Offset(6, 5),
      const Offset(1, 6),
      const Offset(2, 6),
      const Offset(3, 6),
      const Offset(4, 6),
      const Offset(5, 6),
      const Offset(6, 6),
      const Offset(1, 7),
      const Offset(2, 7),
      const Offset(3, 7),
      const Offset(4, 7),
      const Offset(5, 7),
      const Offset(6, 7),
    ];
    for (final Offset point in body) {
      canvas.drawRect(
        Rect.fromLTWH(point.dx * cell, point.dy * cell, cell, cell),
        soft,
      );
    }
    for (final Offset point in head) {
      canvas.drawRect(
        Rect.fromLTWH(point.dx * cell, point.dy * cell, cell, cell),
        ink,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PixelAvatarPainter extends CustomPainter {
  const _PixelAvatarPainter();

  static const List<String> _rows = <String>[
    '  bbbb  ',
    ' bbbbbb ',
    'bbEbbEbb',
    ' bbbbbb ',
    ' bbbbbb ',
    '  bmmb  ',
    '  bbbb  ',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / 8;
    for (int y = 0; y < _rows.length; y++) {
      for (int x = 0; x < _rows[y].length; x++) {
        final String ch = _rows[y][x];
        if (ch == ' ') continue;
        final Color color = switch (ch) {
          'E' => _C.surface,
          'm' => _C.accentLine,
          _ => _C.accent,
        };
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell, cell),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PixelFishMark extends StatelessWidget {
  const _PixelFishMark({required this.size, this.fill = false});

  final double size;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill ? _C.accent : _C.surface,
        borderRadius: BorderRadius.all(Radius.circular(size * 0.28)),
        border: Border.all(color: fill ? Colors.transparent : _C.line),
      ),
      padding: EdgeInsets.all(size * 0.16),
      child: CustomPaint(
        painter: _FishPainter(
          color: fill ? _C.surface : _C.ink,
          fill: true,
          glow: false,
          wiggle: 0,
        ),
      ),
    );
  }
}

class _FishPainter extends CustomPainter {
  const _FishPainter({
    required this.color,
    required this.fill,
    required this.glow,
    required this.wiggle,
  });

  final Color color;
  final bool fill;
  final bool glow;
  final double wiggle;

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / 10;
    final double top = size.height / 2 - cell * 3 + wiggle * cell * 0.35;
    final List<String> rows = <String>[
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
        final String ch = rows[y][x];
        if (ch == ' ') continue;
        final Rect r = Rect.fromLTWH(
          x * cell * 0.9,
          top + y * cell * 0.9,
          cell * 0.86,
          cell * 0.86,
        );
        if (ch == '#') {
          if (fill) {
            canvas.drawRect(r, solid);
          } else {
            canvas.drawRect(
              r,
              Paint()
                ..color = color
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.4,
            );
          }
        } else {
          canvas.drawRect(r, solid);
        }
      }
    }
    final Rect eye = Rect.fromLTWH(
      cell * 2.7,
      top + cell * 1.6,
      cell * 0.9,
      cell * 0.9,
    );
    canvas.drawRect(eye, Paint()..color = fill ? _C.surface : color);
    if (glow) {
      canvas.drawRect(
        Rect.fromLTWH(0, top - cell * 0.4, size.width, cell * 0.22),
        Paint()..color = _C.glow.withValues(alpha: 0.45),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FishPainter old) =>
      old.color != color ||
      old.fill != fill ||
      old.glow != glow ||
      old.wiggle != wiggle;
}

class _HoldRingPainter extends CustomPainter {
  const _HoldRingPainter({required this.progress, required this.armed});

  final double progress;
  final bool armed;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width * 0.44,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = armed ? _C.accent : _C.glow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _HoldRingPainter old) =>
      old.progress != progress || old.armed != armed;
}

class _PixelBurstPainter extends CustomPainter {
  const _PixelBurstPainter({
    required this.progress,
    required this.origin,
    required this.color,
    required this.count,
    required this.reduced,
  });

  final double progress;
  final Offset origin;
  final Color color;
  final int count;
  final bool reduced;

  @override
  void paint(Canvas canvas, Size size) {
    if (reduced) return;
    final double t = progress.clamp(0.0, 1.0);
    if (t <= 0 || t >= 1) return;
    final double fade = 1 - t;
    for (int i = 0; i < count; i++) {
      final double angle = (math.pi * 2 / count) * i + 0.4;
      final double distance = 10 + 26 * Curves.easeOut.transform(t);
      final double side = (i.isEven ? 4.4 : 3.2) * (0.7 + fade * 0.6);
      final Offset center = origin + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawRect(
        Rect.fromCenter(center: center, width: side, height: side),
        Paint()..color = color.withValues(alpha: 0.15 + 0.7 * fade),
      );
    }
    canvas.drawCircle(
      origin,
      4 + 14 * t,
      Paint()
        ..color = color.withValues(alpha: 0.18 * fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(covariant _PixelBurstPainter old) =>
      old.progress != progress || old.origin != origin || old.count != count;
}

class _TouchDemoPainter extends CustomPainter {
  const _TouchDemoPainter({
    required this.kind,
    required this.t,
    required this.geo,
  });

  final _DemoKind kind;
  final double t;
  final _FeedGeometry geo;

  Offset get _start {
    switch (kind) {
      case _DemoKind.swipeUp:
      case _DemoKind.swipeLeft:
      case _DemoKind.holdDrag:
        return Offset(
          geo.card.center.dx,
          geo.card.top + (geo.mediaBottom - geo.card.top) * 0.5,
        );
      case _DemoKind.tapFish:
        return geo.fish;
      case _DemoKind.tapBell:
        return geo.bell;
      case _DemoKind.tapInfo:
        return geo.info;
      case _DemoKind.tapShare:
        return geo.share;
      case _DemoKind.tapFlag:
        return geo.flag;
      case _DemoKind.tapSearch:
        return Offset(geo.card.right - 32, geo.card.top + 32);
      case _DemoKind.tapProfile:
        return Offset(geo.card.left + 32, geo.card.top + 32);
      case _DemoKind.none:
        return geo.card.center;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (kind == _DemoKind.none) return;
    final double phase = t % 1;
    final Offset start = _start;
    double touch = 0;
    double press = 0;
    Offset end = start;
    if (kind == _DemoKind.swipeUp) {
      touch = (phase * 1.5).clamp(0.0, 1.0);
      press = touch > 0 ? 1 : 0;
      end = start - Offset(0, 74 * Curves.easeInOut.transform(touch));
    } else if (kind == _DemoKind.swipeLeft) {
      touch = (phase * 1.5).clamp(0.0, 1.0);
      press = touch > 0 ? 1 : 0;
      end = start - Offset(96 * Curves.easeInOut.transform(touch), 0);
    } else if (kind == _DemoKind.holdDrag) {
      final double hold = (phase / 0.55).clamp(0.0, 1.0);
      final double drag = ((phase - 0.42) / 0.58).clamp(0.0, 1.0);
      touch = 1;
      press = 1;
      end = start - Offset(geo.travel * 0.86 * Curves.easeInOut.transform(drag), 0);
      canvas.drawArc(
        Rect.fromCircle(center: start, radius: 17),
        -math.pi / 2,
        math.pi * 2 * hold,
        false,
        Paint()
          ..color = _C.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    } else {
      final double cycle = phase < 0.5 ? phase / 0.5 : (1 - phase) / 0.5;
      touch = 1;
      press = cycle;
      end = start;
    }
    final Offset pos = Offset.lerp(start, end, 1) ?? start;
    if (kind == _DemoKind.swipeUp || kind == _DemoKind.swipeLeft || kind == _DemoKind.holdDrag) {
      final Offset current = kind == _DemoKind.holdDrag ? end : end;
      canvas.drawCircle(
        current,
        7 + 15 * press,
        Paint()..color = _C.ink.withValues(alpha: 0.12 * press),
      );
      final Offset trailStart = kind == _DemoKind.holdDrag ? start : start;
      final double distance = (current - trailStart).distance;
      if (distance > 6) {
        final int steps = (distance / 12).floor().clamp(1, 8);
        for (int i = 0; i < steps; i++) {
          final Offset p = Offset.lerp(trailStart, current, i / steps + 0.06)!;
          canvas.drawRect(
            Rect.fromCenter(center: p, width: 3, height: 3),
            Paint()..color = _C.ink.withValues(alpha: 0.18),
          );
        }
      }
    }
    canvas.drawCircle(pos, 9, Paint()..color = _C.ink);
    canvas.drawCircle(
      pos,
      15,
      Paint()
        ..color = _C.ink.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    if (kind == _DemoKind.tapFish ||
        kind == _DemoKind.tapBell ||
        kind == _DemoKind.tapInfo ||
        kind == _DemoKind.tapShare ||
        kind == _DemoKind.tapFlag ||
        kind == _DemoKind.tapSearch ||
        kind == _DemoKind.tapProfile) {
      canvas.drawCircle(
        pos,
        15 + 9 * press,
        Paint()
          ..color = _C.accent.withValues(alpha: 0.4 * (1 - press))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TouchDemoPainter old) =>
      old.t != t || old.kind != kind || old.geo != geo;
}

class _SceneArt extends StatelessWidget {
  const _SceneArt({required this.kind});

  final _SceneKind kind;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: switch (kind) {
          _SceneKind.court => const _CourtScenePainter(),
          _SceneKind.lab => const _LabScenePainter(),
          _SceneKind.waves => const _WavesScenePainter(),
          _SceneKind.video => const _VideoScenePainter(),
        },
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _CourtScenePainter extends CustomPainter {
  const _CourtScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.mist);
    final Paint block = Paint()..color = _C.surface;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.12, size.height * 0.3, size.width * 0.34, size.height * 0.4),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.54, size.height * 0.2, size.width * 0.3, size.height * 0.24),
      Paint()..color = _C.surface.withValues(alpha: 0.75),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.54, size.height * 0.5, size.width * 0.3, size.height * 0.3),
      block,
    );
    final Paint accent = Paint()..color = _C.glow.withValues(alpha: 0.55);
    for (int i = 0; i < 6; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.12 + i * size.width * 0.055,
          size.height * 0.74,
          size.width * 0.03,
          size.height * 0.03,
        ),
        accent,
      );
    }
    final Paint ink = Paint()..color = _C.ink;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.42, size.width * 0.12, size.height * 0.05),
      ink,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.3, size.width * 0.14, size.height * 0.04),
      Paint()..color = _C.accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LabScenePainter extends CustomPainter {
  const _LabScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.lab);
    final Paint grid = Paint()
      ..color = _C.accent.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const double step = 26;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final Paint accent = Paint()..color = _C.accent;
    final List<Rect> blocks = <Rect>[
      Rect.fromLTWH(size.width * 0.18, size.height * 0.36, 22, 22),
      Rect.fromLTWH(size.width * 0.18 + 26, size.height * 0.36 + 26, 18, 18),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.24, 30, 12),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.24 + 16, 14, 14),
      Rect.fromLTWH(size.width * 0.5, size.height * 0.62, 16, 16),
    ];
    for (final Rect rect in blocks) {
      canvas.drawRect(rect, accent);
    }
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.66, size.height * 0.58, 26, 26),
      Paint()..color = _C.glow.withValues(alpha: 0.6),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.12, size.height * 0.78, size.width * 0.34, 6),
      Paint()..color = _C.surface,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavesScenePainter extends CustomPainter {
  const _WavesScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.sand);
    final Paint wave = Paint()
      ..color = _C.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < 5; i++) {
      final Path path = Path();
      final double baseY = size.height * (0.3 + i * 0.11);
      path.moveTo(0, baseY);
      for (double x = 0; x <= size.width; x += 8) {
        path.lineTo(x, baseY + math.sin((x / size.width) * math.pi * 2 + i) * 6);
      }
      canvas.drawPath(path, wave);
    }
    final Paint block = Paint()..color = _C.surface.withValues(alpha: 0.9);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.16, size.width * 0.3, size.height * 0.1),
      block,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.5, size.height * 0.66, size.width * 0.34, size.height * 0.12),
      block,
    );
    final Paint accent = Paint()..color = _C.accent;
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.22 + i * 14,
          size.height * 0.8,
          8,
          8,
        ),
        accent,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VideoScenePainter extends CustomPainter {
  const _VideoScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.paperDeep);
    final Paint frame = Paint()..color = _C.surface;
    final Rect screen = Rect.fromLTWH(
      size.width * 0.14,
      size.height * 0.24,
      size.width * 0.72,
      size.height * 0.36,
    );
    canvas.drawRect(screen, frame);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.14,
        size.height * 0.62,
        size.width * 0.72,
        6,
      ),
      Paint()..color = _C.line,
    );
    final Offset center = screen.center;
    canvas.drawCircle(center, 22, Paint()..color = _C.ink.withValues(alpha: 0.9));
    final Path play = Path()
      ..moveTo(center.dx - 6, center.dy - 9)
      ..lineTo(center.dx + 10, center.dy)
      ..lineTo(center.dx - 6, center.dy + 9)
      ..close();
    canvas.drawPath(play, Paint()..color = _C.surface);
    final Paint accent = Paint()..color = _C.accent;
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.16 + i * 12,
          size.height * 0.72,
          7,
          7,
        ),
        accent,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.56, size.height * 0.7, size.width * 0.28, 10),
      Paint()..color = _C.line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IntroArt extends StatelessWidget {
  const _IntroArt({
    required this.controller,
    required this.height,
    required this.reduceMotion,
  });

  final Animation<double> controller;
  final double height;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.all(Radius.circular(_R.card)),
          boxShadow: _S.card,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(_R.card)),
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: _IntroPainter(
                  progress: reduceMotion ? 1 : controller.value,
                  reduceMotion: reduceMotion,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IntroPainter extends CustomPainter {
  const _IntroPainter({required this.progress, required this.reduceMotion});

  final double progress;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.surface);
    final Paint wash = Paint()..color = _C.glowSoft;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
      wash,
    );
    final double t = reduceMotion ? 1 : Curves.easeOutCubic.transform(progress);
    final Offset center = Offset(size.width * 0.5, size.height * 0.52);
    final Paint particle = Paint()..color = _C.glow.withValues(alpha: 0.55);
    for (int i = 0; i < 14; i++) {
      final double angle = i * 0.9;
      final double radius = 30 + (i % 5) * 14;
      final Offset p = center + Offset(math.cos(angle), math.sin(angle) * 0.5) * radius;
      final double side = i.isEven ? 4 : 3;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(p.dx, p.dy + (1 - t) * 8),
          width: side,
          height: side,
        ),
        particle,
      );
    }
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(0.85 + t * 0.15);
    final double wiggle = reduceMotion ? 0 : math.sin(progress * math.pi * 2) * 0.25;
    _drawLargeFish(canvas, wiggle);
    canvas.restore();
    final Paint trail = Paint()..color = _C.accent.withValues(alpha: 0.25);
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.1 + i * 12,
          size.height * 0.82,
          8 - i,
          8 - i,
        ),
        trail,
      );
    }
  }

  void _drawLargeFish(Canvas canvas, double wiggle) {
    const List<String> rows = <String>[
      '    #####      ',
      '  ##@@@@@##    ',
      ' #@@@@@@@@@#   ',
      '##@@#@@@@@@@###',
      ' #@@@@@@@@@#   ',
      '  ##@@@@@##    ',
      '    #####      ',
    ];
    const double cell = 14;
    final double top = -cell * 3 + wiggle * 4;
    final Paint solid = Paint()..color = _C.ink;
    final Paint accent = Paint()..color = _C.accent;
    for (int y = 0; y < rows.length; y++) {
      for (int x = 0; x < rows[y].length; x++) {
        final String ch = rows[y][x];
        if (ch == ' ') continue;
        final Rect r = Rect.fromLTWH(
          x * cell - cell * 6.5,
          top + y * cell,
          cell - 1.5,
          cell - 1.5,
        );
        canvas.drawRect(r, ch == '#' ? accent : solid);
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(-cell * 4.4, top + cell * 1.6, cell * 0.9, cell * 0.9),
      Paint()..color = _C.surface,
    );
  }

  @override
  bool shouldRepaint(covariant _IntroPainter old) =>
      old.progress != progress || old.reduceMotion != reduceMotion;
}

class _FinaleArt extends StatelessWidget {
  const _FinaleArt({required this.controller, required this.height});

  final Animation<double> controller;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.all(Radius.circular(_R.card)),
          boxShadow: _S.card,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(_R.card)),
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              final double t = controller.value;
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _FinalePainter(progress: t),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 96,
                      height: 96,
                      child: _PixelFishMark(size: 96, fill: true),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FinalePainter extends CustomPainter {
  const _FinalePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _C.surface);
    final Paint ring = Paint()..color = _C.glowSoft;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      ring,
    );
    final double t = progress;
    for (int i = 0; i < 10; i++) {
      final double angle = i * (math.pi * 2 / 10);
      final double radius = 54 + 12 * math.sin(t * math.pi * 2 + i);
      final Offset p = Offset(size.width / 2, size.height / 2) +
          Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawRect(
        Rect.fromCenter(
          center: p,
          width: i.isEven ? 4 : 3,
          height: i.isEven ? 4 : 3,
        ),
        Paint()..color = _C.glow.withValues(alpha: 0.5),
      );
    }
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
        _MetaPill(text: '11 коротких шагов'),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
        border: Border.all(color: _C.line),
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: const BorderRadius.all(Radius.circular(_R.control)),
        border: Border.all(color: _C.line),
        boxShadow: _S.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: _C.accent,
              borderRadius: BorderRadius.all(Radius.circular(1.5)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: _T.sans(12.5, color: _C.ink2, height: 1.3, weight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketPin extends StatelessWidget {
  const _TicketPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
        border: Border.all(color: _C.accentLine),
        boxShadow: _S.soft,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 5,
            height: 5,
            color: _C.accent,
          ),
          const SizedBox(width: 5),
          Text(
            'БИЛЕТ',
            style: _T.mono(8.5, color: _C.accent, letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }
}

class _MiniTicket extends StatelessWidget {
  const _MiniTicket({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MiniTicketPainter()),
    );
  }
}

class _MiniTicketPainter extends CustomPainter {
  const _MiniTicketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect body = Rect.fromLTWH(0, size.height * 0.12, size.width, size.height * 0.76);
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(3)),
      Paint()
        ..color = _C.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    canvas.drawLine(
      Offset(size.width * 0.62, body.top),
      Offset(size.width * 0.62, body.bottom),
      Paint()
        ..color = _C.accent
        ..strokeWidth = 1,
    );
    final Paint dot = Paint()..color = _C.accent;
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.14 + i * size.width * 0.13,
          size.height * 0.4,
          size.width * 0.08,
          size.height * 0.08,
        ),
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.event, required this.compact});

  final _EventSpec event;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        border: Border.all(color: _C.line),
        boxShadow: _S.soft,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
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
                  style: _T.sans(
                    compact ? 16 : 18,
                    weight: FontWeight.w800,
                    height: 1.16,
                  ),
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _TicketField(label: 'УЧАСТНИК', value: 'Аня Соколова'),
                      const SizedBox(height: 10),
                      _TicketField(label: 'ФОРМАТ', value: 'Учебный режим'),
                      const SizedBox(height: 10),
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
                      decoration: BoxDecoration(
                        color: _C.paper,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: _C.line),
                      ),
                      child: CustomPaint(painter: const _PixelQrPainter()),
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
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: const BoxDecoration(
              color: _C.paper,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Center(
              child: Text(
                'Учебный билет — не для входа',
                style: _T.sans(
                  11,
                  color: _C.ink2,
                  weight: FontWeight.w700,
                  height: 1.2,
                ),
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
        Text(
          value,
          style: _T.sans(12, weight: FontWeight.w700, height: 1.2),
        ),
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
                          height: 1.6,
                          margin: const EdgeInsets.only(right: 4),
                          color: _C.lineStrong,
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
                  decoration: BoxDecoration(
                    color: _C.paper,
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.line),
                  ),
                ),
              ),
              Positioned(
                right: -9,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _C.paper,
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.line),
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
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell, cell),
          on,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HoldTrack extends StatelessWidget {
  const _HoldTrack({
    required this.hold,
    required this.dragX,
    required this.travel,
    required this.threshold,
    required this.anchor,
    required this.past,
    required this.ready,
  });

  final Animation<double> hold;
  final ValueListenable<double> dragX;
  final double travel;
  final double threshold;
  final Offset anchor;
  final bool past;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[hold, dragX]),
      builder: (BuildContext context, Widget? child) {
        final double holdValue = hold.value.clamp(0.0, 1.0);
        final double dx = dragX.value;
        final double trackRight = anchor.dx + 10;
        final double trackLeft = trackRight - travel * 1.12;
        final double top = anchor.dy - 34;
        final String label = !ready
            ? 'Удерживай'
            : past
                ? 'Отпусти'
                : 'Веди влево';
        return Stack(
          children: <Widget>[
            Positioned(
              left: trackLeft,
              top: top,
              width: trackRight - trackLeft,
              height: 68,
              child: CustomPaint(
                painter: _HoldTrackPainter(
                  progress: holdValue,
                  drag: dx,
                  travel: travel,
                  threshold: threshold,
                  ready: ready,
                  past: past,
                ),
              ),
            ),
            Positioned(
              left: math.max(6, trackLeft - 2),
              top: top + 46,
              width: math.max(96, trackRight - trackLeft),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: past ? _C.accent : _C.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(_R.pill)),
                    border: Border.all(color: past ? _C.accent : _C.line),
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _T.sans(
                      10,
                      weight: FontWeight.w800,
                      color: past ? _C.surface : _C.ink2,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HoldTrackPainter extends CustomPainter {
  const _HoldTrackPainter({
    required this.progress,
    required this.drag,
    required this.travel,
    required this.threshold,
    required this.ready,
    required this.past,
  });

  final double progress;
  final double drag;
  final double travel;
  final double threshold;
  final bool ready;
  final bool past;

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = 16;
    final Rect track = Rect.fromLTWH(0, midY - 7, size.width, 14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(track, const Radius.circular(4)),
      Paint()..color = _C.ink.withValues(alpha: 0.07),
    );
    final double thresholdX = track.width - threshold * (track.width / (travel * 1.12));
    canvas.drawRect(
      Rect.fromLTWH(thresholdX - 1, track.top - 5, 2, 24),
      Paint()..color = _C.ink.withValues(alpha: 0.35),
    );
    final double filled = (-drag).clamp(0.0, travel) * (track.width / (travel * 1.12));
    if (filled > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(track.right - filled, track.top, filled, 14),
          const Radius.circular(4),
        ),
        Paint()..color = (past ? _C.accent : _C.glow).withValues(alpha: 0.5),
      );
    }
    if (!ready) {
      canvas.drawRect(
        Rect.fromLTWH(
          track.left,
          midY - 3,
          track.width * progress,
          6,
        ),
        Paint()..color = _C.accent.withValues(alpha: 0.55),
      );
    }
    final double knobX = track.right + drag * 0.9;
    canvas.drawCircle(
      Offset(knobX, midY),
      9,
      Paint()..color = past ? _C.accent : _C.ink,
    );
    canvas.drawCircle(
      Offset(knobX, midY),
      4,
      Paint()..color = _C.surface,
    );
    final Paint dot = Paint()..color = _C.surface.withValues(alpha: 0.7);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(
        Rect.fromLTWH(knobX - 12 - i * 5, midY - 1.5, 2.5, 3),
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HoldTrackPainter old) =>
      old.progress != progress ||
      old.drag != drag ||
      old.ready != ready ||
      old.past != past ||
      old.travel != travel ||
      old.threshold != threshold;
}

class _FinishCta extends StatelessWidget {
  const _FinishCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: _S.floating,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 8),
              child: Text(
                'Настройки найдены. Остался последний шаг.',
                style: _T.sans(
                  11.5,
                  color: _C.ink2,
                  height: 1.3,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            _PrimaryButton(label: 'Завершить обучение', onTap: onTap),
          ],
        ),
      ),
    );
  }
}
