import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/widgets/call_button/call_button.dart';
import 'package:service_app/widgets/service_page/service_page.dart';
import 'package:service_app/widgets/sync_button/sync_button.dart';

class ServicesPage extends StatelessWidget {
  final ServicesController servicesController = Get.put(ServicesController());

  Widget _buildRow(Service service, List<Brand> brands) {
    var brand = brands.firstWhere((brand) => brand.externalId == service.brandId, orElse: () => null)?.name ?? 'Неизвестный бренд';
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Get.to(ServicePage(serviceId: service.id)),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(margin: EdgeInsets.only(right: 8), child: FlutterLogo(size: 24.0)),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$brand, ${service.number}', overflow: TextOverflow.ellipsis, maxLines: 1),
                  Text(service.customer, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(service.comment),
                  SizedBox(height: 8),
                  Text(service.customerAddress),
                ],
              )),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: PhoneButton(phone: service.phone),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Obx(() => ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: servicesController.filteredServices.length,
                      itemBuilder: (context, i) {
                        return _buildRow(servicesController.filteredServices[i], servicesController.brands);
                      },
                    ))),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Flexible(flex: 1, child: SyncButton()),
                  Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text('Скрыть\nзаверешнные', style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Obx(() => Switch(
                                value: servicesController.hideFinished.value,
                                onChanged: (bool value) {
                                  servicesController.hideFinished.value = value;
                                },
                              )),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
