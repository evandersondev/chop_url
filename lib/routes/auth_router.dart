import 'package:bcrypt/bcrypt.dart';
import 'package:darto/darto.dart';
import 'package:dartonic/dartonic.dart';

import '../database/db.dart';
import '../middlewares/auth_middleware.dart';

Router authRouter() {
  final router = Router();

  router.post(
    '/auth/register', //
    (Request req, Response res) async {
      final body = await req.body;
      final email = body['email'];
      final password = body['password'];

      final hashed = BCrypt.hashpw(password, BCrypt.gensalt());

      final existing =
          (await db.select().from('users').where(eq('email', email)) as List)
              .first;
      if (existing != null) {
        return res.status(400).json({'error': 'Email já registrado'});
      }

      final userId =
          await db.insert('users').values({
            'email': email,
            'password': hashed,
          }).returningId();

      final token = generateToken(userId);
      res.json({'token': token});
    },
  );

  router.post(
    '/auth/login', //
    (Request req, Response res) async {
      final body = await req.body;
      final email = body['email'];
      final password = body['password'];

      final user =
          (await db.select().from('users').where(eq('email', email)) as List)
              .first();

      if (user == null) {
        return res.status(401).json({'error': 'Credenciais inválidas'});
      }

      final hashed = BCrypt.hashpw(password, BCrypt.gensalt());
      if (user['password'] != hashed) {
        return res.status(401).json({'error': 'Senha incorreta'});
      }

      final token = generateToken(user['id']);
      res.json({'token': token});
    },
  );

  return router;
}
