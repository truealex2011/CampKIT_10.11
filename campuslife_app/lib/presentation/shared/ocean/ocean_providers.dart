import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'types.dart';
import 'world.dart';

abstract final class OceanRoster {
  static const List<SharkSpec> defaultSpecs = [
    SharkSpec(SharkKind.classic, 1.5),
    SharkSpec(SharkKind.tiger, 1.18),
    SharkSpec(SharkKind.mako, 1.02),
    SharkSpec(SharkKind.hammerhead, 0.88),
    SharkSpec(SharkKind.zebra, 0.78),
    SharkSpec(SharkKind.nurse, 0.72),
    SharkSpec(SharkKind.mako, 0.66),
  ];
}

final oceanRosterProvider = Provider<List<SharkSpec>>(
  (ref) => OceanRoster.defaultSpecs,
);

final oceanWorldProvider = Provider<World>(
  (ref) => World(sharkSpecs: OceanRoster.defaultSpecs),
);
