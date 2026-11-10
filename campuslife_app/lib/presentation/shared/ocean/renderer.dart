import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'ocean_math.dart';
import 'types.dart';

const int _alphaLevels = 6;
const List<double> _fishAlphas = [0.42, 0.56, 0.72, 0.86, 1];

const List<List<int>> _dotRgb = [
  [52, 68, 84],
];
const int _wake = 1;

const List<String> _accentHex = [
  "#a8641c",
  "#b32f28",
  "#8a37ad",
  "#1a8f96",
  "#237a31",
  "#26389e",
  "#9a832a",
];

const double _bgLum = 248;
const double _inkLum = 66;

/// Quantize luminance before it reaches a glyph colour. Continuous shades
/// would otherwise produce a unique colour per cell per frame, thrashing the
/// paragraph cache (a rebuild per miss is the most expensive thing in the
/// paint loop). A 6-unit step is far below the flicker jitter the reference
/// itself applies, so the picture is unchanged to the eye.
double _qLum(double v) => (v / 6).roundToDouble() * 6;

ui.Color _ink(double lum, double tr, double tg, double tb) {
  int c(double v) {
    final r = v.round();
    return r < 0
        ? 0
        : r > 255
        ? 255
        : r;
  }

  const k = 0.62;
  return ui.Color.fromARGB(
    255,
    c(lum * (1 + (tr - 1) * k)),
    c(lum * (1 + (tg - 1) * k)),
    c(lum * (1 + (tb - 1) * k)),
  );
}

const String skinRamp = ":;t%SX8#@";
const String finGlyphs = "%;tS:";
const String ridgeGlyphs = "@8%";
const String edgeLight = ".',`";

const int flagBody = 1;
const int flagEdge = 2;
const int flagFin = 3;
const int flagRidge = 4;
const int flagEye = 5;

const int flagMark = 6;
const String markGlyphs = "#%@";

const List<double> subsamples = [0.25, 0.3, 0.75, 0.3, 0.25, 0.72, 0.75, 0.72];

double _classicHalfWidth(double s) {
  if (s < 0.13) {
    return 0.118 * math.pow(math.sin(((s / 0.13) * math.pi) / 2), 0.95);
  }
  if (s < 0.3) return 0.118 + 0.017 * smoothstep(0.13, 0.3, s);
  if (s < 0.84) {
    return 0.03 + 0.105 * math.pow(1 - (s - 0.3) / 0.54, 1.15);
  }
  final k = (s - 0.84) / 0.16;
  return 0.03 * (1 - k) + 0.02 * math.sin(k * math.pi);
}

class SharkHead {
  final double span;
  final double sweep;
  final double depth;
  final double notch;
  const SharkHead(this.span, this.sweep, this.depth, this.notch);
}

class SharkShape {
  final SharkKind kind;
  final double Function(double) halfWidth;

  final List<double> pectoral;

  final bool falcate;

  final List<double> pelvic;

  final double caudal;
  final List<double> dorsal;
  final List<double> secondDorsal;

  final SharkHead? head;

  final List<double>? eye;
  final List<double> gills;

  final List<double> tint;

  const SharkShape({
    required this.kind,
    required this.halfWidth,
    required this.pectoral,
    required this.falcate,
    required this.pelvic,
    required this.caudal,
    required this.dorsal,
    required this.secondDorsal,
    this.head,
    this.eye,
    required this.gills,
    required this.tint,
  });
}

const _hwSteps = 64;

const List<SharkShape> shapes = [
  SharkShape(
    kind: SharkKind.classic,
    halfWidth: _classicHalfWidth,
    pectoral: [0.18, 0.28, 0.4, 0.205],
    falcate: true,
    pelvic: [0.57, 0.65, 0.69, 0.1],
    caudal: 0.13,
    dorsal: [0.33, 0.47],
    secondDorsal: [0.71, 0.76],
    eye: [0.1, 0.14],
    gills: [0.19, 0.29],
    tint: [0.92, 0.97, 1.05],
  ),

  SharkShape(
    kind: SharkKind.hammerhead,
    halfWidth: _hammerHalfWidth,
    pectoral: [0.2, 0.29, 0.41, 0.19],
    falcate: true,
    pelvic: [0.56, 0.63, 0.67, 0.1],
    caudal: 0.14,
    dorsal: [0.28, 0.44],
    secondDorsal: [0.7, 0.74],
    head: SharkHead(0.17, 0.035, 0.09, 0),
    eye: null,
    gills: [0.16, 0.26],
    tint: [0.96, 0.98, 0.9],
  ),

  SharkShape(
    kind: SharkKind.zebra,
    halfWidth: _zebraHalfWidth,
    pectoral: [0.13, 0.25, 0.34, 0.145],
    falcate: false,
    pelvic: [0.42, 0.48, 0.51, 0.065],
    caudal: 0,
    dorsal: [0.36, 0.44],
    secondDorsal: [0.49, 0.53],
    eye: [0.06, 0.09],
    gills: [0.13, 0.2],
    tint: [1.08, 0.97, 0.74],
  ),

  SharkShape(
    kind: SharkKind.tiger,
    halfWidth: _tigerHalfWidth,
    pectoral: [0.17, 0.28, 0.4, 0.215],
    falcate: true,
    pelvic: [0.57, 0.65, 0.69, 0.105],
    caudal: 0.135,
    dorsal: [0.33, 0.46],
    secondDorsal: [0.71, 0.75],
    eye: [0.08, 0.12],
    gills: [0.19, 0.28],
    tint: [1.02, 0.95, 0.84],
  ),

  SharkShape(
    kind: SharkKind.greatHammer,
    halfWidth: _greatHammerHalfWidth,
    pectoral: [0.18, 0.31, 0.44, 0.19],
    falcate: true,
    pelvic: [0.55, 0.62, 0.67, 0.085],
    caudal: 0.13,
    dorsal: [0.24, 0.45],
    secondDorsal: [0.68, 0.74],
    head: SharkHead(0.21, 0.006, 0.085, 0.014),
    eye: null,
    gills: [0.15, 0.25],
    tint: [0.86, 0.93, 1.02],
  ),

  SharkShape(
    kind: SharkKind.mako,
    halfWidth: _makoHalfWidth,
    pectoral: [0.21, 0.3, 0.42, 0.19],
    falcate: true,
    pelvic: [0.58, 0.64, 0.68, 0.085],
    caudal: 0.15,
    dorsal: [0.34, 0.45],
    secondDorsal: [0.76, 0.79],
    eye: [0.11, 0.15],
    gills: [0.2, 0.3],
    tint: [0.78, 0.9, 1.2],
  ),

  SharkShape(
    kind: SharkKind.thresher,
    halfWidth: _thresherHalfWidth,
    pectoral: [0.13, 0.24, 0.33, 0.15],
    falcate: true,
    pelvic: [0.37, 0.41, 0.44, 0.045],
    caudal: 0,
    dorsal: [0.24, 0.32],
    secondDorsal: [0.45, 0.47],
    eye: [0.05, 0.1],
    gills: [0.11, 0.18],
    tint: [1.0, 0.9, 1.08],
  ),

  SharkShape(
    kind: SharkKind.nurse,
    halfWidth: _nurseHalfWidth,
    pectoral: [0.16, 0.3, 0.37, 0.15],
    falcate: false,
    pelvic: [0.45, 0.52, 0.55, 0.075],
    caudal: 0,
    dorsal: [0.5, 0.58],
    secondDorsal: [0.63, 0.69],
    eye: [0.05, 0.075],
    gills: [0.14, 0.22],
    tint: [1.1, 0.96, 0.76],
  ),
];

