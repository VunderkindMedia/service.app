import 'package:flutter/material.dart';
import 'package:service_app/application_page/application_page.dart';
import 'package:service_app/models/application.dart';
import 'package:service_app/repo/repo.dart';

class ApplicationsPage extends StatelessWidget {
  Widget _buildRow(BuildContext context, Application application) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationPage(application: application)));
      },
      title: Text(
        application.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= applications.length) {
            return null;
          }
          return _buildRow(context, applications[index]);
        },
      ),
    );
  }
}