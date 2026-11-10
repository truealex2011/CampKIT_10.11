import 'dart:io';
import 'dart:ui' as ui;

import 'package:campuslife_app/app/theme.dart';
import 'package:campuslife_app/presentation/shared/fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = GlobalKey();

void main() {
  const dir = 'build/test_shots';

  setUpAll(() {
    Directory(dir).createSync(recursive: true);
  });

  Future<void> shoot(WidgetTester tester, String name) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(_key),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      File('$dir/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets('fish art sheet', (tester) async {
    tester.view.physicalSize = const Size(520 * 2, 780 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      RepaintBoundary(
        key: _key,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          home: const _Sheet(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await shoot(tester, 'fish_art_1');
    await tester.pump(const Duration(milliseconds: 520));
    await shoot(tester, 'fish_art_2');
  });
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Palette.paper,
    body: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'РЫБЬЯ ГРАФИКА',
            style: Fonts.sansStyle(size: 18, weight: 700),
          ),
          const SizedBox(height: 22),
          _label('лайк: outline / filled / на тёмной кнопке'),
          const SizedBox(height: 10),
          Row(
            children: [
              const FishHeartIcon(
                size: 56,
                color: Palette.ink,
                heartColor: Palette.rose,
              ),
              const SizedBox(width: 26),
              const FishHeartIcon(
                size: 56,
                filled: true,
                color: Palette.accent,
                heartColor: Palette.paper,
              ),
              const SizedBox(width: 26),
              _dark(
                72,
                const FishHeartIcon(
                  size: 40,
                  filled: true,
                  color: Colors.white,
                  heartColor: Palette.rose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          _label('загрузка: экран 80 / кнопка 16 / шторка 40'),
          const SizedBox(height: 10),
          Row(
            children: [
              const FishLoader(size: 80),
              const SizedBox(width: 26),
              _dark(56, const FishLoader(size: 16, color: Palette.paper)),
              const SizedBox(width: 26),
              const FishLoader(size: 40),
            ],
          ),
          const SizedBox(height: 26),
          _label('пустое состояние: стайка'),
          const SizedBox(height: 6),
          const FishSchool(size: 120),
          const SizedBox(height: 20),
          _label('всплеск при записи: 0.2 / 0.45 / 0.75'),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final p in [0.2, 0.45, 0.75]) ...[
                _dark(
                  88,
                  CustomPaint(
                    size: const Size.square(72),
                    painter: SplashPainter(
                      progress: p,
                      color: Palette.darkAccent,
                    ),
                  ),
                ),
                if (p != 0.75) const SizedBox(width: 20),
              ],
            ],
          ),
        ],
      ),
    ),
  );

  static Widget _label(String text) =>
      Text(text, style: Fonts.sansStyle(size: 12, color: Palette.muted));

  static Widget _dark(double side, Widget child) => Container(
    width: side,
    height: side,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Palette.darkPaper,
      borderRadius: BorderRadius.circular(side * 0.28),
    ),
    child: child,
  );
}