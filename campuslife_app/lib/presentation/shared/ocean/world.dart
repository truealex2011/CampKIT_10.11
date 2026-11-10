library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'ocean_math.dart';
import 'species.dart';
import 'types.dart';

const double megasharkPeriod = 300;
const double megasharkCross = 46;
const double megasharkFirst = 40;

const double fishSeparationK = 420;
const double fishAlignK = 1.4;
const double fishCohesionK = 1;
const double fishFleeK = 1100;
const double blindCos = -0.6;

const List<SharkSpec> _defaultSharks = [
  SharkSpec(SharkKind.classic, 1),
  SharkSpec(SharkKind.classic, 0.7),
  SharkSpec(SharkKind.classic, 0.84),
  SharkSpec(SharkKind.classic, 0.77),
];

double _hypot(double x, double y) => math.sqrt(x * x + y * y);

double _hypotOr(double x, double y, double fallback) {
  final v = _hypot(x, y);
  return v > 0 ? v : fallback;
}

double _sqrtOr(double v, double fallback) => v > 0 ? math.sqrt(v) : fallback;

int _clampInt(int v, int lo, int hi) => v < lo
    ? lo
    : v > hi
    ? hi
    : v;

class World implements OceanScene {
  @override
  double width = 0;
  @override
  double height = 0;
  @override
  double time = 0;
  @override
  List<Fish> fish = [];
  @override
  List<Shark> sharks = [];
  @override
  List<WorldEvent> events = [];
  @override
  PointerState pointer = PointerState();

  double _perception = 60;

  List<double> _sepX = [];
  List<double> _sepY = [];
  double _foreignSep = 40;
  int _bucketCols = 0;
  int _bucketRows = 0;
  Int32List _bucketHead = Int32List(0);
  Uint16List _bucketCount = Uint16List(0);
  Int32List _bucketNext = Int32List(0);
  double _lastSpawn = 0;
  final Vec2 _tmp = Vec2(0, 0);
  Shark? _megashark;
  double _megasharkAt = megasharkFirst;
  bool _megasharkCrossing = false;
  int _megasharkDir = 1;
  double _megasharkHeading = 0;

  final List<SharkSpec> _sharkSpecs;
  final int? _fishCount;
  final math.Random _rng;

  World({List<SharkSpec>? sharkSpecs, int? fishCount, math.Random? random})
    : _sharkSpecs = sharkSpecs ?? _defaultSharks,
      _fishCount = fishCount,
      _rng = random ?? math.Random();

  @override
  void resize(double width, double height, double cellW, double cellH) {
    final bool first = this.width == 0;
    this.width = width;
    this.height = height;

    _sepX = [for (final sp in speciesList) sp.spacingX * cellW];
    _sepY = [for (final sp in speciesList) sp.spacingY * cellH];
    _perception = math.max(cellH * 3, cellW * 5.5);
    _foreignSep = cellW * 3;

    if (first || fish.isEmpty) {
      seed();
      return;
    }
    for (final f in fish) {
      f.x = clampNum(f.x, 0, width);
      f.y = clampNum(f.y, 0, height);
    }
  }