double _hammerHalfWidth(double s) {
  if (s < 0.06) return 0.06;
  if (s < 0.3) return 0.06 + 0.072 * smoothstep(0.06, 0.3, s);
  return _classicHalfWidth(s) * 0.92;
}

double _zebraHalfWidth(double s) {
  if (s < 0.1) {
    return 0.075 * math.pow(math.sin(((s / 0.1) * math.pi) / 2), 0.7);
  }
  if (s < 0.28) return 0.075 + 0.025 * smoothstep(0.1, 0.28, s);
  if (s < 0.55) {
    return 0.022 + 0.078 * math.pow(1 - (s - 0.28) / 0.27, 1.1);
  }
  final k = (s - 0.55) / 0.45;
  return 0.022 * (1 - k * k) + 0.012 * math.sin(k * math.pi);
}

double _tigerHalfWidth(double s) {
  if (s < 0.13) {
    return 0.126 * math.pow(math.sin(((s / 0.13) * math.pi) / 2), 0.45);
  }
  if (s < 0.3) return 0.126 + 0.019 * smoothstep(0.13, 0.3, s);
  if (s < 0.84) {
    return 0.032 + 0.113 * math.pow(1 - (s - 0.3) / 0.54, 1.1);
  }
  final k = (s - 0.84) / 0.16;
  return 0.032 * (1 - k) + 0.022 * math.sin(k * math.pi);
}

double _greatHammerHalfWidth(double s) {
  if (s < 0.05) return 0.04;
  if (s < 0.3) return 0.04 + 0.07 * smoothstep(0.05, 0.3, s);
  return _classicHalfWidth(s) * 0.95;
}

double _makoHalfWidth(double s) {
  if (s < 0.17) {
    return 0.112 * math.pow(math.sin(((s / 0.17) * math.pi) / 2), 1.5);
  }
  if (s < 0.32) return 0.112 + 0.016 * smoothstep(0.17, 0.32, s);
  if (s < 0.86) {
    return 0.028 + 0.1 * math.pow(1 - (s - 0.32) / 0.54, 1.3);
  }
  final k = (s - 0.86) / 0.14;
  return 0.028 * (1 - k) + 0.018 * math.sin(k * math.pi);
}

double _thresherHalfWidth(double s) {
  if (s < 0.08) {
    return 0.07 * math.pow(math.sin(((s / 0.08) * math.pi) / 2), 0.75);
  }
  if (s < 0.2) return 0.07 + 0.02 * smoothstep(0.08, 0.2, s);
  if (s < 0.48) {
    return 0.012 + 0.078 * math.pow(1 - (s - 0.2) / 0.28, 1.3);
  }

  final k = (s - 0.48) / 0.52;
  return 0.012 * (1 - k) + 0.006 * math.sin(k * math.pi * 0.9) + 0.002;
}

double _nurseHalfWidth(double s) {
  if (s < 0.08) {
    return 0.085 * math.pow(math.sin(((s / 0.08) * math.pi) / 2), 0.4);
  }
  if (s < 0.3) return 0.085 + 0.02 * smoothstep(0.08, 0.3, s);
  if (s < 0.72) {
    return 0.022 + 0.083 * math.pow(1 - (s - 0.3) / 0.42, 1.1);
  }
  final k = (s - 0.72) / 0.28;
  return 0.022 * (1 - k * k) + 0.014 * math.sin(k * math.pi);
}

final List<Float32List> _hwLuts = () {
  final luts = <Float32List>[];
  for (final shape in shapes) {
    final lut = Float32List(_hwSteps + 1);
    for (var i = 0; i <= _hwSteps; i++) {
      lut[i] = shape.halfWidth(i / _hwSteps);
    }
    luts.add(lut);
  }
  return luts;
}();

