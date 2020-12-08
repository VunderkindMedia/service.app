import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/repo/repo.dart';
import 'package:service_app/service-to-page-view/service-to-page-view.dart';

class ServicePage extends StatelessWidget {
  Service _service;

  final controller = PageController(
    initialPage: 0
  );
  
  ServicePage({Key key, @required int serviceId}) : super(key: key) {
    this._service = services.firstWhere((service) => service.id == serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._service.number),
      ),
      body: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: Text('Данные по заявке'),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this._service.customer, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Адрес: ${this._service.customerAddress}'),
                          SizedBox(height: 8),
                          Text('Информация клиента: ${this._service.comment}'),
                        ],
                      ),
                    ),
                    Column()
                  ],
                ),
              )
            ],
          ),
          Container(
            child: Expanded(
              child: PageView(
                controller: controller,
                children: [
                  ServiceTOPageView(title: 'Услуги ТО-1'),
                  ServiceTOPageView(title: 'Услуги ТО-2'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}