import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/repo/repo.dart';
import 'package:service_app/service_page/service_page.dart';

class ServicesPage extends StatelessWidget {
  Widget _buildRow(BuildContext context, Service service) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage(serviceId: service.id)));
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: FlutterLogo(size: 24.0)
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${service.brandId}, ${service.number}'),
                  Text(service.customer, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(service.comment),
                  SizedBox(height: 8),
                  Text(service.customerAddress),
                ],
              )
            ],
          ),
        ),
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
          if (i >= services.length) {
            return null;
          }
          return _buildRow(context, services[i]);
        },
      ),
    );
  }
}