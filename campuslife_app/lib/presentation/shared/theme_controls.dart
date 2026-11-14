import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';

abstract final class ThemePreferences {
  static const _key = 'pixel_fish_theme';

  static Future<ThemeMode> restore() async {
    final prefs = await SharedPreferences.getInstance();
    return switch (prefs.getString(_key)) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  static Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

Future<void> revealTheme(
  BuildContext context,
  GlobalKey boundaryKey,
  ThemeMode mode,
  Offset origin,
  VoidCallback apply,
) async {
  final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  if (reduced) {
    apply();
    await ThemePreferences.save(mode);
    return;
  }
  final overlay = Overlay.of(context, rootOverlay: true);
  final boundary =
      boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final size = boundary.size;
  final localOrigin = boundary.globalToLocal(origin);
  final topLeft = boundary.localToGlobal(Offset.zero);
  final radius = [
    localOrigin.distance,
    (localOrigin - Offset(size.width, 0)).distance,
    (localOrigin - Offset(0, size.height)).distance,
    (localOrigin - Offset(size.width, size.height)).distance,
  ].reduce(math.max);
  final image = await boundary.toImage(
    pixelRatio: MediaQuery.devicePixelRatioOf(context).clamp(1, 2),
  );
  if (!context.mounted) {
    image.dispose();
    return;
  }
  final finished = Completer<void>();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => Positioned(
      left: topLeft.dx,
      top: topLeft.dy,
      width: size.width,
      height: size.height,
      child: IgnorePointer(
        child: _ThemeReveal(
          image: image,
          origin: localOrigin,
          radius: radius,
          onEnd: () {
            entry.remove();
            entry.dispose();
            finished.complete();
          },
        ),
      ),
    ),
  );
  overlay.insert(entry);
  apply();
  await Future.wait([ThemePreferences.save(mode), finished.future]);
}

class _ThemeReveal extends StatefulWidget {
  const _ThemeReveal({
    required this.image,
    required this.origin,
    required this.radius,
    required this.onEnd,
  });

  final ui.Image image;
  final Offset origin;
  final double radius;
  final VoidCallback onEnd;

  @override
  State<_ThemeReveal> createState() => _ThemeRevealState();
}

class _ThemeRevealState extends State<_ThemeReveal> {
  @override
  void dispose() {
    widget.image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: widget.radius),
    duration: AppMotion.scene,
    curve: AppMotion.ease,
    onEnd: widget.onEnd,
    child: RawImage(image: widget.image, fit: BoxFit.fill),
    builder: (context, radius, child) =>
        ClipPath(clipper: _RevealClipper(widget.origin, radius), child: child),
  );
}

class _RevealClipper extends CustomClipper<Path> {
  const _RevealClipper(this.origin, this.radius);

  final Offset origin;
  final double radius;

  @override
  Path getClip(Size size) => Path()
    ..fillType = PathFillType.evenOdd
    ..addRect(Offset.zero & size)
    ..addOval(Rect.fromCircle(center: origin, radius: radius));

  @override
  bool shouldReclip(covariant _RevealClipper oldClipper) =>
      oldClipper.radius != radius || oldClipper.origin != origin;
}
