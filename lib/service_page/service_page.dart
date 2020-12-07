import 'package:flutter/material.dart';
import 'package:service_app/models/application.dart';

class ServicePage extends StatelessWidget {
  final Application service;

  ServicePage({Key key, @required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}