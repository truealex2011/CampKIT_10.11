import 'dart:math' as math;

const double tau = math.pi * 2;

const int _two32 = 0x100000000;
const int _sign32 = 0x80000000;

int _mod32(int v) {
  final m = v.remainder(_two32);
  return m < 0 ? m + _two32 : m;
}

int s32(int v) {
  final m = _mod32(v);
  return m >= _sign32 ? m - _two32 : m;
}

int u32(int v) => _mod32(v);

int and32(int a, int b) => _mod32(s32(a) & s32(b));

int xor32(int a, int b) => _mod32(s32(a) ^ s32(b));

int shr32(int a, int n) => (u32(a) / (1 << n)).floor();

int shl32(int a, int n) => _mod32(s32(a) * (1 << n));

int imul32(int a, int b) {
  final a0 = and32(a, 0xFFFF);
  final a1 = shr32(a, 16);
  final b0 = and32(b, 0xFFFF);
  final b1 = shr32(b, 16);

  return s32(a0 * b0 + (a1 * b0 + a0 * b1) * 65536);
}

double clampNum(double v, double lo, double hi) => v < lo
    ? lo
    : v > hi
    ? hi
    : v;

double randRange(math.Random r, double lo, double hi) =>
    lo + r.nextDouble() * (hi - lo);

int randInt(math.Random r, int lo, int hi) =>
    (lo + r.nextDouble() * (hi - lo + 1)).floor();

double smoothstep(double e0, double e1, double x) {
  final t = clampNum((x - e0) / (e1 - e0), 0, 1);
  return t * t * (3 - 2 * t);
}

double angleDiff(double a, double b) {
  // JavaScript uses signed remainder, including the exact -PI turn.
  var d = (b - a).remainder(tau);
  if (d > math.pi) {
    d -= tau;
  } else if (d < -math.pi) {
    d += tau;
  }
  return d;
}

double hash3(int x, int y, int z) {
  var h = imul32(x, 374761393) ^ imul32(y, 668265263) ^ imul32(z, 1442695041);
  h = imul32(xor32(h, shr32(h, 13)), 1274126177);
  h = xor32(h, shr32(h, 16));
  return u32(h) / _two32;
}

class Vec2 {
  double x;
  double y;

  Vec2(this.x, this.y);

  void setTo(double nx, double ny) {
    x = nx;
    y = ny;
  }
}

const double _k1 = 1 / 260;
const double _k2 = 1 / 310;
const double _k3 = 1 / 190;
const double _currentScale = 3400;

void currentAt(double x, double y, double t, Vec2 out) {
  final a = x * _k1 + t * 0.07;
  final b = y * _k2 - t * 0.05;
  final c = (x + y) * _k3 + t * 0.11;
  out.setTo(
    (-_k2 * math.sin(a) * math.sin(b) + 0.5 * _k3 * math.cos(c)) *
        _currentScale,
    (-_k1 * math.cos(a) * math.cos(b) - 0.5 * _k3 * math.cos(c)) *
        _currentScale,
  );
}
