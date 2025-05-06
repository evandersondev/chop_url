import 'package:dartonic/dartonic.dart';

final urlTable = sqliteTable('urls', {
  'id': integer().primaryKey(autoIncrement: true),
  'slug': text().unique().notNull(),
  'original_url': text().notNull(),
  'created_at': datetime().notNull().defaultNow(),
  'expires_at': datetime(),
  'clicks': integer().notNull().$default(0),
});
