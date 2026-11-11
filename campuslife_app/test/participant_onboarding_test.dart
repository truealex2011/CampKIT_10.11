import 'package:campuslife_app/presentation/onboarding/participant_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Harness {
  _Harness(this.tester);

  final WidgetTester tester;
  final List<ParticipantOnboardingResult> results =
      <ParticipantOnboardingResult>[];

  Future<void> boot({
    Size size = const Size(400, 900),
    bool reduce = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            final MediaQueryData data = MediaQuery.of(context).copyWith(
              disableAnimations: reduce,
            );
            return MediaQuery(
              data: data,
              child: Scaffold(
                body: SafeArea(
                  minimum: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                  child: ParticipantOnboarding(onFinished: results.add),
                ),
              ),
            );
          },
        ),
      ),
    );
    await settle();
  }

  Future<void> settle() async {
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump(const Duration(milliseconds: 450));
  }

  Future<void> start() async {
    await tester.tap(find.text('Попробовать'));
    await settle();
  }

  Future<void> swipeUp() async {
    await tester.fling(find.text('Открытие CampusLife').first, const Offset(0, -300), 900);
    await settle();
  }

  Future<void> swipeMedia() async {
    await tester.fling(find.text('Вечер студенческих идей').first, const Offset(-300, 0), 900);
    await settle();
  }

  Future<void> next() async {
    await tester.tap(find.text('Далее'));
    await settle();
  }

  Finder get fish => find.bySemanticsLabel('Рыбка: избранное и запись на событие');

  Future<void> tapFish() async {
    await tester.tap(fish);
    await settle();
  }

  Future<void> tapAndHoldFish() async {
    await tester.longPress(fish);
    await settle();
  }

  Future<void> openSheet(String label) async {
    await tester.tap(find.bySemanticsLabel(label));
    await settle();
  }
}

void main() {
  testWidgets('демонстрация не завершает первый шаг', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Открытие CampusLife'), findsWidgets);
    expect(find.text('Вечер студенческих идей'), findsNothing);
  });

  testWidgets('свайп вверх открывает второе событие', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeUp();
    expect(find.text('Вечер студенческих идей'), findsWidgets);
  });

  testWidgets('короткий тап по рыбке не записывает на событие', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeUp();
    await h.swipeMedia();
    await h.next();
    await h.tapFish();
    await h.next();
    await h.tapFish();
    expect(find.text('Ты записан. Билет в профиле'), findsNothing);
  });

  testWidgets('удержание и движение выполняют запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeUp();
    await h.swipeMedia();
    await h.next();
    await h.tapFish();
    await h.next();
    final Offset start = tester.getCenter(h.fish);
    final TestGesture gesture = await tester.startGesture(start);
    await tester.pump(const Duration(milliseconds: 1200));
    await gesture.moveBy(const Offset(-120, 0));
    await tester.pump(const Duration(milliseconds: 80));
    await gesture.up();
    await h.settle();
    expect(find.text('Ты записан. Билет в профиле'), findsWidgets);
  });

  testWidgets('отпускание до порога отменяет запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeUp();
    await h.swipeMedia();
    await h.next();
    await h.tapFish();
    await h.next();
    final Offset start = tester.getCenter(h.fish);
    final TestGesture gesture = await tester.startGesture(start);
    await tester.pump(const Duration(milliseconds: 1200));
    await gesture.moveBy(const Offset(-18, 0));
    await tester.pump(const Duration(milliseconds: 80));
    await gesture.up();
    await h.settle();
    expect(find.text('Ты записан. Билет в профиле'), findsNothing);
  });

  testWidgets('пропуск даёт skipped ровно один раз', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await tester.tap(find.text('Пропустить').first);
    await tester.pump();
    await tester.pump();
    expect(h.results, <ParticipantOnboardingResult>[
      ParticipantOnboardingResult.skipped,
    ]);
  });

  testWidgets('reduced motion не оставляет непрерывных анимаций', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot(reduce: true);
    await h.start();
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(find.text('Сменить событие'), findsWidgets);
  });

  testWidgets('поиск находит «День робототехники» по запросу «робо»', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot(size: const Size(390, 844));
    await h.start();
    await h.swipeUp();
    await h.swipeMedia();
    await h.next();
    await h.tapFish();
    await h.next();
    final Offset start = tester.getCenter(h.fish);
    final TestGesture gesture = await tester.startGesture(start);
    await tester.pump(const Duration(milliseconds: 1200));
    await gesture.moveBy(const Offset(-120, 0));
    await tester.pump(const Duration(milliseconds: 80));
    await gesture.up();
    await h.settle();
    await h.next();
    await h.openSheet('Напомнить о событии');
    await tester.tap(find.text('За час'));
    await h.settle();
    await h.next();
    await h.openSheet('Описание события');
    await tester.tap(find.text('Понятно'));
    await h.settle();
    await h.next();
    await h.openSheet('Поделиться событием');
    await tester.tap(find.text('Скопировать учебную ссылку'));
    await h.settle();
    await h.next();
    await h.openSheet('Пожаловаться на событие');
    await tester.tap(find.text('Неверная информация'));
    await h.settle();
    await tester.tap(find.text('Отправить учебную жалобу'));
    await h.settle();
    await h.next();
    await tester.tap(find.bySemanticsLabel('Поиск'));
    await h.settle();
    await tester.enterText(find.byType(TextField), 'робо');
    await h.settle();
    expect(find.text('День робототехники'), findsWidgets);
  });
}
