import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

class PixelAvatar extends StatelessWidget {
  const PixelAvatar({super.key, required this.name, this.size = 48});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.field),
        border: Border.all(color: colors.accentLine),
      ),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PixelFishPainter(
            color: colors.accent,
            eye: colors.paper,
            seed: name.codeUnits.fold(0, (a, b) => a + b),
          ),
        ),
      ),
    );
  }
}

class PixelFishMark extends StatelessWidget {
  const PixelFishMark({super.key, this.size = 72, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: RepaintBoundary(
      child: CustomPaint(
        painter: _PixelFishPainter(
          color: color ?? context.colors.accent,
          eye: context.colors.paper,
        ),
      ),
    ),
  );
}

class _PixelFishPainter extends CustomPainter {
  const _PixelFishPainter({
    required this.color,
    required this.eye,
    this.seed = 0,
  });

  final Color color;
  final Color eye;
  final int seed;

  static const rows = [
    '000001111000',
    '000011111100',
    '110111111110',
    '111111111111',
    '111111111111',
    '110111111110',
    '000011111100',
    '000001111000',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final unit = math.min(size.width / 14, size.height / 10);
    final left = (size.width - unit * 12) / 2;
    final top = (size.height - unit * 8) / 2;
    final paint = Paint()..color = color;
    for (var y = 0; y < rows.length; y++) {
      for (var x = 0; x < rows[y].length; x++) {
        if (rows[y][x] != '1') continue;
        canvas.drawRect(
          Rect.fromLTWH(
            left + x * unit,
            top + y * unit,
            unit + 0.2,
            unit + 0.2,
          ),
          paint,
        );
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(left + unit * 9, top + unit * 2, unit, unit),
      Paint()..color = eye,
    );
    final bubble = Paint()..color = color.withValues(alpha: 0.45);
    for (var i = 0; i < 3; i++) {
      final x = left + unit * (13 + (seed + i) % 2);
      final y = top + unit * (1 + i * 2);
      canvas.drawRect(Rect.fromLTWH(x, y, unit * 0.55, unit * 0.55), bubble);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelFishPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.eye != eye ||
      oldDelegate.seed != seed;
}

class PixelProgress extends StatelessWidget {
  const PixelProgress({super.key, required this.value, this.cells = 12});

  final double value;
  final int cells;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      value: '${(value * 100).round()}%',
      child: Row(
        children: [
          for (var i = 0; i < cells; i++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: AppMotion.duration(context, AppMotion.normal),
                curve: AppMotion.ease,
                height: 8,
                decoration: BoxDecoration(
                  color: i / cells < value ? colors.accent : colors.washDeep,
                  borderRadius: BorderRadius.circular(AppRadius.pixel),
                ),
              ),
            ),
            if (i < cells - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class PixelDotsIndicator extends StatelessWidget {
  const PixelDotsIndicator({
    super.key,
    required this.count,
    required this.index,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          AnimatedContainer(
            duration: AppMotion.duration(context, AppMotion.normal),
            curve: AppMotion.ease,
            width: i == index ? 12 : 5,
            height: 5,
            decoration: BoxDecoration(
              color: i == index ? colors.accent : colors.lineStrong,
              borderRadius: BorderRadius.circular(AppRadius.pixel),
            ),
          ),
          if (i < count - 1) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class PixelBurst extends StatelessWidget {
  const PixelBurst({super.key, required this.animation, this.color});

  final Animation<double> animation;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) == true
      ? const SizedBox.shrink()
      : RepaintBoundary(
    child: AnimatedBuilder(
      animation: animation,
      builder: (context, _) => CustomPaint(
        painter: _PixelBurstPainter(
          progress: animation.value,
          color: color ?? context.colors.accent,
        ),
      ),
    ),
  );
}

class _PixelBurstPainter extends CustomPainter {
  const _PixelBurstPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final center = size.center(Offset.zero);
    final paint = Paint()..color = color.withValues(alpha: 1 - progress);
    for (var i = 0; i < 14; i++) {
      final angle = i / 14 * (2 * math.pi);
      final distance =
          AppMotion.ease.transform(progress) * size.shortestSide * 0.46;
      final side = 3.0 + (i % 3) * 1.5;
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawRect(
        Rect.fromCenter(center: point, width: side, height: side),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelBurstPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class PixelSkeleton extends StatefulWidget {
  const PixelSkeleton({super.key, this.rows = 3});

  final int rows;

  @override
  State<PixelSkeleton> createState() => _PixelSkeletonState();
}

class _PixelSkeletonState extends State<PixelSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.scene);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduced) {
      _controller.stop();
      _controller.value = 0.4;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.rows; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FractionallySizedBox(
                widthFactor: i == widget.rows - 1 ? 0.58 : 1,
                child: Container(
                  height: i == 0 ? 22 : 12,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(
                      alpha: 0.08 + _controller.value * 0.13,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.pixel),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