  void seed() {
    final math.Random r = _rng;
    final double w = width;
    final double h = height;
    final double minSide = math.min(w, h);
    final double baseLength = clampNum(minSide * 0.44, 210, 400);
    final int sharkCount = _sharkSpecs.length;

    sharks = [];
    for (int i = 0; i < sharkCount; i++) {
      final SharkSpec spec = _sharkSpecs[i];
      final double size = spec.size;
      final double length = baseLength * size;
      final double orbitRadius = minSide * randRange(r, 0.28, 0.4);
      final double a = (i / sharkCount) * tau + randRange(r, -0.4, 0.4);
      final int orbitDir = i % 2 == 0 ? 1 : -1;
      final double x = w / 2 + math.cos(a) * orbitRadius * (w / minSide) * 0.9;
      final double y = h / 2 + math.sin(a) * orbitRadius;
      final double heading = a + orbitDir * math.pi / 2;
      final Float32List nodes = Float32List(sharkNodes * 2);
      final double seg = length / (sharkNodes - 1);
      for (int n = 0; n < sharkNodes; n++) {
        nodes[n * 2] = x - math.cos(heading) * seg * n;
        nodes[n * 2 + 1] = y - math.sin(heading) * seg * n;
      }
      sharks.add(
        Shark(
          id: i + 1,
          kind: spec.kind,
          length: length,
          nodes: nodes,
          heading: heading,
          speed: 30,
          phase: randRange(r, 0, tau),
          turn: 0,
          hunger: randRange(r, 0.25, 0.75),
          wander: 0,
          orbitDir: orbitDir,
          orbitRadius: orbitRadius,
          retargetAt: 0,
          depth: math.min(1.0, size),
          scripted: false,
        ),
      );
    }

    final double megaLength = minSide * 1.15;
    final Float32List megaNodes = Float32List(sharkNodes * 2);
    for (int n = 0; n < sharkNodes; n++) {
      megaNodes[n * 2] = -megaLength * 2.4 - n;
      megaNodes[n * 2 + 1] = h * 0.5;
    }
    final Shark mega = Shark(
      id: 0,
      kind: SharkKind.greatHammer,
      length: megaLength,
      nodes: megaNodes,
      heading: 0,
      speed: 0,
      phase: randRange(r, 0, tau),
      turn: 0,
      hunger: 0,
      wander: 0,
      orbitDir: 1,
      orbitRadius: 0,
      retargetAt: 0,
      depth: 1,
      scripted: true,
    );
    _megashark = mega;
    sharks.add(mega);

    sharks.sort((Shark a, Shark b) => a.length.compareTo(b.length));

    final int total =
        _fishCount ??
        clampNum((w * h / 2000).roundToDouble(), 160, 620).toInt();
    fish = [];
    while (fish.length < total) {
      final int species = pickSpecies(r);
      final Species sp = speciesList[species];
      final int size = math.min(
        randInt(r, sp.schoolLo, sp.schoolHi),
        total - fish.length,
      );
      final int millDir = r.nextDouble() < 0.5 ? 1 : -1;
      final double cx = randRange(r, w * 0.06, w * 0.94);
      final double cy = randRange(r, h * 0.08, h * 0.92);

      final double dir =
          (r.nextDouble() < 0.5 ? 0.0 : math.pi) + randRange(r, -0.5, 0.5);
      for (int k = 0; k < size; k++) {
        fish.add(
          Fish(
            x:
                cx +
                randRange(r, -1, 1) *
                    _sepX[species] *
                    math.sqrt(size.toDouble()),
            y:
                cy +
                randRange(r, -1, 1) *
                    _sepY[species] *
                    math.sqrt(size.toDouble()) *
                    0.6,
            vx: math.cos(dir) * sp.cruise,
            vy: math.sin(dir) * sp.cruise,
            species: species,
            alarm: 0,
            alive: true,
            respawnAt: 0,
            phase: randRange(r, 0, tau),
            turn: 0,
            depth: randRange(r, 0.55, 1),
            millDir: millDir,
          ),
        );
      }
    }
    _bucketNext = Int32List(fish.length);
  }

  void splash(double x, double y) {
    events.add(WorldEvent(WorldEventKind.splash, x, y));
    const double radius = 240;
    for (final f in fish) {
      if (!f.alive) continue;
      final double dx = f.x - x;
      final double dy = f.y - y;
      final double d = _hypot(dx, dy);
      if (d > radius || d < 1e-3) continue;

      final double k = (1 - d / radius) * 260;
      f.vx += dx / d * k;
      f.vy += dy / d * k;
      f.alarm = 1;
    }
  }

  @override
  void step(double dt) {
    time += dt;
    _rebuildHash();
    _stepFish(dt);
    _stepSharks(dt);
    _stepMegashark(dt);
    _respawn();
  }

