import 'package:flutter/material.dart';

import 'data.dart';

class MemoPage extends StatefulWidget {
  final Data data;
  const MemoPage({super.key, required this.data});

  @override
  State<MemoPage> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  late Data _data;
  var _memoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memo"),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Text(_data.title),
              TextField(
                controller: _memoController,
              ),
            ],
          )),
    );
  }
}