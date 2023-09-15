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
        title: Text(_data.title),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_sharp)),
      ),
      body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _data.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _memoController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}