  void _rebuildHash() {
    final double size = _perception;
    const int pad = 2;
    _bucketCols = (width / size).ceil() + pad * 2;
    _bucketRows = (height / size).ceil() + pad * 2;
    final int n = _bucketCols * _bucketRows;
    if (_bucketHead.length != n) {
      _bucketHead = Int32List(n);
      _bucketCount = Uint16List(n);
    }
    _bucketHead.fillRange(0, _bucketHead.length, -1);
    _bucketCount.fillRange(0, _bucketCount.length, 0);
    if (_bucketNext.length != fish.length) {
      _bucketNext = Int32List(fish.length);
    }
    for (int i = 0; i < fish.length; i++) {
      final Fish f = fish[i];
      if (!f.alive) continue;
      final int b = _bucketOf(f.x, f.y);
      _bucketNext[i] = _bucketHead[b];
      _bucketHead[b] = i;
      _bucketCount[b]++;
    }
  }

  int _bucketOf(double x, double y) {
    final double size = _perception;
    final int c = _clampInt((x / size).floor() + 2, 0, _bucketCols - 1);
    final int r = _clampInt((y / size).floor() + 2, 0, _bucketRows - 1);
    return r * _bucketCols + c;
  }

  void _stepFish(double dt) {
    final math.Random r = _rng;
    final double w = width;
    final double h = height;
    final double simTime = time;
    final double range = _perception;
    final double range2 = range * range;
    final double foreignSep = _foreignSep;
    final double size = _perception;
    final int cols = _bucketCols;
    final int rows = _bucketRows;
    final List<int> head = _bucketHead;
    final List<int> next = _bucketNext;
    final Vec2 cur = _tmp;
    final double calmDecay = math.exp(-dt * 0.7);
    final double contagion = math.min(1.0, dt * 6);

    for (int i = 0; i < fish.length; i++) {
      final Fish f = fish[i];
      if (!f.alive) continue;
      final Species sp = speciesList[f.species];

      final double spread = 1 + 1.8 * f.alarm;
      final double fishSepX = _sepX[f.species] * spread;
      final double fishSepY = _sepY[f.species] * spread;

      final double speed = _hypotOr(f.vx, f.vy, 1);
      final double hx = f.vx / speed;
      final double hy = f.vy / speed;

      double ax = 0;
      double ay = 0;
      double sx = 0;
      double sy = 0;
      double avx = 0;
      double avy = 0;
      double cx = 0;
      double cy = 0;
      int n = 0;
      double neighbourAlarm = 0;

      final int bc = _clampInt((f.x / size).floor() + 2, 0, cols - 1);
      final int br = _clampInt((f.y / size).floor() + 2, 0, rows - 1);
      for (
        int row = math.max(0, br - 1);
        row <= math.min(rows - 1, br + 1);
        row++
      ) {
        for (
          int col = math.max(0, bc - 1);
          col <= math.min(cols - 1, bc + 1);
          col++
        ) {
          int j = head[row * cols + col];
          while (j != -1) {
            if (j != i) {
              final Fish o = fish[j];
              final double dx = o.x - f.x;
              final double dy = o.y - f.y;
              final double d2 = dx * dx + dy * dy;
              if (d2 < range2 && d2 > 1e-6) {
                final double d = math.sqrt(d2);

                if ((dx * hx + dy * hy) / d > blindCos) {
                  final double qx = dx / fishSepX;
                  final double qy = dy / fishSepY;
                  final double q2 = qx * qx + qy * qy;
                  if (q2 < 1) {
                    final double q = _sqrtOr(q2, 1e-3);
                    final double k = (1 - q) / q;
                    sx -= qx * k;
                    sy -= qy * k;
                  }
                  if (o.species == f.species) {
                    avx += o.vx;
                    avy += o.vy;
                    cx += dx;
                    cy += dy;
                    n++;
                  } else if (d < foreignSep) {
                    final double k = ((1 - d / foreignSep) / d) * 0.6;
                    sx -= dx * k;
                    sy -= dy * k;
                  }
                  if (o.alarm > neighbourAlarm) neighbourAlarm = o.alarm;
                }
              }
            }
            j = next[j];
          }
        }
      }

      ax += sx * fishSeparationK;
      ay += sy * fishSeparationK;
      if (n > 0) {
        final double alignK = fishAlignK * sp.align;
        final double cohesionK =
            fishCohesionK * sp.cohesion * (1 - 0.8 * f.alarm);
        ax += (avx / n - f.vx) * alignK + (cx / n) * cohesionK;
        ay += (avy / n - f.vy) * alignK + (cy / n) * cohesionK;
        if (sp.mill > 0) {
          final double cl = _hypotOr(cx, cy, 1);
          ax += -cy / cl * f.millDir * sp.mill * (1 - f.alarm);
          ay += cx / cl * f.millDir * sp.mill * (1 - f.alarm);
        }
      }

      double fear = 0;
      for (final sh in sharks) {
        final double fearR = sh.length * 0.6 + 60;
        double best = double.infinity;
        double bx = 0;
        double by = 0;
        for (int k = 0; k <= 12; k += 3) {
          final double nx = sh.nodes[k * 2];
          final double ny = sh.nodes[k * 2 + 1];
          final double px = f.x - nx;
          final double py = f.y - ny;
          final double d2 = px * px + py * py;
          if (d2 < best) {
            best = d2;
            bx = nx;
            by = ny;
          }
        }
        final double d = math.sqrt(best);
        if (d >= fearR || d < 1e-3) continue;
        double weight = 1 - d / fearR;
        weight *= weight;
        final double awayX = (f.x - bx) / d;
        final double awayY = (f.y - by) / d;

        final double shx = math.cos(sh.heading);
        final double shy = math.sin(sh.heading);
        final int side =
            shx * (f.y - sh.nodes[1]) - shy * (f.x - sh.nodes[0]) >= 0 ? 1 : -1;
        ax += (awayX * 0.7 - shy * side * 0.9) * fishFleeK * weight;
        ay += (awayY * 0.7 + shx * side * 0.9) * fishFleeK * weight;
        fear = math.max(fear, math.sqrt(weight));
      }

      if (pointer.active) {
        const double pr = 130;
        final double dx = f.x - pointer.x;
        final double dy = f.y - pointer.y;
        final double d = _hypot(dx, dy);
        if (d < pr && d > 1e-3) {
          final double relief = 1 - d / pr;
          final double weight = relief * relief;
          ax += dx / d * fishFleeK * weight;
          ay += dy / d * fishFleeK * weight;
          fear = math.max(fear, math.sqrt(weight) * 0.8);
        }
      }

      double alarm = math.max(f.alarm * calmDecay, fear);
      final double relayed = neighbourAlarm * 0.86;
      if (relayed > alarm) alarm += (relayed - alarm) * contagion;
      f.alarm = alarm;

      const double m = 36;
      if (f.x < m) {
        ax += (m - f.x) * 7;
      } else if (f.x > w - m) {
        ax -= (f.x - (w - m)) * 7;
      }
      if (f.y < m) {
        ay += (m - f.y) * 7;
      } else if (f.y > h - m) {
        ay -= (f.y - (h - m)) * 7;
      }

      currentAt(f.x, f.y, simTime, cur);
      ax += cur.x * 0.5 + (r.nextDouble() - 0.5) * sp.jitter;
      ay += cur.y * 0.5 + (r.nextDouble() - 0.5) * sp.jitter;

      ay -= f.vy * sp.verticalDrag * (1 - 0.7 * f.alarm);

      final double preferred = sp.cruise * (1 + 1.3 * f.alarm);
      ax += (preferred - speed) * hx * 1.6;
      ay += (preferred - speed) * hy * 1.6;

      final double before = math.atan2(f.vy, f.vx);
      f.vx += ax * dt;
      f.vy += ay * dt;
      final double maxSpeed = sp.maxSpeed * (1 + 1.8 * f.alarm);
      final double s = _hypot(f.vx, f.vy);
      if (s > maxSpeed) {
        f.vx *= maxSpeed / s;
        f.vy *= maxSpeed / s;
      } else if (s < sp.minSpeed && s > 1e-3) {
        f.vx *= sp.minSpeed / s;
        f.vy *= sp.minSpeed / s;
      }
      f.turn +=
          (angleDiff(before, math.atan2(f.vy, f.vx)) / dt - f.turn) *
          math.min(1.0, dt * 8);
      f.phase += dt * (7 + _hypot(f.vx, f.vy) * 0.12);
      f.x = clampNum(f.x + f.vx * dt, -60, w + 60);
      f.y = clampNum(f.y + f.vy * dt, -60, h + 60);
    }
  }

