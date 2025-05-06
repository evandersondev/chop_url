import 'package:zard/zard.dart';

final createUrlSchema = z.map({
  'original_url': z.string().url(message: 'URL inválida'),
  'expires_in_days': z.int().min(1).max(365).optional(),
});
