import 'package:dartonic/dartonic.dart';

import '../schemas/tables.dart';

final dartonic = Dartonic(
  "sqlite:urlshortener.db",
  schemas: [urlTable, usersTable, clickLogsTable],
);
final db = dartonic.instance;

Future<void> initDb() async {
  await dartonic.sync();
}
