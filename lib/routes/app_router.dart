import 'package:chop_url/database/db.dart';
import 'package:chop_url/middlewares/auth_middleware.dart';
import 'package:darto/darto.dart';
import 'package:dartonic/dartonic.dart';

Router appRouter() {
  final router = Router();

  router.get('/dashboard/urls', authMiddleware, (
    Request req,
    Response res,
  ) async {
    final userId = req.context['userId'];
    final list = await db
        .select()
        .from('urls')
        .where(eq('urls.user_id', userId));

    return res.json(list);
  });

  router.get('/dashboard/top', authMiddleware, (
    Request req,
    Response res,
  ) async {
    await dartonic.driver.raw(
      '''
        SELECT urls.*, COUNT(c.id) as clicks 
        FROM urls 
        LEFT JOIN click_logs c ON urls.id = c.url_id 
        WHERE urls.user_id = ?
        GROUP BY urls.id 
        ORDER BY clicks DESC 
        LIMIT 10;
      ''',
      [req.context['userId']],
    );

    return res.json({});
  });

  router.put('/dashboard/url/:id', authMiddleware, (
    Request req,
    Response res,
  ) async {
    final userId = req.context['userId'];
    final id = int.parse(req.params['id'] ?? '');
    final body = await req.body;

    await db
        .update('urls')
        .set({'original': body['original']})
        .where(and([eq('urls.id', id), eq('urls.user_id', userId)]));

    return res.json({'message': 'Atualizado'});
  });

  router.delete('/dashboard/url/:id', authMiddleware, (
    Request req,
    Response res,
  ) async {
    final userId = req.context['userId'];
    final id = int.parse(req.params['id'] ?? '');

    await db
        .delete('urls')
        .where(and([eq('urls.id', id), eq('urls.user_id', userId)]));

    return res.json({'message': 'Deletado'});
  });

  router.get('/dashboard/url/:id/logs', authMiddleware, (
    Request req,
    Response res,
  ) async {
    final id = int.parse(req.params['id'] ?? '');
    final logs = await db
        .select()
        .from('click_logs')
        .where(eq('click_logs.url_id', id))
        .orderBy('click_logs.clicked_at', 'DESC');

    return res.json(logs);
  });

  return router;
}
