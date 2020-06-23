import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/quote.dart';

class DatabaseHelper {
  static Database _database;
  static const String ID = 'id';
  static const String TEXT = 'quote_text';
  static const String AUTHOR = 'quote_author';
  static const String TABLE = 'quotes';
  static const String DB_NAME = 'favorite_quotes.db';
  static const int VERSION = 8;

  _initializeDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    var db = await openDatabase(path, version: VERSION, onCreate: _createTable);
    return db;
  }

  _createTable(Database database, int version) async {
    await database.execute(
        "CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $TEXT TEXT, $AUTHOR TEXT)");
  }

  Future<Database> get fetchMyDatabase async {
    if (_database != null) {
      return _database;
    }
    _database = await _initializeDatabase();
    return _database;
  }

  // save quote when user click the button
  saveQuote(Quote quote) async {
    var dbClient = await fetchMyDatabase;
    await dbClient.insert(TABLE, quote.toMap());
  }

//  // Close the connection to database
  Future closeDbConnection() async {
    var dbClient = await fetchMyDatabase;
    dbClient.close();
  }

// Fetch the Saved Quotes from Table
  Future<List<Quote>> fetchSavedQuotes() async {
    var dbClient = await fetchMyDatabase;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, TEXT, AUTHOR]);
    List<Quote> quotes = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        quotes.add(Quote.fromMap(maps[i]));
      }
    }
    return quotes;
  }

  Future<String> deleteQuoteFromFavorite(String id) async {
    var dbClient = await fetchMyDatabase;
    return dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]).toString();
  }
}
