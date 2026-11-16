import 'package:campuslife_app/app/di.dart';
import 'package:campuslife_app/app/theme.dart';
import 'package:campuslife_app/domain/entities.dart';
import 'package:campuslife_app/presentation/feed/feed_screen.dart';
import 'package:campuslife_app/presentation/shared/fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<FakeCampusLifeRepository> boot(
    WidgetTester tester,
    double width,
  ) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = FakeCampusLifeRepository()
      ..session = const User(
        id: 'usr_stu',
        name: 'Аня',
        email: 'student@campus.ru',
        phone: '',
        role: UserRole.participant,
      );
    final container = ProviderContainer(
      overrides: [repositoryProvider.overrideWithValue(repo)],
    );
    container.read(sessionProvider.notifier).replace(repo.session);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildDarkTheme(), home: const FeedScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    return repo;
  }

  for (final width in [320.0, 360.0, 412.0]) {
    testWidgets('rail centers align and caption fits at $width', (
      tester,
    ) async {
      await boot(tester, width);
      final icons = [
        Icons.notifications_none_rounded,
        Icons.article_outlined,
        Icons.share_outlined,
        Icons.flag_outlined,
      ];
      final centers = icons
          .map((icon) => tester.getCenter(find.byIcon(icon).first).dx)
          .toList();
      final heart = tester.getCenter(find.byType(FishHeartIcon).first).dx;
      for (final x in centers) {
        expect(x, closeTo(heart, 0.1));
      }
      expect(tester.takeException(), isNull);
      final caption = tester.getRect(find.text('Студенческая гостиная').first);
      expect(caption.right, lessThan(width - Scale.railWidth));
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('rail remains visible in a short viewport', (tester) async {
    await boot(tester, 320);
    tester.view.physicalSize = const Size(320, 480);
    await tester.pump();
    final top = tester.getRect(find.byIcon(Icons.notifications_none_rounded).first);
    final bottom = tester.getRect(find.byIcon(Icons.flag_outlined).first);
    expect(top.top, greaterThanOrEqualTo(0));
    expect(bottom.bottom, lessThanOrEqualTo(480));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('cancel after crossing rail never registers', (tester) async {
    final repo = await boot(tester, 320);
    final before = repo.regs.length;
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(FishHeartIcon).first),
    );
    await tester.pump(const Duration(milliseconds: 1020));
    await tester.pump();
    await gesture.moveBy(const Offset(-140, 0));
    await tester.pump();
    await gesture.cancel();
    await tester.pump(const Duration(seconds: 1));
    expect(repo.regs.length, before);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'heart hold arms at one second and releases without registration',
    (tester) async {
      final repo = await boot(tester, 320);
      final before = repo.regs.length;
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(FishHeartIcon).first),
      );
      await tester.pump(const Duration(milliseconds: 900));
      expect(
        tester
            .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
            .where((w) => w.opacity == 1)
            .length,
        lessThan(5),
      );
      await tester.pump(const Duration(milliseconds: 120));
      await tester.pump();
      final track = find.text('ЗАПИСАТЬСЯ').first;
      expect(tester.getRect(track).left, greaterThanOrEqualTo(0));
      await gesture.up();
      await tester.pump(const Duration(seconds: 1));
      expect(repo.regs.length, before);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
