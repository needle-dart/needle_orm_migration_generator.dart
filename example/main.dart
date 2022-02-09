import 'package:needle_orm/needle_orm.dart';
import 'package:scope/scope.dart';

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
}

void main() {
  DataSource ds = MockDataSource();
  (Scope()..value<DataSource>(scopeKeyDefaultDs, ds)).run(test);
}

void test() {}
