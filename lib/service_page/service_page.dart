import 'package:flutter/material.dart';
import 'package:service_app/call_button/call_button.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text('Данные по заявке'),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: PhoneButton(phone: this._service.phone),
                            )
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
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 24.0
                            ),
                          ),
                          Text('Отказ')
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.blue,
                                size: 24.0
                            ),
                          ),
                          Text('Перенести дату')
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 24.0
                            ),
                          ),
                          Text('Завершить')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}