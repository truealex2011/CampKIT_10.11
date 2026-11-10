import 'package:campuslife_app/presentation/shared/ocean/ocean_view.dart';
import 'package:campuslife_app/presentation/shared/ocean/types.dart';
import 'package:campuslife_app/presentation/shared/ocean/world.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ocean ticker advances simulation', (tester) async {
    tester.view.physicalSize = const Size(393 * 3, 852 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final world = World(
      sharkSpecs: const [SharkSpec(SharkKind.classic, 1.5)],
      fishCount: 200,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: OceanView(scene: world)),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(world.time, greaterThan(0));
    expect(world.fish, isNotEmpty);
    expect(world.sharks, isNotEmpty);
    expect(world.sharks.first.length, 315);
    expect(world.sharks.last.length, closeTo(393 * 1.15, 0.001));
  });

  testWidgets('touch splashes without leaving a permanent avoidance point', (
    tester,
  ) async {
    final world = World(fishCount: 0);
    var splashes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: OceanView(scene: world, onSplash: (_, _) => splashes++),
      ),
    );
    await tester.tapAt(const Offset(40, 40));
    await tester.pump();
    expect(splashes, 1);
    expect(world.pointer.active, isFalse);
  });
}
