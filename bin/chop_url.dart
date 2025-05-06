import 'package:chop_url/database/db.dart';
import 'package:chop_url/router.dart';
import 'package:darto/darto.dart';

void main() async {
  await initDb();
  final app = Darto();

  app.use(appRouter());

  app.listen(3000, () {
    print('Server running on port 3000');
  });
}
