import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('reference font keeps skin and fin glyphs on one grid line', () async {
    final loader = FontLoader('OceanMono')
      ..addFont(rootBundle.load('assets/fonts/CascadiaMono.ttf'));
    await loader.load();
    for (final cellWidth in [5.0, 7.0, 8.0]) {
      final cellHeight = (cellWidth * 1.45).roundToDouble();
      for (final glyph in ':;t%SX8#@o-'.split('')) {
        final builder =
            ui.ParagraphBuilder(
                ui.ParagraphStyle(
                  textDirection: ui.TextDirection.ltr,
                  textAlign: ui.TextAlign.center,
                ),
              )
              ..pushStyle(
                ui.TextStyle(
                  fontFamily: 'OceanMono',
                  fontSize: (cellHeight * .88).roundToDouble(),
                  fontWeight: ui.FontWeight.w600,
                ),
              )
              ..addText(glyph);
        final p = builder.build()
          ..layout(ui.ParagraphConstraints(width: cellWidth));
        expect(p.computeLineMetrics(), hasLength(1), reason: glyph);
        expect(p.longestLine, lessThanOrEqualTo(cellWidth), reason: glyph);
        expect(p.height, lessThanOrEqualTo(cellHeight + 1), reason: glyph);
        p.dispose();
      }
    }
  });
}
