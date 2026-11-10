import 'package:campuslife_app/app/app.dart';
import 'package:campuslife_app/app/di.dart';
import 'package:campuslife_app/presentation/entry/auth_card.dart';
import 'package:campuslife_app/presentation/entry/entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_repository.dart';

Future<void> boot(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(FakeCampusLifeRepository()),
      ],
      child: const CampusLifeApp(),
    ),
  );
  await frames(tester);
}

// Ocean animation never settles, so advance a bounded number of frames.
Future<void> frames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Finder get entryScroll => find
    .descendant(
      of: find.byType(EntryScreen),
      matching: find.byType(SingleChildScrollView),
    )
    .first;

void noCredit() {
  expect(find.textContaining('stackedlol'), findsNothing);
  expect(find.textContaining('Анимация океана'), findsNothing);
}

void main() {
  for (final size in [
    const Size(390, 844),
    const Size(390, 1000),
    const Size(320, 568),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    testWidgets('entry and signup remain reachable at $size', (tester) async {
      await boot(tester, size);
      noCredit();
      final viewport = tester.getRect(entryScroll);
      final top = tester.getTopLeft(find.byType(Eyebrow)).dy;
      final bottom = tester.getBottomLeft(find.byType(AuthCard)).dy;
      if (bottom - top < viewport.height - 34) {
        // Scroll padding is 8 above and 26 below.
        final expected = viewport.center.dy - 9;
        expect(((top + bottom) / 2 - expected).abs(), lessThan(2));
      }
      await tester.ensureVisible(find.text('Регистрация'));
      await tester.tap(find.text('Регистрация'));
      await frames(tester);
      noCredit();
      await tester.ensureVisible(find.text('Создать аккаунт'));
      await frames(tester);
      await tester.tap(find.text('Создать аккаунт'));
      await frames(tester);
      expect(find.text('Имя и фамилия'), findsOneWidget);
      // Keyboard must not produce negative minimum constraints or overflow.
      tester.view.viewInsets = FakeViewPadding(bottom: size.height * .65);
      await frames(tester);
      await tester.ensureVisible(find.text('Создать аккаунт'));
      await frames(tester);
      tester.view.viewInsets = FakeViewPadding.zero;
      await frames(tester);
      await tester.ensureVisible(find.text('Организатор'));
      await tester.tap(find.text('Организатор'));
      await frames(tester);
      await tester.ensureVisible(find.text('Вступить по id'));
      await tester.tap(find.text('Вступить по id'));
      await frames(tester);
      await tester.ensureVisible(find.text('Отправить заявку'));
      await frames(tester);
      await tester.ensureVisible(find.text('Вход'));
      await tester.tap(find.text('Вход'));
      await frames(tester);
      expect(find.text('ПОЧТА ИЛИ ТЕЛЕФОН'), findsOneWidget);
      noCredit();
    });
  }
}