double _hwAt(Float32List lut, double s) {
  final x = s < 0
      ? 0.0
      : s > 1
      ? _hwSteps.toDouble()
      : s * _hwSteps;
  final i = x < _hwSteps ? x.toInt() : _hwSteps - 1;
  final f = x - i;
  return lut[i] + (lut[i + 1] - lut[i]) * f;
}

bool _inTriangle(
  double px,
  double py,
  double ax,
  double ay,
  double bx,
  double by,
  double cx,
  double cy,
) {
  final d1 = (px - bx) * (ay - by) - (ax - bx) * (py - by);
  final d2 = (px - cx) * (by - cy) - (bx - cx) * (py - cy);
  final d3 = (px - ax) * (cy - ay) - (cx - ax) * (py - ay);
  final neg = d1 < 0 || d2 < 0 || d3 < 0;
  final pos = d1 > 0 || d2 > 0 || d3 > 0;
  return !(neg && pos);
}

void paintGrid(ui.Canvas g, ui.Size size, double cw, double ch, double dpr) {
  final W = size.width;
  final H = size.height;
  final paint = ui.Paint()
    ..isAntiAlias = false
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 1 / dpr
    ..color = ui.Color.fromRGBO(18, 22, 29, 0.014);

  for (var c = 0; c <= (W / cw).ceil(); c++) {
    final x = ((c * cw * dpr).round() + 0.5) / dpr;
    g.drawLine(ui.Offset(x, 0), ui.Offset(x, H), paint);
  }
  for (var r = 0; r <= (H / ch).ceil(); r++) {
    final y = ((r * ch * dpr).round() + 0.5) / dpr;
    g.drawLine(ui.Offset(0, y), ui.Offset(W, y), paint);
  }
}

class OceanRenderer {
  double dpr = 1;
  double width = 0;
  double height = 0;
  double cw = 12;
  double ch = 18;
  int cols = 0;
  int rows = 0;

  Uint8List dotKind = Uint8List(0);
  Float32List dotPhase = Float32List(0);
  Float32List dotFreq = Float32List(0);
  Float32List energy = Float32List(0);
  Float32List energyTmp = Float32List(0);
  Float32List heat = Float32List(0);
  Uint8List bucketOf = Uint8List(0);
  Int32List bucketOrder = Int32List(0);
  Int32List bucketCounts = Int32List((_dotRgb.length + 1) * _alphaLevels + 1);
  late final List<ui.Color> dotStyles = () {
    const wakeRgb = [36, 128, 156];
    final styles = <ui.Color>[];
    for (var c = 0; c <= _dotRgb.length; c++) {
      final rgb = c == _dotRgb.length ? wakeRgb : _dotRgb[c];
      final gain = c == _dotRgb.length ? 0.8 : 0.62;
      for (var l = 0; l < _alphaLevels; l++) {
        final a = ((l + 1) / _alphaLevels) * gain;
        styles.add(ui.Color.fromRGBO(rgb[0], rgb[1], rgb[2], a));
      }
    }
    return styles;
  }();

  Uint8List sharkFlag = Uint8List(0);
  Float32List sharkShade = Float32List(0);
  Uint32List sharkKey = Uint32List(0);
  Float32List sharkDepth = Float32List(0);
  Uint8List sharkKind = Uint8List(0);

  Uint8List sharkShadow = Uint8List(0);
  final Float32List spine = Float32List(sharkNodes * 2);
  final Float32List arc = Float32List(sharkNodes);
  double arcTotal = 1;
  late SharkShape shape = shapes[0];
  late Float32List hw = _hwLuts[0];
  int sharkId = 0;
  double finTipLeft = 0;
  double finTipRight = 0;

  int hitFlag = 0;
  double hitShade = 0;
  double hitS = 0;
  double hitV = 0;
  double hitDist = 0;

  Uint32List fishStamp = Uint32List(0);
  int frameId = 0;

  final List<List<int>> fishBuckets = List.generate(5, (_) => <int>[]);
  final List<ui.Color> fishStyles = _fishAlphas
      .map((a) => ui.Color.fromRGBO(22, 30, 44, a))
      .toList();

  static final List<ui.Color> _accents = _accentHex
      .map((h) => ui.Color(int.parse(h.substring(1), radix: 16) | 0xFF000000))
      .toList();
  static const ui.Color _paper = ui.Color(0xFFF6F6F3);
  static const ui.Color _dark = ui.Color(0xFF141A22);

  final ui.Paint _block = ui.Paint()..isAntiAlias = false;
  final ui.Paint _paperPaint = ui.Paint()..isAntiAlias = false;

  final Map<int, ui.Paragraph> _paragraphCache = {};
  double _fontSize = 0;
  static const String _monoFamily = 'OceanMono';

  double get cellWidth => cw;

  double get cellHeight => ch;

  bool get ready => cols > 0;

  void resize(double width, double height, double dpr) {
    final prevCols = cols;
    final prevRows = rows;
    this.width = width;
    this.height = height;
    this.dpr = dpr;
    // Same logical cell size as the HTML reference, including phone widths.
    cw = (width / 215).round().clamp(5, 8).toDouble();
    ch = (cw * 1.45).round().toDouble();
    cols = (width / cw).ceil();
    rows = (height / ch).ceil();

    final n = cols * rows;
    if (cols != prevCols || rows != prevRows) {
      dotKind = Uint8List(n);
      dotPhase = Float32List(n);
      dotFreq = Float32List(n);
      energy = Float32List(n);
      energyTmp = Float32List(n);
      heat = Float32List(n);
      bucketOf = Uint8List(n);
      bucketOrder = Int32List(n);
      sharkFlag = Uint8List(n);
      sharkShade = Float32List(n);
      sharkKey = Uint32List(n);
      sharkDepth = Float32List(n);
      sharkKind = Uint8List(n);
      sharkShadow = Uint8List(n);
      fishStamp = Uint32List(n);
    }

    for (var i = 0; i < n; i++) {
      final col = i % cols;
      final row = i ~/ cols;

      // The reference has no ambient dots. Only sparse swimming wakes remain.
      dotKind[i] = 0;
      dotPhase[i] = hash3(col, row, 23) * math.pi * 2;
      dotFreq[i] = 0.3 + hash3(col, row, 37) * 1.1;
    }

    final fontSize = (ch * 0.88).round().toDouble();
    if (fontSize != _fontSize) {
      _fontSize = fontSize;
      _paragraphCache.clear();
    }
  }

