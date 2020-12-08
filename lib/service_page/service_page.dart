import 'package:flutter/material.dart';
import 'package:service_app/repo/repo.dart';

class ServicePage extends StatelessWidget {
  final int serviceId;

  ServicePage({Key key, @required this.serviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(services.firstWhere((service) => service.id == serviceId)?.number),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}