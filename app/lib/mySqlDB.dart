import 'package:mysql1/mysql1.dart';

Future main() async {
  // Open a connection (testdb should already exist)
  final connection = await MySqlConnection.connect(ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    db: 'employeeApp',
  ));

  var results = await connection.query('select * from employee');
  print(results);

  // Finally, close the connection
  await connection.close();
}
