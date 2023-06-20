// import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabaseManager {
  static Database? _database;

  static Future<Database> connect() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();

    // Open the database and store the reference.
    final db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'places.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          // SQLite command
          '''
            CREATE TABLE place (
              id INTEGER PRIMARY KEY,
              name VARCHAR(255) NOT NULL,
              image_path VARCHAR(512),
              lat DOUBLE,
              lng DOUBLE,
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            );
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    _database = db;

    if (kDebugMode) {
      print('Database connected!');
      print('Database path: ${db.path}');
    }

    return db;
  }

  static Future<Database> getDatabaseInstance() async {
    if (_database == null) {
      return connect();
    }
    return _database!;
  }
}
