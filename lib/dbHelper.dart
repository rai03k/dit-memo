import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // DB名
  static final dbName = "MyDatabase.db";

  // スキーマのバージョン
  static final dbVersion = 1;

  // テーブル名
  static final table = 'memo';

  // カラム名
  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnSubTitle = 'subTitle';
  static final columnMemo = 'memo';
  static final columnCreatedAt = 'createdAt';
  static final columnUpdatedAt = 'updatedAt';

  DatabaseHelper._privateConstructor();
  // DatabaseHelper._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
  // DatabaseHelper クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, dbName);
    // データベース接続
    return await openDatabase(path,
        version: dbVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  // テーブル作成
  // 引数:dbの名前
  // 引数:スキーマーのversion
  // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnSubTitle TEXT,
            $columnMemo TEXT,
            $columnCreatedAt TEXT,
            $columnUpdatedAt TEXT
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(table);
    result.forEach((row) => print(row));
    return result;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // レコード数を確認
  Future<int> queryRowCount() async {
    Database? db = await instance.database;
    int rowCount = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
    return rowCount;
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}