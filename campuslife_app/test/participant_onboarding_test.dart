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

  Future<void> tapText(String text) async {
    await tester.tap(find.text(text).last);
    await settle();
  }

  Future<void> tapAction() async {
    await tester.tap(find.text('ЗАПИСАТЬСЯ НА СОБЫТИЕ').last);
    await settle();
  }

  Finder get actionButton => find.byType(GestureDetector).first;

  Future<void> start() async {
    await tapText('Попробовать');
  }

  Future<void> swipeFeed() async {
    await tester.fling(find.byType(PageView).first, const Offset(0, -320), 900);
    await settle();
  }

  Future<void> swipeMedia() async {
    await tester.fling(find.byType(PageView).last, const Offset(-320, 0), 900);
    await settle();
  }

  Future<void> swipeDown() async {
    await tester.fling(find.byType(PageView).first, const Offset(0, 320), 900);
    await settle();
  }

  Future<void> tapBottomAction() async {
    await tester.tap(find.byType(GestureDetector).last);
    await settle();
  }

  Future<void> holdFish({double dx = -140}) async {
    final Offset center = tester.getCenter(find.byType(GestureDetector).last);
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
    expect(find.text('Смахни вверх'), findsWidgets);
    expect(find.text('Вечер студенческих идей'), findsNothing);
  });

  testWidgets('свайп вверх открывает второе событие', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeFeed();
    expect(find.text('Смахни влево — у события есть фото и видео'), findsWidgets);
  });

  testWidgets('первый свайп медиа работает без блокировки', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeFeed();
    await h.swipeMedia();
    expect(find.text('Готово. Смахни вниз'), findsWidgets);
  });

  testWidgets('короткий тап по рыбке не записывает на событие', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeFeed();
    await h.swipeMedia();
    await h.swipeDown();
    await h.tapBottomAction();
    await h.swipeDown();
    await h.tapBottomAction();
    expect(find.text('Готово. Смахни вниз'), findsNothing);
  });

  testWidgets('удержание и движение выполняют запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeFeed();
    await h.swipeMedia();
    await h.swipeDown();
    await h.tapBottomAction();
    await h.swipeDown();
    await h.holdFish();
    expect(find.text('Готово. Смахни вниз'), findsWidgets);
  });

  testWidgets('отпускание до порога отменяет запись', (WidgetTester tester) async {
    final _Harness h = _Harness(tester);
    await h.boot();
    await h.start();
    await h.swipeFeed();
    await h.swipeMedia();
    await h.swipeDown();
    await h.tapBottomAction();
    await h.swipeDown();
    await h.holdFish(dx: -14);
    expect(find.text('Готово. Смахни вниз'), findsNothing);
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
}
