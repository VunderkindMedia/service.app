import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/widgets/call_button/call_button.dart';
import 'package:service_app/widgets/payment_page/payment_page.dart';
import 'package:service_app/widgets/refuse_page/refuse_page.dart';
import 'package:service_app/widgets/reschedule_page/reschedule_page.dart';
import 'package:service_app/widgets/service-to-page-view/service-to-page-view.dart';

class ServicePage extends StatelessWidget {
  final ServicesController servicesController = Get.put(ServicesController());
  final int serviceId;

  ServicePage({Key key, @required this.serviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Obx(() => Text('${servicesController.filteredServices.firstWhere((s) => s.id == serviceId).number}')),
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
                          Container(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: Obx(() {
                              var service = servicesController.filteredServices.firstWhere((s) => s.id == serviceId);

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(service.customer, style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text('Адрес: ${service.customerAddress}'),
                                        SizedBox(height: 8),
                                        Text('Информация клиента: ${service.comment}'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    child: PhoneButton(phone: 'service.phone'),
                                  )
                                ],
                              );
                            }),
                          )
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ServiceTOPageView(),
                            ServiceTOPageView(),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Вложения'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Container(
                          height: 36,
                          child: TabBar(
                            labelColor: Colors.blue,
                            tabs: [
                              Container(
                                height: 36,
                                child: Center(
                                  child: Text('Услуги ТО-1'),
                                ),
                              ),
                              Container(
                                height: 36,
                                child: Center(
                                  child: Text('Услуги ТО-2'),
                                ),
                              ),
                              Container(
                                height: 36,
                                child: Center(
                                  child: Text('Вложения'),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () => Get.to(RefusePage()),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Icon(Icons.cancel, color: Colors.red, size: 24.0),
                              ),
                              Text('Отказ')
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () => Get.to(ReschedulePage()),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Icon(Icons.calendar_today_rounded, color: Colors.blue, size: 24.0),
                              ),
                              Text('Перенести дату')
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () => Get.to(PaymentPage()),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Icon(Icons.check_circle, color: Colors.green, size: 24.0),
                              ),
                              Text('Завершить')
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
