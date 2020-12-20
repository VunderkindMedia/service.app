import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/models/good.dart';

class GoodPage extends StatelessWidget {
  final Good good;

  GoodPage({Key key, @required this.good}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${good.name}'),
      ),
      body: SafeArea(
        child: Text('eee'),
      ),
    );
  }
}
