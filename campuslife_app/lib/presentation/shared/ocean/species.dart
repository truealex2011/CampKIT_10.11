import 'dart:math' as math;

class Species {
  final String name;
  final double cruise;
  final double maxSpeed;
  final double minSpeed;

  final int weight;
  final int schoolLo;
  final int schoolHi;

  final double spacingX;
  final double spacingY;

  final double align;
  final double cohesion;
  final double jitter;

  final double mill;

  final double verticalDrag;

  const Species({
    required this.name,
    required this.cruise,
    required this.maxSpeed,
    required this.minSpeed,
    required this.weight,
    required this.schoolLo,
    required this.schoolHi,
    required this.spacingX,
    required this.spacingY,
    required this.align,
    required this.cohesion,
    required this.jitter,
    required this.mill,
    required this.verticalDrag,
  });
}

const List<Species> speciesList = [
  Species(
    name: 'sardine',
    cruise: 36,
    maxSpeed: 64,
    minSpeed: 18,
    weight: 3,
    schoolLo: 18,
    schoolHi: 28,
    spacingX: 1.8,
    spacingY: 1.1,
    align: 1.6,
    cohesion: 1.6,
    jitter: 40,
    mill: 70,
    verticalDrag: 0.5,
  ),
  Species(
    name: 'anchovy',
    cruise: 46,
    maxSpeed: 78,
    minSpeed: 22,
    weight: 3,
    schoolLo: 20,
    schoolHi: 32,
    spacingX: 1.5,
    spacingY: 1,
    align: 3.2,
    cohesion: 0.45,
    jitter: 30,
    mill: 0,
    verticalDrag: 1.4,
  ),
  Species(
    name: 'silverside',
    cruise: 40,
    maxSpeed: 70,
    minSpeed: 20,
    weight: 3,
    schoolLo: 12,
    schoolHi: 20,
    spacingX: 2,
    spacingY: 1.1,
    align: 2.4,
    cohesion: 1.1,
    jitter: 35,
    mill: 0,
    verticalDrag: 1.6,
  ),
  Species(
    name: 'mackerel',
    cruise: 32,
    maxSpeed: 60,
    minSpeed: 16,
    weight: 2,
    schoolLo: 5,
    schoolHi: 9,
    spacingX: 2.6,
    spacingY: 1.3,
    align: 2,
    cohesion: 0.9,
    jitter: 25,
    mill: 0,
    verticalDrag: 2,
  ),
  Species(
    name: 'goby',
    cruise: 26,
    maxSpeed: 56,
    minSpeed: 10,
    weight: 1,
    schoolLo: 8,
    schoolHi: 12,
    spacingX: 1.4,
    spacingY: 1.1,
    align: 0.35,
    cohesion: 1.4,
    jitter: 110,
    mill: 0,
    verticalDrag: 0.3,
  ),
];

const int _totalWeight = 12;

int pickSpecies(math.Random r) {
  var roll = r.nextDouble() * _totalWeight;
  for (var i = 0; i < speciesList.length; i++) {
    roll -= speciesList[i].weight;
    if (roll <= 0) return i;
  }
  return 0;
}
