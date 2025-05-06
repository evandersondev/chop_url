import 'dart:io';

import 'package:chop_url/database/db.dart';
import 'package:chop_url/router.dart';
import 'package:darto/darto.dart';

void main() async {
  await initDb();

  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final app = Darto();

  app.use(appRouter());

  app.listen(port, () {
    print('Server running on port $port');
  });
}
