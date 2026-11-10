import 'dart:math' as math;

import 'package:campuslife_app/presentation/shared/ocean/ocean_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('opposite headings preserve the HTML turn direction', () {
    expect(angleDiff(0, -math.pi), -math.pi);
    expect(angleDiff(0, math.pi), math.pi);
    expect(angleDiff(0, -3 * math.pi), -math.pi);
    expect(angleDiff(0, 3 * math.pi), math.pi);
  });
}
