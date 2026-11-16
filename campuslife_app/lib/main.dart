import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'data/repository_factory.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const configuredApiUrl = String.fromEnvironment('CAMPUSLIFE_API_URL');
  final repository = configuredApiUrl.isNotEmpty
      ? await openServerRepository(Uri.parse(configuredApiUrl))
      : await openLocalRepository();
  if (kReleaseMode && configuredApiUrl.isEmpty) {
    throw StateError('CAMPUSLIFE_API_URL must be set for release builds');
  }
  runApp(
    ProviderScope(
      overrides: [repositoryProvider.overrideWithValue(repository)],
      child: const CampusLifeApp(),
    ),
  );
}
