import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/service_page/service_goods_list.dart';
import 'package:service_app/widgets/service_page/service_body.dart';
import 'package:service_app/widgets/service_page/service_header.dart';

class ServicePage extends StatelessWidget {
  final ServiceController serviceController = Get.find();
  final int serviceId;
  final Brand brand;

  ServicePage({Key key, @required this.serviceId, @required this.brand});

  @override
  Widget build(BuildContext context) {
    serviceController.fabsState.value = FabsState.Main;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.bColor(),
        title: Obx(() => serviceController.service.value.id != -1
            ? Text('${serviceController.service.value.number ?? ''}')
            : SizedBox()),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Obx(() => serviceController.workType.value.length == 0
                  ? ServiceHeader(service: serviceController.service.value)
                  : SizedBox()),
              Obx(() => serviceController.workType.value.length == 0
                  ? ServiceBody(service: serviceController.service.value)
                  : SizedBox()),
              Obx(() => GoodsList(
                    workType: 'ТО1',
                    goodsList: serviceController.serviceGoods
                        .where((sg) => sg.workType == 'ТО1')
                        .toList(),
                  )),
              Obx(() => GoodsList(
                    workType: 'ТО2',
                    goodsList: serviceController.serviceGoods
                        .where((sg) => sg.workType == 'ТО2')
                        .toList(),
                  )),
            ])),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(null)),
    );
  }
}