  void _stepSharks(double dt) {
    final math.Random r = _rng;
    final double w = width;
    final double h = height;
    final double simTime = time;
    final double minSide = math.min(w, h);
    final double centerX = w / 2;
    final double centerY = h / 2;

    for (final sh in sharks) {
      if (sh.scripted) continue;
      final double len = sh.length;
      final Float32List nodes = sh.nodes;
      final double hx = nodes[0];
      final double hy = nodes[1];

      sh.hunger = math.min(1.0, sh.hunger + dt * 0.03);

      double dx = math.cos(sh.heading);
      double dy = math.sin(sh.heading);

      sh.wander = clampNum(
        sh.wander + (r.nextDouble() - 0.5) * dt * 2.4,
        -0.9,
        0.9,
      );
      dx += math.cos(sh.heading + sh.wander) * 0.45;
      dy += math.sin(sh.heading + sh.wander) * 0.45;

      if (simTime >= sh.retargetAt) {
        sh.target = _findPrey(sh);
        sh.retargetAt = simTime + 0.45;
      }
      final Fish? t = sh.target;
      bool hunting = false;
      double closing = 0;
      if (t != null && t.alive && sh.hunger > 0.3) {
        final double tx = t.x + t.vx * 0.35 - hx;
        final double ty = t.y + t.vy * 0.35 - hy;
        final double d = _hypotOr(tx, ty, 1);
        final double weight = 1.4 + 2.6 * sh.hunger;
        dx += tx / d * weight;
        dy += ty / d * weight;
        hunting = true;
        closing = clampNum(1 - d / (len * 0.9), 0, 1);
      } else {
        final double rx = (hx - centerX) / (w / minSide);
        final double ry = hy - centerY;
        final double rr = _hypotOr(rx, ry, 1);
        final double radius =
            sh.orbitRadius * (1 + 0.15 * math.sin(simTime * 0.05 + sh.id));
        final double radial = clampNum((radius - rr) / radius, -1, 1);
        dx += ((-ry / rr) * sh.orbitDir + rx / rr * radial * 0.9) * 0.55;
        dy += ((rx / rr) * sh.orbitDir + ry / rr * radial * 0.9) * 0.55;
      }

      for (final other in sharks) {
        if (identical(other, sh)) continue;
        for (int k = 0; k < sharkNodes; k += 4) {
          final double ox = hx - other.nodes[k * 2];
          final double oy = hy - other.nodes[k * 2 + 1];
          final double d = _hypot(ox, oy);
          final double scope = (len + other.length) * 0.45;
          if (d < scope && d > 1e-3) {
            final double weight = (1 - d / scope) * 3;
            dx += ox / d * weight;
            dy += oy / d * weight;
          }
        }
      }

      final double ex = (hx - centerX) / (w * 0.3);
      final double ey = (hy - centerY) / (h * 0.16);
      final double e2 = ex * ex + ey * ey;
      if (e2 < 1) {
        final double e = _sqrtOr(e2, 1e-3);
        final double weight = (1 - e) * (hunting ? 1.0 : 2.5);
        dx += ex / e * weight;
        dy += ey / e * weight;
      }

      final double over = math.max(
        math.max(-hx, hx - w),
        math.max(-hy, hy - h),
      );
      if (over > -len * 0.05) {
        final double weight =
            clampNum((over + len * 0.05) / (len * 0.35), 0, 1) * 3.5;
        final double toX = centerX - hx;
        final double toY = centerY - hy;
        final double d = _hypotOr(toX, toY, 1);
        dx += toX / d * weight;
        dy += toY / d * weight;
      }

      final double desired = math.atan2(dy, dx);

      final double agility = math.min(
        hunting ? 1.4 + closing : 0.55,
        sh.speed / (len * 0.22),
      );
      final double maxTurn = agility * dt;
      final double turned = clampNum(
        angleDiff(sh.heading, desired),
        -maxTurn,
        maxTurn,
      );
      sh.heading += turned;
      sh.turn += (turned / dt - sh.turn) * math.min(1.0, dt * 3);

      final double cruise = 30 + len * 0.04;
      final double targetSpeed = hunting
          ? cruise * (1.45 + closing * 1.5)
          : cruise;
      sh.speed += (targetSpeed - sh.speed) * math.min(1.0, dt * 1.1);
      sh.phase += dt * (2 + sh.speed / 24);

      nodes[0] += math.cos(sh.heading) * sh.speed * dt;
      nodes[1] += math.sin(sh.heading) * sh.speed * dt;

      final double seg = len / (sharkNodes - 1);
      const double maxBend = 0.13;
      double prevAngle = sh.heading + math.pi;
      for (int k = 1; k < sharkNodes; k++) {
        final double px = nodes[(k - 1) * 2];
        final double py = nodes[(k - 1) * 2 + 1];
        double angle = math.atan2(nodes[k * 2 + 1] - py, nodes[k * 2] - px);
        angle =
            prevAngle +
            clampNum(angleDiff(prevAngle, angle), -maxBend, maxBend);
        nodes[k * 2] = px + math.cos(angle) * seg;
        nodes[k * 2 + 1] = py + math.sin(angle) * seg;
        prevAngle = angle;
      }

      if (sh.hunger > 0.15) {
        final double mouthR = len * 0.05 + 8;
        final double mx = nodes[0];
        final double my = nodes[1];
        for (final f in fish) {
          if (!f.alive) continue;
          final double fdx = f.x - mx;
          final double fdy = f.y - my;
          if (fdx * fdx + fdy * fdy < mouthR * mouthR) {
            f.alive = false;
            f.respawnAt = simTime + randRange(r, 3, 8);
            sh.hunger = math.max(0.0, sh.hunger - 0.16);
            events.add(WorldEvent(WorldEventKind.eat, f.x, f.y));
          }
        }
      }
    }
  }