  void render(ui.Canvas ctx, OceanScene scene, double dt) {
    if (cols == 0) return;
    final t = scene.time;

    _consumeEvents(scene);
    _rasterizeSharks(scene.sharks, t);
    _depositWake(scene);
    _diffuse(dt);

    _paperPaint.color = _paper;
    ctx.drawRect(ui.Rect.fromLTWH(0, 0, width, height), _paperPaint);
    paintGrid(ctx, ui.Size(width, height), cw, ch, dpr);

    _markFish(scene);
    _drawDots(ctx, t);
    _drawHeat(ctx);
    _drawFish(ctx);
    _drawSharks(ctx, t);
  }

  int _cellIndex(double x, double y) {
    final c = (x / cw).floor();
    final r = (y / ch).floor();
    if (c < 0 || r < 0 || c >= cols || r >= rows) return -1;
    return r * cols + c;
  }

  void _stamp(
    Float32List field,
    double x,
    double y,
    int radius,
    double amount,
  ) {
    final c0 = (x / cw).floor();
    final r0 = (y / ch).floor();
    for (var r = r0 - radius; r <= r0 + radius; r++) {
      for (var c = c0 - radius; c <= c0 + radius; c++) {
        if (c < 0 || r < 0 || c >= cols || r >= rows) continue;
        final dx = (c - c0).toDouble();
        final dy = (r - r0).toDouble() * 1.4;
        final d = math.sqrt(dx * dx + dy * dy);
        if (d > radius + 0.5) continue;
        final i = r * cols + c;
        field[i] = math.min(1.6, field[i] + amount * (1 - d / (radius + 1)));
      }
    }
  }

  void _consumeEvents(OceanScene scene) {
    for (final e in scene.events) {
      if (e.kind == WorldEventKind.eat) {
        _stamp(heat, e.x, e.y, 2, 1);
        _stamp(energy, e.x, e.y, 3, 0.9);
      } else {
        _stamp(energy, e.x, e.y, 6, 1.4);
      }
    }
    scene.events.clear();
  }

  void _depositWake(OceanScene scene) {
    for (final f in scene.fish) {
      if (!f.alive) continue;
      final i = _cellIndex(f.x, f.y);
      if (i >= 0) energy[i] = math.min(1.6, energy[i] + 0.012 + f.alarm * 0.03);
    }
    for (final sh in scene.sharks) {
      for (var k = sharkNodes - 6; k < sharkNodes; k++) {
        final i = _cellIndex(sh.nodes[k * 2], sh.nodes[k * 2 + 1]);
        if (i >= 0) {
          energy[i] = math.min(1.6, energy[i] + 0.05 + sh.speed * 0.0012);
        }
      }
    }
    if (scene.pointer.active) {
      _stamp(energy, scene.pointer.x, scene.pointer.y, 1, 0.08);
    }
  }

