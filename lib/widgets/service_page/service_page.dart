import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/widgets/goods_page/goods_page.dart';
import 'package:service_app/widgets/payment_page/payment_page.dart';
import 'package:service_app/widgets/refuse_page/refuse_page.dart';
import 'package:service_app/widgets/reschedule_page/reschedule_page.dart';
import 'package:service_app/widgets/service-to-page-view/service-to-page-view.dart';
import 'package:service_app/widgets/service_page/service_body.dart';
import 'package:service_app/widgets/service_page/service_header.dart';

class ServicePage extends StatelessWidget {
  final ServiceController serviceController = Get.put(ServiceController());
  final int serviceId;
  final Brand brand;

  ServicePage({Key key, @required this.serviceId, @required this.brand}) : super(key: key) {
    serviceController.init(serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: brand.bColor(),
            title: Obx(() => serviceController.service.value.id != -1 ? Text('${serviceController.service.value.number ?? ''}') : SizedBox(height: 1,)),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Obx(() => serviceController.service.value.id != -1 ? ServiceHeader(service: serviceController.service.value) : SizedBox(height: 1,)),
                      Obx(() => serviceController.service.value.id != -1 ? ServiceBody(service: serviceController.service.value) : SizedBox(height: 1,)),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ServiceTOPageView(onTap: () {
                              serviceController.workType = 'ТО1';
                              Get.to(GoodsPage());
                            }),
                            ServiceTOPageView(onTap: () {
                              serviceController.workType = 'ТО2';
                              Get.to(GoodsPage());
                            }),
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