  void _stepMegashark(double dt) {
    final Shark? m = _megashark;
    if (m == null) return;
    if (!_megasharkCrossing) {
      if (time < _megasharkAt) return;
      _launchMegashark();
    }

    final double w = width;
    final double len = m.length;
    final Float32List nodes = m.nodes;
    m.heading = _megasharkHeading + math.sin(time * 0.19) * 0.085;
    m.phase += dt * (1.1 + m.speed / 120);
    nodes[0] += math.cos(m.heading) * m.speed * dt;
    nodes[1] += math.sin(m.heading) * m.speed * dt;

    final double seg = len / (sharkNodes - 1);
    const double maxBend = 0.07;
    double prevAngle = m.heading + math.pi;
    for (int k = 1; k < sharkNodes; k++) {
      final double px = nodes[(k - 1) * 2];
      final double py = nodes[(k - 1) * 2 + 1];
      double angle = math.atan2(nodes[k * 2 + 1] - py, nodes[k * 2] - px);
      angle =
          prevAngle + clampNum(angleDiff(prevAngle, angle), -maxBend, maxBend);
      nodes[k * 2] = px + math.cos(angle) * seg;
      nodes[k * 2 + 1] = py + math.sin(angle) * seg;
      prevAngle = angle;
    }

    final bool gone = _megasharkDir == 1
        ? nodes[0] - len > w
        : nodes[0] + len < 0;
    if (gone) {
      _megasharkCrossing = false;
      _megasharkAt = time + megasharkPeriod;
    }
  }

