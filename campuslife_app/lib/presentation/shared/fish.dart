import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

Path buildFishPath([double wiggle = 0]) {
  final body = Path()..addOval(const Rect.fromLTRB(2.6, 7, 17.4, 17));
  var tail = Path()
    ..moveTo(15.6, 12)
    ..lineTo(21.8, 6.6)
    ..quadraticBezierTo(20.1, 12, 21.8, 17.4)
    ..close();
  if (wiggle != 0) {
    final m = Matrix4.identity()
      ..translateByDouble(15.6, 12, 0, 1)
      ..rotateZ(wiggle)
      ..translateByDouble(-15.6, -12, 0, 1);
    tail = tail.transform(m.storage);
  }
  return Path()
    ..addPath(body, Offset.zero)
    ..addPath(tail, Offset.zero);
}

Path buildHeartPath(Offset c, double s) => Path()
  ..moveTo(c.dx, c.dy + s * 0.38)
  ..cubicTo(
    c.dx - s * 0.55,
    c.dy - s * 0.02,
    c.dx - s * 0.36,
    c.dy - s * 0.5,
    c.dx,
    c.dy - s * 0.2,
  )
  ..cubicTo(
    c.dx + s * 0.36,
    c.dy - s * 0.5,
    c.dx + s * 0.55,
    c.dy - s * 0.02,
    c.dx,
    c.dy + s * 0.38,
  );

void paintFish(
  Canvas canvas,
  Offset at,
  double scale,
  double rotation,
  Paint paint, [
  double wiggle = 0,
]) {
  canvas.save();
  canvas.translate(at.dx, at.dy);
  canvas.rotate(rotation);
  canvas.scale(scale);
  canvas.translate(-12, -12);
  canvas.drawPath(buildFishPath(wiggle), paint);
  canvas.restore();
}

class FishHeartIcon extends StatelessWidget {
  const FishHeartIcon({
    super.key,
    this.size = 24,
    this.filled = false,
    this.color = Colors.white,
    this.heartColor,
  });

  final double size;
  final bool filled;
  final Color color;
  final Color? heartColor;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _FishHeartPainter(
      filled: filled,
      color: color,
      heartColor: heartColor ?? (filled ? Palette.rose : color),
    ),
  );
}

class _FishHeartPainter extends CustomPainter {
  _FishHeartPainter({
    required this.filled,
    required this.color,
    required this.heartColor,
  });

  final bool filled;
  final Color color;
  final Color heartColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final fish = buildFishPath();
    final heart = buildHeartPath(const Offset(10, 12.4), 7.5);
    if (filled) {
      canvas.drawPath(fish, Paint()..color = color);
      canvas.drawPath(heart, Paint()..color = heartColor);
    } else {
      canvas.drawPath(
        fish,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.7
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        heart,
        Paint()
          ..color = heartColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FishHeartPainter old) =>
      old.filled != filled || old.color != color || old.heartColor != heartColor;
}

class FishLoader extends StatefulWidget {
  const FishLoader({super.key, this.size = 36, this.color = Palette.accent});

  final double size;
  final Color color;

  @override
  State<FishLoader> createState() => _FishLoaderState();
}

class _FishLoaderState extends State<FishLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
      _c.value = 0.2;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (context, _) => CustomPaint(
      size: Size.square(widget.size),
      painter: _FishLoaderPainter(t: _c.value, color: widget.color),
    ),
  );
}

class _FishLoaderPainter extends CustomPainter {
  _FishLoaderPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final n = size.width < 22 ? 1 : 3;
    final radius = size.width * 0.31;
    final fishScale = math.max(size.width * 0.34, 7) / 24;
    for (var i = 0; i < n; i++) {
      final a = t * math.pi * 2 + i * math.pi * 2 / n;
      final pos = center + Offset(math.cos(a), math.sin(a)) * radius;
      paintFish(
        canvas,
        pos,
        fishScale,
        a - math.pi / 2,
        Paint()
          ..color = color.withValues(
            alpha: n == 1 ? 0.9 : 0.4 + 0.5 * (i + 1) / n,
          ),
        math.sin(t * math.pi * 6 + i * 2) * 0.3,
      );
    }
    for (var b = 0; b < 2; b++) {
      final a = -t * math.pi * 1.6 + b * math.pi;
      final pos = center + Offset(math.cos(a), math.sin(a)) * radius * 0.45;
      canvas.drawCircle(
        pos,
        size.width * 0.04,
        Paint()
          ..color = color.withValues(alpha: 0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FishLoaderPainter old) =>
      old.t != t || old.color != color;
}

class FishSchool extends StatelessWidget {
  const FishSchool({super.key, this.size = 88, this.color = Palette.icon});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _FishSchoolPainter(color: color),
  );
}

class _FishSchoolPainter extends CustomPainter {
  _FishSchoolPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 96);
    paintFish(
      canvas,
      const Offset(34, 40),
      1.5,
      -0.06,
      Paint()..color = color.withValues(alpha: 0.75),
      0.18,
    );
    paintFish(
      canvas,
      const Offset(66, 26),
      1.0,
      -0.18,
      Paint()
        ..color = color.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
      -0.15,
    );
    paintFish(
      canvas,
      const Offset(64, 56),
      0.8,
      0.14,
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
      0.2,
    );
    final bubble = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(const Offset(20, 20), 3.2, bubble);
    canvas.drawCircle(const Offset(27, 11), 2.1, bubble);
    canvas.drawCircle(const Offset(78, 42), 2.6, bubble);
  }

  @override
  bool shouldRepaint(covariant _FishSchoolPainter old) => old.color != color;
}

class SplashPainter extends CustomPainter {
  SplashPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final p = Curves.easeOut.transform(progress);
    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      6 + 22 * p,
      Paint()
        ..color = color.withValues(alpha: (1 - p) * 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * (1 - p) + 0.5,
    );
    for (var i = 0; i < 7; i++) {
      final a = i * math.pi * 2 / 7 - math.pi / 2;
      final pos = center + Offset(math.cos(a), math.sin(a)) * (8 + 30 * p);
      canvas.drawCircle(
        pos,
        2.4 * (1 - p) + 0.4,
        Paint()..color = color.withValues(alpha: 1 - p),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SplashPainter old) =>
      old.progress != progress || old.color != color;
}