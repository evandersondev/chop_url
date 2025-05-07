import 'dart:io';

import 'package:chop_url/database/db.dart';
import 'package:chop_url/routes/app_router.dart';
import 'package:chop_url/routes/auth_router.dart';
import 'package:chop_url/routes/base_router.dart';
import 'package:chop_url/routes/logs_router.dart';
import 'package:darto/darto.dart';

void main() async {
  await initDb();

  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final app = Darto();

  app.use(baseRouter());
  app.use(authRouter());
  app.use(appRouter());
  app.use(logsRouter());

  app.listen(port, () {
    print('Server running on port $port');
  });
}
