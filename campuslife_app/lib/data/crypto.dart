import 'dart:math';

final _random = Random.secure();

String hashSecret(String raw) {
  var a = 0x811c9dc5;
  var b = 0x01000193;
  final salted = 'campuslife:v1:$raw';
  for (final unit in salted.codeUnits) {
    a = ((a ^ unit) * 0x01000193) & 0xffffffff;
    b = ((b + unit) ^ a * 0x85ebca6b) & 0xffffffff;
  }
  final tail = salted.codeUnits.fold<int>(0x2545f491, (acc, unit) {
    return ((acc ^ unit) * 0xc2b2ae35) & 0xffffffff;
  });
  return '${a.toRadixString(16).padLeft(8, '0')}'
      '${b.toRadixString(16).padLeft(8, '0')}'
      '${tail.toRadixString(16).padLeft(8, '0')}';
}

String newId(String prefix) {
  final time = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final noise = _random.nextInt(0x7fffffff).toRadixString(36);
  return '$prefix-$time-$noise';
}

String randomInviteKey() {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  String block() => List.generate(
    4,
    (_) => alphabet[_random.nextInt(alphabet.length)],
  ).join();
  return 'CL-${block()}-${block()}';
}
