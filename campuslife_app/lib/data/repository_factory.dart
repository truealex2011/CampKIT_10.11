import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories.dart';
import 'connection.dart';
import 'database.dart' hide EventMedia;
import 'repository_impl.dart';

Future<CampusLifeRepository> openLocalRepository() async {
  final executor = await openConnection();
  final database = AppDatabase(executor);
  final prefs = await SharedPreferences.getInstance();
  final repository = LocalRepository(database, prefs);
  await repository.warmUp();
  return repository;
}
