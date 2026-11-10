import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:campuslife_app/presentation/shared/ocean/renderer.dart';
import 'package:campuslife_app/presentation/shared/ocean/types.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class StillOcean implements OceanScene {
  StillOcean(this.width, this.height, this.sharks);
  @override
  final double width;
  @override
  final double height;
  @override
  final List<Shark> sharks;
  @override
  double time = 2.75;
  @override
  final fish = <Fish>[];
  @override
  final events = <WorldEvent>[];
  @override
  final pointer = PointerState();
  @override
  void resize(double w, double h, double cw, double ch) {}
  @override
  void step(double dt) {}
}

Shark referenceShark(SharkKind kind, double length, Float32List nodes) => Shark(
  id: 3,
  kind: kind,
  length: length,
  nodes: nodes,
  heading: 0,
  speed: 57,
  phase: 1.3,
  turn: -.35,
  hunger: 0,
  wander: 0,
  orbitDir: 1,
  orbitRadius: 0,
  retargetAt: 0,
  depth: .88,
  scripted: false,
);

void render(OceanRenderer renderer, OceanScene scene) {
  final recorder = ui.PictureRecorder();
  renderer.render(ui.Canvas(recorder), scene, 1 / 60);
  recorder.endRecording().dispose();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('OceanMono')
      ..addFont(rootBundle.load('assets/fonts/CascadiaMono.ttf'));
    await loader.load();
  });
  final fixtures =
      jsonDecode(File('test/fixtures/ocean_reference.json').readAsStringSync())
          as List;
  for (final fixture in fixtures) {
    test('HTML silhouette ${fixture['kind']} at ${fixture['width']}px', () {
      final w = (fixture['width'] as num).toDouble();
      final h = (fixture['height'] as num).toDouble();
      final kind = SharkKind.values.firstWhere((k) => k.key == fixture['kind']);
      final nodes = Float32List.fromList(
        (fixture['nodes'] as List)
            .cast<num>()
            .map((v) => v.toDouble())
            .toList(),
      );
      final scene = StillOcean(w, h, [
        referenceShark(kind, (fixture['length'] as num).toDouble(), nodes),
      ]);
      final renderer = OceanRenderer()..resize(w, h, 1);
      render(renderer, scene);
      final expected = fixture['cells'] as List;
      expect(
        renderer.sharkFlag.where((flag) => flag != 0).length,
        expected.length,
      );
      for (final cell in expected) {
        final i = cell[0] as int;
        expect(
          renderer.sharkFlag[i],
          cell[1],
          reason: 'body/fin/eye/mark cell $i',
        );
        expect(
          renderer.sharkShade[i],
          closeTo((cell[2] as num).toDouble(), 0.00001),
          reason: 'shade $i',
        );
        expect(renderer.sharkKey[i], cell[3], reason: 'skin glyph key $i');
      }
    });
  }

  test('render all eight species with local reference font', () async {
    final scene = StillOcean(800, 1120, []);
    for (var i = 0; i < SharkKind.values.length; i++) {
      const length = 310.0;
      final x = 375.0 + (i % 2) * 400;
      final y = 120.0 + (i ~/ 2) * 280;
      final nodes = Float32List(sharkNodes * 2);
      for (var k = 0; k < sharkNodes; k++) {
        nodes[k * 2] = x - length * k / (sharkNodes - 1);
        nodes[k * 2 + 1] = y;
      }
      scene.sharks.add(referenceShark(SharkKind.values[i], length, nodes));
    }
    final renderer = OceanRenderer()..resize(800, 1120, 1);
    final recorder = ui.PictureRecorder();
    renderer.render(ui.Canvas(recorder), scene, 1 / 60);
    final picture = recorder.endRecording();
    final image = await picture.toImage(800, 1120);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory('build/ocean_shots').createSync(recursive: true);
    File(
      'build/ocean_shots/species.png',
    ).writeAsBytesSync(png!.buffer.asUint8List());
    image.dispose();
    picture.dispose();
  });

  test('fish glyph stays in its cell and retains depth opacity', () async {
    final renderer = OceanRenderer()..resize(120, 80, 1);
    final scene = StillOcean(120, 80, []);
    scene.fish.add(
      Fish(
        x: 102,
        y: 28,
        vx: 0,
        vy: 0,
        species: 0,
        alarm: 0,
        alive: true,
        respawnAt: 0,
        phase: 0,
        turn: 0,
        depth: .55,
        millDir: 1,
      ),
    );
    final recorder = ui.PictureRecorder();
    renderer.render(ui.Canvas(recorder), scene, 1 / 60);
    final picture = recorder.endRecording();
    final image = await picture.toImage(120, 80);
    final bytes = (await image.toByteData())!;
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    File(
      'build/ocean_shots/fish.png',
    ).writeAsBytesSync(png!.buffer.asUint8List());
    // With the old 1000px paragraph, the fish was painted off-canvas.
    var darkest = 255;
    // y=28 is in row 4: its cell spans [28, 35), not [25, 32).
    for (var y = 28; y < 35; y++) {
      for (var x = 100; x < 105; x++) {
        final red = bytes.getUint8((y * 120 + x) * 4);
        if (red < darkest) darkest = red;
      }
    }
    expect(darkest, lessThan(220), reason: 'visible dash inside the fish cell');
    expect(darkest, greaterThan(60), reason: 'far fish must keep its alpha');
    image.dispose();
    picture.dispose();
  });

  test('water wakes are smaller, sparse, stable and absent on still water', () {
    final renderer = OceanRenderer()..resize(393, 852, 1);
    final scene = StillOcean(393, 852, []);
    render(renderer, scene);
    expect(renderer.dotKind.every((k) => k == 0), isTrue);
    expect(renderer.bucketCounts.reduce((a, b) => a + b), 0);
    renderer.energy.fillRange(0, renderer.energy.length, 1.2);
    render(renderer, scene);
    final visible = renderer.bucketCounts.reduce((a, b) => a + b);
    expect(visible, greaterThan(renderer.energy.length * .25));
    expect(visible, lessThan(renderer.energy.length * .4));
    final positions = renderer.bucketOf.toList();
    render(renderer, scene);
    expect(
      renderer.bucketOf,
      positions,
      reason: 'thinning must not sparkle randomly each frame',
    );
  });
}