  void _launchMegashark() {
    final Shark m = _megashark!;
    final double w = width;
    final double h = height;
    final double len = m.length;
    final bool fromLeft = _rng.nextDouble() < 0.5;
    _megasharkDir = fromLeft ? 1 : -1;
    _megasharkHeading = (fromLeft ? 0.0 : math.pi) + randRange(_rng, -0.1, 0.1);
    final double x = fromLeft ? -len * 1.1 : w + len * 1.1;
    final double y = randRange(_rng, h * 0.18, h * 0.88);
    final double seg = len / (sharkNodes - 1);
    m.heading = _megasharkHeading;
    m.speed = (w + len * 2.2) / megasharkCross;
    for (int n = 0; n < sharkNodes; n++) {
      m.nodes[n * 2] = x - math.cos(m.heading) * seg * n;
      m.nodes[n * 2 + 1] = y - math.sin(m.heading) * seg * n;
    }
    _megasharkCrossing = true;
  }

  Fish? _findPrey(Shark sh) {
    final double scope = sh.length * 0.9 + 160;
    final double hx = sh.nodes[0];
    final double hy = sh.nodes[1];
    final double fx = math.cos(sh.heading);
    final double fy = math.sin(sh.heading);
    Fish? best;
    double bestScore = double.infinity;
    double currentScore = double.infinity;

    for (final f in fish) {
      if (!f.alive) continue;
      final double dx = f.x - hx;
      final double dy = f.y - hy;
      final double d = _hypot(dx, dy);
      if (d > scope || d < 1e-3) continue;
      final double cos = (dx * fx + dy * fy) / d;
      if (cos < 0.2) continue;
      final int crowd = _bucketCount[_bucketOf(f.x, f.y)];
      final double score = d * (1 + (1 - cos) * 0.8) * (1 + crowd * 0.07);
      if (score < bestScore) {
        bestScore = score;
        best = f;
      }
      if (identical(f, sh.target)) currentScore = score;
    }

    final Fish? target = sh.target;
    if (target != null && currentScore < bestScore * 1.3) return target;
    return best;
  }

