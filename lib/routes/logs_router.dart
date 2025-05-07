import 'package:chop_url/database/db.dart';
import 'package:darto/darto.dart';
import 'package:dartonic/dartonic.dart';

Router logsRouter() {
  final router = Router();

  router.get('/:short', (Request req, Response res) async {
    final short = req.params['short'];
    final url =
        (await db.select().from('urls').where(eq('short', short)) as List)
            .first();

    if (url == null) {
      return res.status(404).json({'error': 'URL não encontrada'});
    }

    await db.insert('click_logs').values({
      'url_id': url['id'],
      'ip': req.ip,
      'user_agent': req.headers.get('user-agent') ?? '',
    });

    res.redirect(url['original']);
  });

  return router;
}
