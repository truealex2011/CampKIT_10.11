import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../app/theme.dart';
import '../../domain/entities.dart';
import '../shared/video_source.dart';

Color _hsv(double hue, double saturation, double value) =>
    HSVColor.fromAHSV(1, hue * 360, saturation, value).toColor();

final Set<String> _registeredIds = {};

abstract final class FeedState {
  static bool isRegistered(String id) => _registeredIds.contains(id);

  static void toggle(String id) {
    if (!_registeredIds.add(id)) _registeredIds.remove(id);
  }

  static void set(String id, bool value) {
    if (value) {
      _registeredIds.add(id);
    } else {
      _registeredIds.remove(id);
    }
  }
}

abstract final class DateFmt {
  static const _months = [
    'янв',
    'фев',
    'мар',
    'апр',
    'мая',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];

  static String time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  static String short(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  static String full(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static String dayMonth(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

abstract final class FeedVisuals {
  static Color colorFor(EventCategory c) => switch (c) {
    EventCategory.sport => Palette.mint,
    EventCategory.art => Palette.gold,
    EventCategory.science => Palette.accent,
    EventCategory.contest => Palette.rose,
    EventCategory.lecture => Palette.ink2,
    EventCategory.music => Palette.accent,
    EventCategory.volunteer => Palette.mint,
    EventCategory.outing => Palette.gold,
  };

  static IconData iconFor(EventCategory c) => switch (c) {
    EventCategory.sport => Icons.sports_volleyball_rounded,
    EventCategory.art => Icons.brush_rounded,
    EventCategory.science => Icons.science_rounded,
    EventCategory.contest => Icons.emoji_events_rounded,
    EventCategory.lecture => Icons.mic_rounded,
    EventCategory.music => Icons.music_note_rounded,
    EventCategory.volunteer => Icons.volunteer_activism_rounded,
    EventCategory.outing => Icons.alt_route_rounded,
  };
}

enum MediaSlotState { loading, ready, failed }

class _Slot {
  _Slot(this.id, this.path);

  final String id;
  final String path;
  VideoPlayerController? controller;
  bool loading = false;
  bool failed = false;
  bool wantPlaying = true;

  bool get ready => controller != null && controller!.value.isInitialized;

  bool get playing => ready && controller!.value.isPlaying;
}

class MediaPool extends ChangeNotifier {
  final Map<String, _Slot> _slots = {};
  List<String> _order = const [];
  Map<String, String?> _paths = const {};
  int _active = 0;

  void syncWith(List<String> eventIds, Map<String, String?> videoPaths) {
    _order = eventIds;
    _paths = videoPaths;
    _apply(_active);
  }

  void setActive(int index) {
    if (index == _active) return;
    _active = index;
    _apply(index);
  }

  void _apply(int index) {
    final wanted = <String>[];
    for (var i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < _order.length) wanted.add(_order[i]);
    }
    var changed = false;
    for (final id in _slots.keys.toList()) {
      if (!wanted.contains(id)) {
        _slots.remove(id)?.controller?.dispose();
        changed = true;
      }
    }
    for (final id in wanted) {
      final path = _paths[id];
      if (path == null || path.isEmpty) {
        if (_slots.remove(id) != null) changed = true;
        continue;
      }
      final existing = _slots[id];
      if (existing == null || existing.path != path) {
        existing?.controller?.dispose();
        _slots[id] = _Slot(id, path);
        changed = true;
      }
    }
    if (changed) notifyListeners();
    for (final slot in _slots.values) {
      _ensure(slot);
    }
  }

  void _ensure(_Slot slot) {
    if (slot.loading || slot.controller != null) return;
    slot.loading = true;
    final controller = openVideoController(slot.path);
    if (controller == null) {
      slot.loading = false;
      slot.failed = true;
      notifyListeners();
      return;
    }
    slot.controller = controller;
    controller
        .initialize()
        .then((_) async {
          await controller.setVolume(0);
          await controller.setLooping(true);
          slot.loading = false;
          if (slot.wantPlaying && _slots[slot.id] == slot) {
            unawaited(controller.play());
          }
          notifyListeners();
        })
        .catchError((_) {
          slot.loading = false;
          slot.failed = true;
          controller.dispose();
          if (_slots[slot.id] == slot) slot.controller = null;
          notifyListeners();
        });
  }

  MediaSlotState stateOf(String id) {
    final slot = _slots[id];
    if (slot == null) return MediaSlotState.loading;
    if (slot.failed) return MediaSlotState.failed;
    return slot.ready ? MediaSlotState.ready : MediaSlotState.loading;
  }

  VideoPlayerController? controllerFor(String id) => _slots[id]?.controller;

  bool isPlaying(String id) => _slots[id]?.playing ?? false;

  void togglePlay(String id) {
    final slot = _slots[id];
    if (slot == null) return;
    final controller = slot.controller;
    if (controller == null || !slot.ready) {
      slot.wantPlaying = !slot.wantPlaying;
      notifyListeners();
      return;
    }
    if (controller.value.isPlaying) {
      slot.wantPlaying = false;
      controller.pause();
    } else {
      slot.wantPlaying = true;
      controller.play();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (final slot in _slots.values) {
      slot.controller?.dispose();
    }
    _slots.clear();
    super.dispose();
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    required this.event,
    required this.page,
    required this.path,
  });

  final CampusEvent event;
  final int page;
  final String path;

  @override
  Widget build(BuildContext context) => mediaImage(
    path,
    placeholder: PlaceholderTile(event: event, page: page),
  );
}

class PlaceholderTile extends StatelessWidget {
  const PlaceholderTile({
    super.key,
    required this.event,
    required this.page,
    this.video = false,
  });

  final CampusEvent event;
  final int page;
  final bool video;

  @override
  Widget build(BuildContext context) {
    final baseHue = (event.category.index * 33 + page * 14) % 360;
    final start = _hsv(baseHue / 360, 0.46, 0.30);
    final end = _hsv(((baseHue + 32) % 360) / 360, 0.58, 0.14);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start, end],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _GridPainter(baseHue / 360)),
          LayoutBuilder(
            builder: (context, constraints) {
              final glyph = video
                  ? Icons.play_circle_outline_rounded
                  : FeedVisuals.iconFor(event.category);
              final tint = Colors.white.withValues(alpha: 0.16);
              if (constraints.maxHeight < 160 || constraints.maxWidth < 160) {
                return Center(
                  child: Icon(
                    glyph,
                    size: (constraints.biggest.shortestSide * 0.5).clamp(
                      12.0,
                      58.0,
                    ),
                    color: tint,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(glyph, size: 58, color: tint),
                    const SizedBox(height: 14),
                    Text(
                      event.category.label.toUpperCase(),
                      style: Fonts.monoStyle(
                        size: 11,
                        weight: 500,
                        letterSpacing: 0.14 * 11,
                        color: Colors.white.withValues(alpha: 0.42),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.hue);

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _hsv(hue, 0.35, 0.9).withValues(alpha: 0.06)
      ..strokeWidth = 1;
    const step = 46.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.hue != hue;
}

class VideoTile extends StatelessWidget {
  const VideoTile({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) return const SizedBox.expand();
    final size = controller.value.size;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
