import 'package:dartonic/dartonic.dart';

import 'schemas.dart';

final dartonic = Dartonic("sqlite:urlshortener.db", schemas: [urlTable]);
final db = dartonic.instance;

Future<void> initDb() async {
  await dartonic.sync();
}