  void _respawn() {
    final math.Random r = _rng;
    final double w = width;
    final double h = height;
    final List<Fish> due = [];
    for (final f in fish) {
      if (!f.alive && f.respawnAt <= time) due.add(f);
    }
    if (due.isEmpty) return;
    if (due.length < 6 && time - _lastSpawn < 9) return;
    _lastSpawn = time;

    final int side = randInt(r, 0, 3);
    final double along = randRange(r, 0.15, 0.85);
    final double x = side == 0
        ? -20.0
        : side == 1
        ? w + 20
        : along * w;
    final double y = side == 2
        ? -20.0
        : side == 3
        ? h + 20
        : along * h;
    final double inward =
        math.atan2(h / 2 - y, w / 2 - x) + randRange(r, -0.5, 0.5);
    final int species = pickSpecies(r);
    final Species sp = speciesList[species];
    final int millDir = r.nextDouble() < 0.5 ? 1 : -1;
    for (final f in due.take(sp.schoolHi)) {
      f.alive = true;
      f.species = species;
      f.alarm = 0;
      f.turn = 0;
      f.millDir = millDir;
      f.x = x + randRange(r, -1, 1) * _perception;
      f.y = y + randRange(r, -1, 1) * _perception;
      f.vx = math.cos(inward) * sp.cruise * 1.4;
      f.vy = math.sin(inward) * sp.cruise * 1.4;
    }
  }
}
