import 'package:dartonic/dartonic.dart';

final urlTable = sqliteTable('urls', {
  'id': integer().primaryKey(autoIncrement: true),
  'slug': text().unique().notNull(),
  'original_url': text().notNull(),
  'created_at': datetime().notNull().defaultNow(),
  'expires_at': datetime(),
  'clicks': integer().notNull().$default(0),
});

final usersTable = sqliteTable('users', {
  'id': integer().primaryKey(autoIncrement: true),
  'email': text().unique().notNull(),
  'password': text().notNull(),
});

final clickLogsTable = sqliteTable('click_logs', {
  'id': integer().primaryKey(autoIncrement: true),
  'url_id': integer().references(() => 'urls.id').notNull(),
  'clicked_at': datetime().defaultNow(),
  'ip': text().notNull(),
  'user_agent': text().notNull(),
});
