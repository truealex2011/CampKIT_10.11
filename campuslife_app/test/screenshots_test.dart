import 'dart:io';
import 'dart:ui' as ui;

import 'package:campuslife_app/app/app.dart';
import 'package:campuslife_app/app/di.dart';
import 'package:campuslife_app/domain/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_repository.dart';

final _boundaryKey = GlobalKey();

void main() {
  const dir = 'build/test_shots';

  setUpAll(() {
    Directory(dir).createSync(recursive: true);
    for (final f in Directory(dir).listSync()) {
      if (f is File) f.deleteSync();
    }
  });

  Future<void> boot(WidgetTester tester, {User? session}) async {
    tester.view.physicalSize = const Size(393 * 3, 852 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    final repo = FakeCampusLifeRepository()..session = session;
    await tester.pumpWidget(
      RepaintBoundary(
        key: _boundaryKey,
        child: ProviderScope(
          overrides: [repositoryProvider.overrideWithValue(repo)],
          child: const CampusLifeApp(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 900));
  }

  Future<void> settle(WidgetTester tester, {int frames = 6}) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  Future<void> shoot(WidgetTester tester, String name) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(_boundaryKey),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      File('$dir/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
      image.dispose();
    });
  }

  const student = User(
    id: 'usr_stu',
    name: 'Аня Морозова',
    email: 'student@campus.ru',
    phone: '+7 900 000-00-03',
    role: UserRole.participant,
  );
  const organizer = User(
    id: 'usr_org',
    name: 'Пётр Крылов',
    email: 'organizer@campus.ru',
    phone: '+7 900 000-00-02',
    role: UserRole.organizer,
  );
  const admin = User(
    id: 'usr_admin',
    name: 'Ирина Соколова',
    email: 'admin@campus.ru',
    phone: '+7 900 000-00-01',
    role: UserRole.admin,
  );

  Future<void> goTo(WidgetTester tester, IconData icon) async {
    await tester.tap(find.byIcon(icon).first);
    await settle(tester);
  }

  Future<void> tab(WidgetTester tester, String label) async {
    await tester.tap(find.text(label).first);
    await settle(tester);
  }

  testWidgets('entry', (tester) async {
    await boot(tester);
    await shoot(tester, '01_entry');
    await tab(tester, 'Вход');
    await shoot(tester, '02_entry_login');
  });

  testWidgets('signup flow', (tester) async {
    await boot(tester);
    await tab(tester, 'Регистрация');
    expect(find.text('ИМЯ И ФАМИЛИЯ'), findsOneWidget);
    await shoot(tester, '03_signup_member');
    await tab(tester, 'Организатор');
    expect(find.text('Создать организацию'), findsOneWidget);
    await shoot(tester, '04_signup_org');
    await tab(tester, 'Вступить по id');
    expect(find.text('ID ОРГАНИЗАЦИИ'), findsOneWidget);
    await shoot(tester, '05_signup_join');
    await tab(tester, 'Вход');
    expect(find.text('ПОЧТА ИЛИ ТЕЛЕФОН'), findsOneWidget);
  });

  testWidgets('feed, sheet, search, profile', (tester) async {
    await boot(tester, session: student);
    await shoot(tester, '10_feed');
    await tester.tap(find.byIcon(Icons.article_outlined).first);
    await settle(tester);
    await shoot(tester, '11_event_sheet');
    await tester.tapAt(const Offset(196, 100));
    await settle(tester);
    expect(find.text('детали'), findsNothing);
    await goTo(tester, Icons.search_rounded);
    await shoot(tester, '12_search');
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await settle(tester);
    await goTo(tester, Icons.person_rounded);
    await shoot(tester, '13_profile');
  });

  testWidgets('organizer console', (tester) async {
    await boot(tester, session: organizer);
    await shoot(tester, '20_org_events');
    await tab(tester, 'Заявки');
    await shoot(tester, '21_org_requests');
    await tab(tester, 'Статистика');
    await shoot(tester, '22_org_stats');
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await settle(tester);
    await shoot(tester, '23_wizard');
  });

  testWidgets('admin console', (tester) async {
    await boot(tester, session: admin);
    await shoot(tester, '30_admin_moderation');
    await tab(tester, 'Управление');
    await shoot(tester, '31_admin_manage');
    await tab(tester, 'Жалобы');
    await shoot(tester, '32_admin_reports');
    await tab(tester, 'Ключи');
    await shoot(tester, '33_admin_keys');
  });
}
