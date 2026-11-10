import 'dart:typed_data';

const int sharkNodes = 20;

enum SharkKind {
  classic('classic'),
  hammerhead('hammerhead'),
  zebra('zebra'),
  tiger('tiger'),
  greatHammer('greathammer'),
  mako('mako'),
  thresher('thresher'),
  nurse('nurse');

  const SharkKind(this.key);

  final String key;
}

class Fish {
  double x;
  double y;
  double vx;
  double vy;
  int species;

  double alarm;
  bool alive;
  double respawnAt;

  double phase;

  double turn;

  double depth;

  int millDir;

  Fish({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.species,
    required this.alarm,
    required this.alive,
    required this.respawnAt,
    required this.phase,
    required this.turn,
    required this.depth,
    required this.millDir,
  });
}

class Shark {
  final int id;
  SharkKind kind;
  double length;

  final Float32List nodes;
  double heading;
  double speed;

  double phase;

  double turn;
  double hunger;
  double wander;
  int orbitDir;
  double orbitRadius;
  Fish? target;
  double retargetAt;

  double depth;

  bool scripted;

  Shark({
    required this.id,
    required this.kind,
    required this.length,
    required this.nodes,
    required this.heading,
    required this.speed,
    required this.phase,
    required this.turn,
    required this.hunger,
    required this.wander,
    required this.orbitDir,
    required this.orbitRadius,
    required this.retargetAt,
    required this.depth,
    required this.scripted,
  });
}

enum WorldEventKind { eat, splash }

class WorldEvent {
  final WorldEventKind kind;
  final double x;
  final double y;

  const WorldEvent(this.kind, this.x, this.y);
}

class PointerState {
  double x = 0;
  double y = 0;
  bool active = false;
}

class SharkSpec {
  final SharkKind kind;
  final double size;

  const SharkSpec(this.kind, this.size);
}

abstract class OceanScene {
  double get time;
  double get width;
  double get height;
  List<Fish> get fish;
  List<Shark> get sharks;
  List<WorldEvent> get events;
  PointerState get pointer;

  void resize(double width, double height, double cellW, double cellH);

  void step(double dt);
}
