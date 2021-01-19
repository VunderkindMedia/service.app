import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/service_page/service_goods_list.dart';
import 'package:service_app/widgets/service_page/service_body.dart';
import 'package:service_app/widgets/service_page/service_header.dart';
import 'package:service_app/widgets/goods_page/goods_page.dart';

class ServicePage extends StatefulWidget {
  final int serviceId;
  final Brand brand;

  ServicePage({Key key, @required this.serviceId, @required this.brand});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final ServiceController serviceController = Get.find();
  final ServicesController servicesController = Get.find();

  final List<String> lists = [WorkTypes.TO1, WorkTypes.TO2];

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      serviceController.clearSC();
      servicesController.ref(servicesController.selectedDate.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    serviceController.fabsState.value = FabsState.Main;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.brand.bColor(),
        title: Obx(() => serviceController.service.value.id != -1
            ? Text('${serviceController.service.value.number ?? ''}')
            : SizedBox()),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Obx(() =>
                  ServiceHeader(service: serviceController.service.value)),
              Obx(() => ServiceBody(service: serviceController.service.value)),
              Obx(() {
                List<Widget> cards = [];
                lists.forEach((card) {
                  cards.add(GoodsList(
                    workType: card,
                    goodsList: serviceController.serviceGoods
                        .where((sg) => sg.workType == card)
                        .toList(),
                    onAdd: !serviceController.locked.value
                        ? () {
                            serviceController.workType.value = card;
                            Get.to(GoodsPage());
                            print(card);
                          }
                        : null,
                  ));
                });
                return Column(
                  children: cards,
                );
              }),
              SizedBox(height: 80.0)
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
