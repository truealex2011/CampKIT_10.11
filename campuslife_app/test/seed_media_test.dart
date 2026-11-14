import 'dart:io';

import 'package:campuslife_app/data/database.dart';
import 'package:campuslife_app/data/seed.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'seed media covers every event and stays within the bundle budget',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await seedIfEmpty(db);
      final events = await db.select(db.events).get();
      final media = await db.select(db.eventMedia).get();
      expect(events, hasLength(21));
      expect(media.where((item) => item.kind == 'photo'), hasLength(63));
      expect(media.where((item) => item.kind == 'video'), hasLength(5));
      var totalBytes = 0;
      for (final event in events) {
        final items = media.where((item) => item.eventId == event.id).toList()
          ..sort((a, b) => a.position.compareTo(b.position));
        expect(items.take(3).map((item) => item.kind), everyElement('photo'));
        expect(
          items.map((item) => item.position),
          orderedEquals(List.generate(items.length, (i) => i)),
        );
        for (final item in items) {
          final file = File(item.path);
          expect(file.existsSync(), isTrue, reason: item.path);
          expect(file.lengthSync(), greaterThan(0));
          totalBytes += file.lengthSync();
          if (item.kind == 'video') {
            expect(item.durationMs, 4000);
            expect(item.previewPath, isNotNull);
            expect(File(item.previewPath!).existsSync(), isTrue);
          }
        }
      }
      expect(totalBytes, lessThanOrEqualTo(40 * 1024 * 1024));
      await seedIfEmpty(db);
      expect(await db.select(db.eventMedia).get(), hasLength(68));
    },
  );
}
