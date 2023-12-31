import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memo/memo.dart';
import 'package:memo/data.dart';

import 'dbHelper.dart';

void main() {
  runApp(MyApp()/*const ProviderScope(child: MyApp())*/);
}

final memoProvider = ((_) => '');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _title;
  var _titleController = TextEditingController();

  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  Future<void> InputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("タイトル"),
            content: TextField(
              decoration: InputDecoration(hintText: "ここに入力"),
              controller: _titleController,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("キャンセル"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _title = _titleController.text;
                    _insert();
                    _allDate();
                  });
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  Widget _listTile(String title) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text(title),
            subtitle: Text(""),
            onTap: () async {
              Data data = Data(title: title, memo: "");
              var memo = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MemoPage(data: data);
                  },
                ),
              );
              setState(() {
              });
            }),
        const Divider(),
      ],
    );
  }

  late List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _rouCount(),
          builder: (context, snapshot) {
            // 通信中はスピナーを表示
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            // エラー発生時はエラーメッセージを表示
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            // データがnullでないかチェック
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return _listTile(snapshot.data?[index]['title']);
                  }
              );
            } else {
              return Text("データが存在しません");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          InputDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: _title,
      DatabaseHelper.columnSubTitle: null,
      DatabaseHelper.columnMemo: null,
      DatabaseHelper.columnCreatedAt: DateFormat('yyyy-MM-dd-HHmmss').format(DateTime.now()),
      DatabaseHelper.columnUpdatedAt: DateFormat('yyyy-MM-dd-HHmmss').format(DateTime.now())
    };
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  Future<List<Map<String, dynamic>>> _queryAllRows() async {
    List<Map<String, dynamic>> data;
    data = dbHelper.queryAllRows() as List<Map<String, dynamic>>;
    return data;
  }

  // 照会ボタンクリック
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    allRows.forEach(print);
  }

  // 更新ボタンクリック
  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: '',
      DatabaseHelper.columnSubTitle: 35,
      DatabaseHelper.columnMemo: 1,
      DatabaseHelper.columnCreatedAt: 1,
      DatabaseHelper.columnUpdatedAt: 1
    };
    final rowsAffected = await dbHelper.update(row);
    print('更新しました。 ID：$rowsAffected ');
  }

  // 削除ボタンクリック
  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id!);
    print('削除しました。 $rowsDeleted ID: $id');
  }

  void _allDate() async {
    int count = await dbHelper.queryRowCount();
    print(count);
  }

  Future<List<Map<String, dynamic>>> _rouCount() async {
    return await dbHelper.queryAllRows();
  }
}