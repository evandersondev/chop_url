import 'package:chop_url/database/db.dart';
import 'package:darto/darto.dart';
import 'package:dartonic/dartonic.dart';
import 'package:uuid/uuid.dart';

import '../schemas/validations.dart';

Router baseRouter() {
  final router = Router();

  router.post('/shorten', (Request req, Response res) async {
    final body = await req.body;
    final result = createUrlSchema.safeParse(body);

    if (!result.success) {
      return res.status(400).json({'errors': result.error?.format()});
    }

    final data = result.data;
    final slug = const Uuid().v4().substring(0, 6);

    final now = DateTime.now();
    final expires =
        data['expires_in_days'] != null
            ? now.add(Duration(days: data['expires_in_days']))
            : null;

    await db.insert('urls').values({
      'slug': slug,
      'original_url': data['original_url'],
      'created_at': now.toIso8601String(),
      'expires_at': expires?.toIso8601String(),
    });

    return res.json({'short_url': '${req.protocol}://${req.host}/$slug'});
  });

  router.get('/:slug', (Request req, Response res) async {
    final slug = req.params['slug'];

    final result =
        (await db.select().from('urls').where(eq('urls.slug', slug)) as List)
            .first;

    if (result == null) {
      return res.status(404).json({'error': 'Link não encontrado'});
    }

    if (result['expires_at'] != null &&
        DateTime.parse(result['expires_at']).isBefore(DateTime.now())) {
      return res.status(410).json({'error': 'Link expirado'});
    }

    await db
        .update('urls')
        .set({'clicks': (result['clicks'] as int) + 1})
        .where(eq('urls.id', result['id']));

    return res.redirect(result['original_url']);
  });

  return router;
}
