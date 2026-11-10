import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../../domain/entities.dart';

Future<QueryExecutor> openConnection() async {
  try {
    final result = await WasmDatabase.open(
      databaseName: 'campuslife',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift.worker.js'),
    );
    return result.resolvedExecutor.executor;
  } catch (error) {
    throw const AppException(
      'web_database',
      'Не удалось открыть локальную базу данных в браузере',
    );
  }
}
