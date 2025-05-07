import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:darto/darto.dart';

final secret = 'sua_chave_secreta';
String generateToken(int userId) {
  final jwt = JWT({'userId': userId});
  return jwt.sign(SecretKey(secret));
}

Middleware authMiddleware = (req, res, next) async {
  final authHeader = req.headers.authorization;
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({'error': 'Token ausente'});
  }

  final token = authHeader.substring(7);
  try {
    final jwt = JWT.verify(token, SecretKey(secret));
    req.context['userId'] = jwt.payload['userId'];
    next();
  } catch (_) {
    return res.status(401).json({'error': 'Token inválido'});
  }
};
