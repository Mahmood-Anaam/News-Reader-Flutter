import '../models/article_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/source_model.dart';

class DBHelper {
  static const String _databaseName = 'BookmarkedNews.db';
  static const int _databaseVersion = 1;
  Database? _database;

  DBHelper._();
  static final DBHelper _singleton = DBHelper._();
  factory DBHelper() => _singleton;
  get db async {
     _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);

    // open the database
    var db = await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
               CREATE TABLE articles (
               id INTEGER PRIMARY KEY AUTOINCREMENT,
               title TEXT,
               description TEXT,
               publishedAt TEXT,
               content TEXT,
               urlToImage TEXT,
               url TEXT,
               sourceId TEXT,
               sourceName TEXT,
               author TEXT
               )
        ''');
    });

    return db;
  }

  Map<String, dynamic> toJson(ArticleModel article) {
    return {
      'author': article.author ?? '',
      'description': article.description ?? '',
      'urlToImage': article.urlToImage ?? '',
      'content': article.content ?? '',
      'title': article.title ?? '',
      'url': article.url ?? '',
      'publishedAt': article.publishedAt,
      'sourceId': article.source!.id ?? '',
      'sourceName': article.source!.name ?? '',
    };
  }

  ArticleModel fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      source: SourceModel.fromJson(
          {'id': json['sourceId'], 'name': json['sourceName']}),
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
    );
  }



  Future<List<Map<String, dynamic>>> search(String table,String search) async {
    final db = await this.db;
    print("This works? $db");
    var result = await db.rawQuery("SELECT * FROM $table  WHERE title  Like '%$search%' OR description Like '%$search%' OR content Like '%$search%'");
    print("result is working? $result");
    print(result.length);
    return result;
  }






  Future<List<Map<String, dynamic>>> query(String table,
      {String? where,List<Object>?whereArgs}) async {
    final db = await this.db;
    return where == null ? db.query(table)??[] : db.query(table,where: where,whereArgs:whereArgs)??[];
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> update(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<void> delete(String table, int id) async {
    final db = await this.db;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
