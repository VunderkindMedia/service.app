import 'package:flutter/material.dart';
import 'package:service_app/models/application.dart';

class ApplicationPage extends StatelessWidget {
  final Application application;

  ApplicationPage({Key key, @required this.application}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(application.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}