  void _diffuse(double dt) {
    final old = energy;
    final tmp = energyTmp;
    final decay = math.exp(-dt * 1.5);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final i = r * cols + c;
        final l = c > 0 ? old[i - 1] : old[i];
        final rt = c < cols - 1 ? old[i + 1] : old[i];
        final u = r > 0 ? old[i - cols] : old[i];
        final d = r < rows - 1 ? old[i + cols] : old[i];
        tmp[i] = (old[i] * 4 + l + rt + u + d) * 0.125 * decay;
      }
    }
    energy = tmp;
    energyTmp = old;
    final heatDecay = math.exp(-dt * 2.2);
    for (var i = 0; i < heat.length; i++) {
      heat[i] *= heatDecay;
    }
  }

  bool _sampleShark(double px, double py, double L, int k0, int k1) {
    double best = double.infinity;
    double bestS = 0;
    double bestSign = 1;
    double bestNx = 0;
    double bestNy = 0;
    for (var k = k0; k < k1; k++) {
      final ax = spine[k * 2];
      final ay = spine[k * 2 + 1];
      final sx = spine[(k + 1) * 2] - ax;
      final sy = spine[(k + 1) * 2 + 1] - ay;
      final len2 = (sx * sx + sy * sy) == 0 ? 1.0 : sx * sx + sy * sy;
      final u = clampNum(((px - ax) * sx + (py - ay) * sy) / len2, 0, 1);
      final qx = ax + sx * u;
      final qy = ay + sy * u;
      final dx = px - qx;
      final dy = py - qy;
      final d2 = dx * dx + dy * dy;
      if (d2 < best) {
        best = d2;
        final len = math.sqrt(len2);
        bestS = (arc[k] + u * len) / arcTotal;
        bestSign = sx * (py - ay) - sy * (px - ax) >= 0 ? 1 : -1;
        bestNx = (-sy / len) * bestSign;
        bestNy = (sx / len) * bestSign;
      }
    }

    final a = math.sqrt(best);
    final s = bestS;
    final u = s * L;
    final shape = this.shape;
    final w = _hwAt(hw, s) * L;
    hitDist = a;
    hitS = s;
    hitV = a * bestSign;

    final head = shape.head;
    if (head != null && u < L * (head.sweep + head.depth + head.notch)) {
      final span = L * head.span;
      final r = a / span;
      final front =
          L * head.sweep * r * r + L * head.notch * math.max(0, 1 - r / 0.14);

      final depth = L * head.depth * (1 - 0.2 * r * r * r * r);
      if (r <= 1 && u >= front && u <= front + depth) {
        hitFlag = r > 0.84 ? flagEye : flagBody;
        hitShade = r > 0.84
            ? 0
            : 0.62 - 0.2 * r + (u < front + L * 0.012 ? 0.1 : 0);
        return true;
      }
    }

    if (a <= w) {
      final across = a / (w == 0 ? 1 : w);

      final facing = (bestNx * -0.6 + bestNy * -0.8) * across;
      var shade = 0.58 - across * across * 0.42 + facing * 0.26;
      var flag = flagBody;
      final df = (s - shape.dorsal[0]) / (shape.dorsal[1] - shape.dorsal[0]);
      if (df > 0 && df < 1 && across < 0.62 * (1 - 0.78 * df * df)) {
        flag = flagRidge;
        shade = 1 - 0.34 * smoothstep(0.3, 0.62, across);
      } else if (s > shape.secondDorsal[0] &&
          s < shape.secondDorsal[1] &&
          across <
              0.44 *
                  (1 -
                      0.7 *
                          (s - shape.secondDorsal[0]) /
                          (shape.secondDorsal[1] - shape.secondDorsal[0]))) {
        flag = flagRidge;
        shade = 0.9;
      } else if (shape.eye != null &&
          s > shape.eye![0] &&
          s < shape.eye![1] &&
          across > 0.6) {
        flag = flagEye;
        shade = 0;
      } else if (s > shape.gills[0] && s < shape.gills[1] && across > 0.5) {
        final g =
            ((s - shape.gills[0]) / (shape.gills[1] - shape.gills[0])) * 5;
        if (g - g.floor() < 0.3) shade = math.max(shade, 0.82);
      } else if (s < 0.05) {
        shade = math.max(shade, 0.7);
      } else if (_marked(s, a * bestSign, L, across)) {
        flag = flagMark;
      } else if (shape.kind == SharkKind.tiger &&
          s > 0.14 &&
          s < 0.3 &&
          (across - 0.52).abs() < 0.06) {
        shade = math.max(shade, 0.8);
      }
      if (flag == flagBody) {
        if (s > 0.08 && s < 0.86 && across < 0.09) {
          shade *= 0.58;
        } else if (s > 0.014 && s < 0.055 && across > 0.45) {
          shade = math.max(shade, 0.92);
        } else if (s > 0.84 && s < 0.93 && across < 0.14) {
          shade = math.max(shade, 0.86);
        }

        if (s > 0.06 && s < 0.8 && (across - 0.46).abs() < 0.05) {
          shade = math.max(shade, 0.76);
        } else if (across > 0.93) {
          shade = math.max(shade, 0.88);
        } else if (across > 0.84) {
          shade *= 0.6;
        }
      }
      hitFlag = flag;
      hitShade = shade;
      return true;
    }

    final tip = bestSign > 0 ? finTipRight : finTipLeft;
    final p0 = shape.pectoral[0];
    final p1 = shape.pectoral[1];
    final p2 = shape.pectoral[2];
    if (_inTriangle(u, a, L * p0, 0, L * p1, 0, L * p2, tip) &&
        !(shape.falcate &&
            _inTriangle(
              u,
              a,
              L * p1,
              0,
              L * (p1 + (p2 - p1) * 0.33),
              tip * 0.55,
              L * p2,
              tip,
            ))) {
      hitFlag = _marked(s, a * bestSign, L, 0) ? flagMark : flagFin;

      final t = clampNum(a / tip, 0, 1);
      final rays =
          0.5 + 0.5 * math.sin(math.atan2(a, math.max(1, u - L * p0)) * 13);
      hitShade = clampNum(0.24 + 0.36 * (1 - t) + 0.24 * rays, 0, 1);
      return true;
    }
    final v0 = shape.pelvic[0];
    final v1 = shape.pelvic[1];
    final v2 = shape.pelvic[2];
    final vr = shape.pelvic[3];
    final caudal = L * shape.caudal * 1.35;
    if (_inTriangle(u, a, L * v0, 0, L * v1, 0, L * v2, L * vr) ||
        (shape.caudal > 0 &&
            _inTriangle(u, a, L * 0.85, 0, L * 0.94, 0, L * 0.995, caudal) &&
            !(a < caudal * 0.34 && u > L * 0.965))) {
      hitFlag = flagFin;
      final k = clampNum((u / L - 0.85) / 0.145, 0, 1);
      hitShade = clampNum(
        0.3 + 0.42 * k + 0.2 * math.sin(a / (caudal == 0 ? 1 : caudal) * 7.5),
        0,
        1,
      );
      return true;
    }
    return false;
  }

  bool _marked(double s, double v, double L, double across) {
    final kind = shape.kind;
    if (kind == SharkKind.tiger) {
      if (s < 0.2 || s > 0.9 || across > 0.85) return false;
      final wobble = 0.35 * math.sin((v / L) * 25 + s * 5);
      final bar = math.sin(s * math.pi * 2 * 9 + wobble);
      return bar >
          0.65 - 0.5 * smoothstep(0.2, 0.42, s) + 0.4 * smoothstep(0.8, 0.9, s);
    }
    if (kind == SharkKind.classic || kind == SharkKind.mako) {
      if (s < 0.1 || s > 0.74 || across < 0.16 || across > 0.82) return false;
      final gu = (s * L) / (L * 0.05);
      final gv = v / (L * 0.055);
      final cu = gu.floor();
      final cv = gv.floor();
      if (hash3(cu, cv, sharkId) < 0.45) return false;
      final jx = hash3(cu, cv, sharkId + 5) * 0.6 + 0.2;
      final jy = hash3(cu, cv, sharkId + 17) * 0.6 + 0.2;
      return (gu - cu - jx) * (gu - cu - jx) + (gv - cv - jy) * (gv - cv - jy) <
          0.1;
    }
    if (kind == SharkKind.zebra) {
      if (s < 0.07) return false;
      final gu = (s * L) / (L * 0.06);
      final gv = v / (L * 0.045);
      final cu = gu.floor();
      final cv = gv.floor();
      final jx = hash3(cu, cv, sharkId) * 0.5 + 0.25;
      final jy = hash3(cu, cv, sharkId + 11) * 0.5 + 0.25;
      return (gu - cu - jx) * (gu - cu - jx) + (gv - cv - jy) * (gv - cv - jy) <
          0.08;
    }
    return false;
  }

  void _rasterizeSharks(List<Shark> sharks, double t) {
    sharkFlag.fillRange(0, sharkFlag.length, 0);
    sharkShadow.fillRange(0, sharkShadow.length, 0);

    for (final sh in sharks) {
      final L = sh.length;
      const N = sharkNodes;
      final n = sh.nodes;
      final swim = clampNum(sh.speed / 60, 0.4, 1.4);
      final shape = shapes[sh.kind.index];
      this.shape = shape;
      hw = _hwLuts[sh.kind.index];
      sharkId = sh.id;
      final kindIndex = sh.kind.index;

      for (var k = 0; k < N; k++) {
        final s = k / (N - 1);
        final aa = k - 1 < 0 ? 0 : k - 1;
        final b = k + 1 > N - 1 ? N - 1 : k + 1;
        var tx = n[aa * 2] - n[b * 2];
        var ty = n[aa * 2 + 1] - n[b * 2 + 1];
        final tl = math.sqrt(tx * tx + ty * ty);
        if (tl == 0) {
          tx = 0;
          ty = 0;
        } else {
          tx /= tl;
          ty /= tl;
        }
        final amp = L * 0.05 * (0.1 + 0.9 * math.pow(s, 1.8)) * swim;
        final off = amp * math.sin(sh.phase - s * 5.2);
        spine[k * 2] = n[k * 2] - ty * off;
        spine[k * 2 + 1] = n[k * 2 + 1] + tx * off;
      }
      arc[0] = 0;
      for (var k = 1; k < N; k++) {
        final dx = spine[k * 2] - spine[(k - 1) * 2];
        final dy = spine[k * 2 + 1] - spine[(k - 1) * 2 + 1];
        arc[k] = arc[k - 1] + math.sqrt(dx * dx + dy * dy);
      }
      arcTotal = arc[N - 1] == 0 ? 1 : arc[N - 1];

      final bank = clampNum(sh.turn * 0.45, -0.35, 0.35);
      final flex = 1 + 0.06 * math.sin(sh.phase * 0.5);
      final reachFin = shape.pectoral[3];
      finTipRight = L * reachFin * flex * (1 - bank);
      finTipLeft = L * reachFin * flex * (1 + bank);

      var minX = double.infinity;
      var minY = double.infinity;
      var maxX = double.negativeInfinity;
      var maxY = double.negativeInfinity;
      for (var k = 0; k < N; k++) {
        final sx = spine[k * 2];
        final sy = spine[k * 2 + 1];
        if (sx < minX) minX = sx;
        if (sx > maxX) maxX = sx;
        if (sy < minY) minY = sy;
        if (sy > maxY) maxY = sy;
      }
      final reach = L * 0.26;
      final c0 = math.max(0, ((minX - reach) / cw).floor());
      final c1 = math.min(cols - 1, ((maxX + reach) / cw).floor());
      final r0 = math.max(0, ((minY - reach) / ch).floor());
      final r1 = math.min(rows - 1, ((maxY + reach) / ch).floor());
      if (c0 > c1 || r0 > r1) continue;

      final diag = math.sqrt(cw * cw + ch * ch);
      final skipBeyond = reach + diag;
      final shadowDc = ((L * 0.035) / cw).round() + 1;
      final shadowDr = ((L * 0.02) / ch).round() + 1;

      final band = reach + ch;
      for (var r = r0; r <= r1; r++) {
        final yc = r * ch + ch / 2;

        var lo = N;
        var hi = -1;
        for (var k = 0; k < N - 1; k++) {
          final y0 = spine[k * 2 + 1];
          final y1 = spine[(k + 1) * 2 + 1];
          if (math.max(y0, y1) < yc - band || math.min(y0, y1) > yc + band) {
            continue;
          }
          if (k < lo) lo = k;
          if (k > hi) hi = k;
        }
        if (hi < 0) continue;
        final k0 = lo;
        final k1 = hi + 1;

        var wx0 = double.infinity;
        var wx1 = double.negativeInfinity;
        for (var k = k0; k <= k1; k++) {
          final sx = spine[k * 2];
          if (sx < wx0) wx0 = sx;
          if (sx > wx1) wx1 = sx;
        }
        final col0 = math.max(c0, ((wx0 - band) / cw).floor());
        final col1 = math.min(c1, ((wx1 + band) / cw).floor());

        for (var c = col0; c <= col1; c++) {
          final x = c * cw;
          final y = r * ch;
          final centerHit = _sampleShark(x + cw / 2, y + ch / 2, L, k0, k1);
          if (!centerHit && hitDist > skipBeyond) continue;
          final flag = hitFlag;
          final shade = hitShade;
          final s = hitS;
          final v = hitV;

          final solid = centerHit && hitDist < _hwAt(hw, s) * L - diag;
          var hits = solid ? 5 : (centerHit ? 1 : 0);
          if (!solid) {
            for (var k = 0; k < subsamples.length; k += 2) {
              if (_sampleShark(
                x + subsamples[k] * cw,
                y + subsamples[k + 1] * ch,
                L,
                k0,
                k1,
              )) {
                hits++;
              }
            }
          }
          if (hits == 0) continue;
          final coverage = hits / 5;

          final i = r * cols + c;

          final key =
              (hash3(s.round52(), (v / (cw * 0.9) + 0.5).floor(), sh.id) *
                      4294967295)
                  .toInt();
          sharkKey[i] = key;
          sharkDepth[i] = sh.depth;
          sharkKind[i] = kindIndex;

          if (centerHit && coverage >= 0.6) {
            sharkFlag[i] = flag;
            final flicker = (hash3(key, 17, (t * 6).floor()) - 0.5) * 0.02;
            sharkShade[i] = clampNum(shade + flicker, 0, 1);
            final sc = c + shadowDc;
            final sr = r + shadowDr;
            if (sc < cols && sr < rows) sharkShadow[sr * cols + sc] = 1;
          } else {
            sharkFlag[i] = flagEdge;
            sharkShade[i] = coverage;
          }
        }
      }
    }
  }

  void _drawSharks(ui.Canvas ctx, double t) {
    final n = cols * rows;
    for (var i = 0; i < n; i++) {
      final flag = sharkFlag[i];
      if (flag == 0) continue;
      final col = i % cols;
      final row = i ~/ cols;
      final x = col * cw;
      final y = row * ch;
      final key = sharkKey[i];
      final shade = sharkShade[i];
      final dim = 0.7 + 0.3 * sharkDepth[i];
      final tint = shapes[sharkKind[i]].tint;
      final tr = tint[0];
      final tg = tint[1];
      final tb = tint[2];

      final tick = (t * 2.4 + (key % 997) / 97).floor();
      final roll = hash3(key, tick, 7);

      if (flag == flagEdge) {
        if (shade >= 0.5) {
          var level = _bgLum - (_bgLum - _inkLum) * (0.4 + shade * 0.35);
          level = _bgLum + (level - _bgLum) * dim;
          _block.color = roll < 0.05
              ? _accents[key % _accents.length]
              : _ink(_qLum(level), tr, tg, tb);
          ctx.drawRect(ui.Rect.fromLTWH(x, y, cw - 1, ch - 1), _block);
        } else {
          final g = _bgLum - (52 + shade * 96) * dim;
          final color = roll < 0.07
              ? _accents[key % _accents.length]
              : _ink(_qLum(g), tr, tg, tb);
          _glyph(
            ctx,
            edgeLight[(key >> 8) % edgeLight.length],
            x + cw / 2,
            y + ch / 2 + 1,
            color,
          );
        }
        continue;
      }

      double level;
      String? glyph;
      if (flag == flagRidge) {
        level = _inkLum + 22;
        glyph = ridgeGlyphs[(key >> 8) % ridgeGlyphs.length];
      } else if (flag == flagEye) {
        level = _inkLum + 14;
        glyph = "o";
      } else if (flag == flagMark) {
        level = _inkLum + 24 + shade * 14;
        glyph = markGlyphs[(key >> 8) % markGlyphs.length];
      } else if (flag == flagFin) {
        level = _bgLum - (_bgLum - _inkLum) * (0.3 + shade * 0.4);
        glyph = finGlyphs[(key >> 8) % finGlyphs.length];
      } else {
        final sh = clampNum(shade + (hash3(key, 5, 11) - 0.5) * 0.06, 0, 1);
        level = _bgLum - (_bgLum - _inkLum) * clampNum(0.5 + sh * 0.5, 0, 1);
        final jitter = ((key >> 4) % 3) - 1;
        var gi = ((1 - sh) * 8.99).floor() + jitter;
        if (gi < 0) gi = 0;
        if (gi > skinRamp.length - 1) gi = skinRamp.length - 1;
        glyph = skinRamp[gi];

        if (hash3(key, 13, 5) < 0.38) glyph = null;
      }

      level = math.min(level, _bgLum - 62);
      level = _bgLum + (level - _bgLum) * dim;
      _block.color = _ink(_qLum(level), tr, tg, tb);
      ctx.drawRect(ui.Rect.fromLTWH(x, y, cw - 1, ch - 1), _block);

      final contrast = level > 150
          ? math.max<double>(70, level - 46)
          : math.min<double>(232, level + 46);
      ui.Color color;
      if (flag == flagEye) {
        color = _paper;
      } else if (roll < (flag == flagBody ? 0.004 : 0.025)) {
        color = _accents[key % _accents.length];
      } else if (roll < 0.012) {
        color = _dark;
      } else {
        color = _ink(_qLum(contrast), tr, tg, tb);
      }
      if (glyph != null) {
        _glyph(ctx, glyph, x + cw / 2, y + ch / 2 + 1, color);
      }
    }
  }

  void _markFish(OceanScene scene) {
    final frame = ++frameId;
    for (final bucket in fishBuckets) {
      bucket.clear();
    }
    for (var pass = 0; pass < 2; pass++) {
      for (final f in scene.fish) {
        if (!f.alive || (f.depth > 0.78 ? 0 : 1) != pass) continue;
        final i = _cellIndex(f.x, f.y);
        if (i < 0 || fishStamp[i] == frame || sharkFlag[i] != 0) continue;
        fishStamp[i] = frame;
        final glint = clampNum((f.turn).abs() / 3.5, 0, 1);
        final v =
            0.3 +
            (0.45 * (f.depth - 0.55)) / 0.45 +
            0.35 * math.max(glint, f.alarm);
        var bi = (v * _fishAlphas.length).floor();
        if (bi < 0) bi = 0;
        if (bi > _fishAlphas.length - 1) bi = _fishAlphas.length - 1;
        fishBuckets[bi].add(i);
      }
    }
  }

  void _drawFish(ui.Canvas ctx) {
    for (var b = 0; b < fishBuckets.length; b++) {
      for (final i in fishBuckets[b]) {
        _glyph(
          ctx,
          '-',
          (i % cols) * cw + cw / 2,
          (i ~/ cols) * ch + ch / 2 + 1,
          fishStyles[b],
        );
      }
    }
  }

  void _drawHeat(ui.Canvas ctx) {
    for (var i = 0; i < heat.length; i++) {
      final h = (heat[i] * 20).roundToDouble() / 20;
      if (h < 0.08) continue;
      final col = i % cols;
      final row = i ~/ cols;
      final color = h > 0.5
          ? ui.Color.fromRGBO(186, 84, 18, h)
          : ui.Color.fromRGBO(150, 32, 28, h * 1.6);
      _glyph(
        ctx,
        h > 0.6 ? "*" : "·",
        col * cw + cw / 2,
        row * ch + ch / 2 + 1,
        color,
      );
    }
  }

  void _drawDots(ui.Canvas ctx, double t) {
    final n = cols * rows;
    final counts = bucketCounts;
    counts.fillRange(0, counts.length, 0);
    final skip = counts.length - 1;

    for (var i = 0; i < n; i++) {
      final e = energy[i];
      final kind = dotKind[i];
      if (sharkFlag[i] != 0 ||
          fishStamp[i] == frameId ||
          (kind == 0 &&
              (e <= 0.65 || hash3(i % cols, i ~/ cols, 101) >= 0.35))) {
        bucketOf[i] = skip;
        continue;
      }
      int bucket;
      if (e > 0.45) {
        var level = ((e - 0.45) * 5).floor();
        if (level < 0) level = 0;
        if (level > _alphaLevels - 1) level = _alphaLevels - 1;
        bucket = _wake * _alphaLevels + level;
      } else {
        final col = i % cols;
        final row = i ~/ cols;

        final twinkle = 0.5 + 0.5 * math.sin(t * dotFreq[i] + dotPhase[i]);
        final caustic =
            0.92 +
            0.08 *
                math.sin(col * 0.11 + t * 0.35) *
                math.sin(row * 0.17 - t * 0.27);
        var v = clampNum((0.74 + 0.26 * twinkle) * caustic + e * 2, 0, 1);
        if (sharkShadow[i] != 0) v *= 0.2;
        var level = (v * _alphaLevels).floor();
        if (level < 0) level = 0;
        if (level > _alphaLevels - 1) level = _alphaLevels - 1;
        bucket = (kind - 1) * _alphaLevels + level;
      }
      bucketOf[i] = bucket;
      counts[bucket]++;
    }

    final starts = Int32List(counts.length);
    for (var b = 1; b < counts.length; b++) {
      starts[b] = starts[b - 1] + counts[b - 1];
    }
    final cursor = starts.toList();
    for (var i = 0; i < n; i++) {
      final b = bucketOf[i];
      if (b != skip) bucketOrder[cursor[b]++] = i;
    }

    final small = math.max(2, (cw * 0.19).round());
    final large = small + 1;
    for (var b = 0; b < skip; b++) {
      final count = counts[b];
      if (count == 0) continue;
      _block.color = dotStyles[b];
      final size = (b >= _wake * _alphaLevels ? large : small).toDouble();
      final start = starts[b];
      for (var k = start; k < start + count; k++) {
        final i = bucketOrder[k];
        final col = i % cols;
        final row = i ~/ cols;

        final dx = (col * cw + cw * 0.66 - size / 2).roundToDouble();
        final dy = (row * ch + ch * 0.64 - size / 2).roundToDouble();
        ctx.drawRect(ui.Rect.fromLTWH(dx, dy, size, size), _block);
      }
    }
  }

  void _glyph(
    ui.Canvas ctx,
    String glyph,
    double cx,
    double cy,
    ui.Color color,
  ) {
    // Keep exact colour AND alpha: fish at different depths must not reuse
    // the first fish's opacity. Multiplication also preserves the key on web.
    final key = glyph.codeUnitAt(0) * 0x100000000 + color.toARGB32();
    var p = _paragraphCache[key];
    if (p == null) {
      if (_paragraphCache.length >= 4096) _paragraphCache.clear();
      p = _buildParagraph(glyph, color);
      _paragraphCache[key] = p;
    }
    // Canvas textBaseline='middle' anchors the em box, not the line box.
    // The bundled Cascadia Mono's alphabetic baseline is ~0.3em below it
    // (measured in the reference canvas at 6, 9 and 11px).
    ctx.drawParagraph(
      p,
      ui.Offset(cx - p.width / 2, cy + _fontSize * 0.3 - p.alphabeticBaseline),
    );
  }

  ui.Paragraph _buildParagraph(String glyph, ui.Color color) {
    final builder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              textDirection: ui.TextDirection.ltr,
              textAlign: ui.TextAlign.center,
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: color,
              fontFamily: _monoFamily,
              fontWeight: ui.FontWeight.w600,
              fontSize: _fontSize,
            ),
          )
          ..addText(glyph);
    final p = builder.build();
    // Paragraph.width is the layout constraint, not the glyph width. Using
    // 1000 here shifted every skin/fin glyph about 500px left of its cell.
    p.layout(ui.ParagraphConstraints(width: cw));
    return p;
  }
}

extension on double {
  int round52() => (this * 52).round();
}
