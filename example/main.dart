import 'dart:async';

import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mariadb.dart';
import 'package:logging/logging.dart';
import 'package:mysql1/mysql1.dart';
import 'package:needle_orm/needle_orm.dart';

import 'src/domain.dart';

class MockDataSource extends DataSource {
  MockDataSource() : super(DatabaseType.PostgreSQL, '10.0');
  @override
  Future<List<List>> execute(
      String tableName, String sql, Map<String, dynamic> substitutionValues,
      [List<String> returningFields = const []]) async {
    // print('sql: $sql');
    return List<List>.empty();
    // throw UnimplementedError();
  }

  @override
  Future<T> transaction<T>(FutureOr<T> Function(DataSource p1) f) {
    throw UnimplementedError();
  }
}

void main(List<String> args) async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name}: ${record.time} ${record.loggerName}: ${record.message}');
  });
  args = ['refresh'];
  var settings = new ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'needle',
      password: 'needle',
      db: 'needle');
  var conn = await MySqlConnection.connect(settings);

  var migrationRunner = MariaDbMigrationRunner(conn, migrations: [
    BookMigration(),
    UserMigration(),
  ]);
  await runMigrations(migrationRunner, args);
}
