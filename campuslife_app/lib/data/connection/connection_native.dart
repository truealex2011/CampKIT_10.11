import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

Future<QueryExecutor> openConnection() async {
  return driftDatabase(name: 'campuslife').executor;
}
