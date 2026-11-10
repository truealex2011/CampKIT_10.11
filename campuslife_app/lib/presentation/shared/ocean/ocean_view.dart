import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import 'renderer.dart';
import 'types.dart';

const double _step = 1 / 60;
const int _maxSteps = 4;

class OceanView extends StatefulWidget {
  const OceanView({required this.scene, this.onSplash, super.key});

  final OceanScene scene;

  final void Function(double x, double y)? onSplash;

  @override
  State<OceanView> createState() => _OceanViewState();
}

class _OceanViewState extends State<OceanView>
    with SingleTickerProviderStateMixin {
  final OceanRenderer _renderer = OceanRenderer();
  final ValueNotifier<int> _repaint = ValueNotifier<int>(0);
  late final Ticker _ticker;
  double _last = 0;
  double _acc = 0;
  double _frameDt = _step;
  Size _size = Size.zero;
  double _dpr = 0;
  bool _reduced = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _applyMotion();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced =
        MediaQuery.disableAnimationsOf(context) ||
        SemanticsBinding.instance.disableAnimations;
    _applyMotion();
  }

  void _applyMotion() {
    if (_reduced) {
      if (_ticker.isActive) _ticker.stop();
      _drawStillSoon();
    } else {
      _schedule();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _schedule() {
    if (!_reduced && !_ticker.isActive) {
      _last = 0;
      _acc = 0;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!_renderer.ready) return;
    final now = elapsed.inMicroseconds / 1e6;
    var dt = now - _last;
    _last = now;
    if (dt < 0) dt = 0;
    if (dt > 0.1) dt = 0.1;
    _acc += dt;
    var steps = 0;
    while (_acc >= _step && steps < _maxSteps) {
      _advance(_step);
      _acc -= _step;
      steps++;
    }
    if (steps == _maxSteps) _acc = 0;
    _frameDt = dt;
    _repaint.value++;
  }

  void _advance(double dt) {
    widget.scene.step(dt);
  }

  void _drawStillSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _drawStill();
    });
  }

  void _drawStill() {
    if (!_renderer.ready) return;
    final scene = widget.scene;
    if (scene.time < 4) {
      for (var i = 0; i < 240; i++) {
        _advance(_step);
      }
    }
    _frameDt = _step;
    _repaint.value++;
  }

  void _maybeResize(Size size, double dpr) {
    if (size.width < 1 || size.height < 1) return;
    if (_size == size && _dpr == dpr) return;
    _size = size;
    _dpr = dpr;
    _renderer.resize(size.width, size.height, dpr);
    widget.scene.resize(
      size.width,
      size.height,
      _renderer.cellWidth,
      _renderer.cellHeight,
    );
    if (_reduced) _drawStillSoon();
  }

  void _setPointer(Offset local, bool active) {
    final p = widget.scene.pointer;
    p.x = local.dx;
    p.y = local.dy;
    p.active = active;
  }

  @override
  Widget build(BuildContext context) {
    final dpr = math.min(MediaQuery.devicePixelRatioOf(context), 2.0);
    return MouseRegion(
      onEnter: (e) => _setPointer(e.localPosition, true),
      onHover: (e) => _setPointer(e.localPosition, true),
      onExit: (_) => widget.scene.pointer.active = false,
      child: Listener(
        onPointerDown: (e) {
          final local = e.localPosition;
          final inside =
              local.dx >= 0 &&
              local.dy >= 0 &&
              local.dx <= _size.width &&
              local.dy <= _size.height;
          // Touch creates a splash, not a persistent mouse-avoidance point.
          if (e.kind == PointerDeviceKind.touch) {
            widget.scene.pointer.active = false;
          }
          if (inside && !_reduced) widget.onSplash?.call(local.dx, local.dy);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            _maybeResize(size, dpr);
            return CustomPaint(
              size: size,
              painter: _OceanPainter(
                _renderer,
                widget.scene,
                () => _frameDt,
                repaint: _repaint,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OceanPainter extends CustomPainter {
  _OceanPainter(this.renderer, this.scene, this.frameDt, {super.repaint});

  final OceanRenderer renderer;
  final OceanScene scene;
  final double Function() frameDt;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    renderer.render(canvas, scene, frameDt());
  }

  @override
  bool shouldRepaint(covariant _OceanPainter oldDelegate) => false;
}
