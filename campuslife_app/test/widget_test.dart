import 'package:campuslife_app/app/app.dart';
import 'package:campuslife_app/app/di.dart';
import 'package:campuslife_app/app/theme.dart';
import 'package:campuslife_app/domain/entities.dart';
import 'package:campuslife_app/presentation/entry/entry_screen.dart';
import 'package:campuslife_app/presentation/shared/theme_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('light and dark themes expose their color tokens', () {
    expect(buildTheme().extension<AppColors>(), AppColors.light);
    expect(buildDarkTheme().extension<AppColors>(), AppColors.dark);
    expect(buildTheme().textTheme.bodyMedium?.fontFamily, Fonts.sans);
    expect(buildDarkTheme().textTheme.bodyMedium?.fontFamily, Fonts.sans);
  });

  test('theme defaults to dark and persists all explicit choices', () async {
    expect(await ThemePreferences.restore(), ThemeMode.dark);
    for (final mode in ThemeMode.values) {
      await ThemePreferences.save(mode);
      expect(await ThemePreferences.restore(), mode);
    }
  });

  for (final role in UserRole.values) {
    testWidgets('saved dark theme survives restored ${role.name} session', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'pixel_fish_theme': 'dark'});
      final repo = FakeCampusLifeRepository()
        ..session = User(
          id: 'theme_user',
          name: 'Проверка темы',
          email: 'theme@example.com',
          phone: '',
          role: role,
        );
      final container = ProviderContainer(
        overrides: [repositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const CampusLifeApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EntryScreen), findsNothing);
      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('reduced motion applies theme without capturing an overlay', (
    tester,
  ) async {
    var applied = false;
    late BuildContext currentContext;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              currentContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await revealTheme(
      currentContext,
      GlobalKey(),
      ThemeMode.dark,
      Offset.zero,
      () => applied = true,
    );
    expect(applied, isTrue);
    expect(await ThemePreferences.restore(), ThemeMode.dark);
    expect(find.byType(RawImage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
