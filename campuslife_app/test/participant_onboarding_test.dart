import 'package:campuslife_app/presentation/onboarding/participant_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Harness {
  _Harness(this.tester);

  final WidgetTester tester;
  final List<ParticipantOnboardingResult> results =
      <ParticipantOnboardingResult>[];

  Future<void> boot({
    Size size = const Size(390, 844),
    bool reduce = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduce),
              child: Scaffold(
                body: ParticipantOnboarding(onFinished: results.add),
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
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> tapLabel(String label) async {
    await tester.tap(find.bySemanticsLabel(label).last);
    await settle();
  }

  Future<void> tapText(String text) async {
    await tester.tap(find.text(text).last);
    await settle();
  }

  Future<void> start() async {
    await tapText('Попробовать');
  }

  Future<void> swipeUp() async {
    await tester.fling(find.byType(PageView).first, const Offset(0, -320), 900);
    await settle();
  }

  Future<void> swipeMedia() async {
    await tester.fling(find.byType(PageView).last, const Offset(-320, 0), 900);
    await settle();
  }

  Future<void> holdFish({double dx = -140}) async {
    final Offset center =
        tester.getCenter(find.bySemanticsLabel('Рыбка: удержание и свайп влево для записи'));
    final TestGesture gesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 1200));
    await gesture.moveBy(Offset(dx, 0));
    await tester.pump(const Duration(milliseconds: 80));
    await gesture.up();
    await settle();
  }
}

void main() {
  testWidgets('демонстрация не завершает шаг ленты', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await tester.pump(const Duration(seconds: 3));
    expect(find.bySemanticsLabel('Сменить событие'), findsWidgets);
  });

  testWidgets('свайп вверх открывает второе событие', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeUp();
    expect(find.text('Вечер студенческих идей'), findsWidgets);
  });

  testWidgets('короткий тап по рыбке не выполняет запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.tapLabel('Открыть второе событие');
    await h.tapLabel('Следующее медиа');
    await h.tapLabel('Рыбка: добавить в избранное');
    await h.tapLabel('Далее');
    await h.tapLabel('Рыбка: удержание и свайп влево для записи');
    expect(find.text('Ты записан'), findsNothing);
  });

  testWidgets('удержание и движение выполняют запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.tapLabel('Открыть второе событие');
    await h.tapLabel('Следующее медиа');
    await h.tapLabel('Рыбка: добавить в избранное');
    await h.tapLabel('Далее');
    await h.holdFish();
    expect(find.text('Далее'), findsWidgets);
  });

  testWidgets('отпускание до порога отменяет запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.tapLabel('Открыть второе событие');
    await h.tapLabel('Следующее медиа');
    await h.tapLabel('Рыбка: добавить в избранное');
    await h.tapLabel('Далее');
    await h.holdFish(dx: -14);
    expect(find.text('Далее'), findsNothing);
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

  testWidgets('reduced motion не оставляет непрерывной анимации', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot(reduce: true);
    await h.start();
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('поиск находит событие по запросу «робо»', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot(size: const Size(412, 915));
    await h.start();
    await h.tapLabel('Открыть второе событие');
    await h.tapLabel('Следующее медиа');
    await h.tapLabel('Рыбка: добавить в избранное');
    await h.tapLabel('Далее');
    await h.holdFish();
    await h.tapLabel('Далее');
    await h.tapLabel('Выбрать напоминание');
    await h.tapText('За час');
    await h.tapLabel('Далее');
    await h.tapLabel('Открыть описание');
    await h.tapText('Понятно');
    await h.tapLabel('Далее');
    await h.tapLabel('Поделиться событием');
    await h.tapText('Скопировать учебную ссылку');
    await h.tapLabel('Далее');
    await h.tapLabel('Сообщить о проблеме');
    await h.tapText('Неверная информация');
    await h.tapText('Отправить учебную жалобу');
    await h.tapLabel('Далее');
    await h.tapLabel('Открыть поиск');
    await tester.enterText(find.byType(TextField), 'робо');
    await h.settle();
    expect(find.text('День робототехники'), findsWidgets);
  });
}
