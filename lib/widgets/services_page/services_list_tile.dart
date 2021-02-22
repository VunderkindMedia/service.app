import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/widgets/reschedule_page/reschedule_page.dart';
import 'package:service_app/widgets/refuse_page/refuse_page.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service.dart';

class ServiceListTile extends StatelessWidget {
  final ServicesController servicesController = Get.find();
  final ServiceController serviceController = Get.find();
  final Service service;
  final Brand brand;

  ServiceListTile({this.service, this.brand});

  Widget buildTitle(bool isSearching) {
    String serviceInterval =
        DateFormat.Hm().format(service.dateStart).toString() +
            " - " +
            DateFormat.Hm().format(service.dateEnd).toString();
    String serviceDate = !isSearching
        ? ''
        : DateFormat('dd.MM').format(service.dateStart).toString();

    Color brandColor = brand.bColor();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          ServiceState().getStateIcon(service),
          color: brandColor,
        ),
        SizedBox(width: 5.0),
        Expanded(
            child: Text(
          '${service.status}',
          style: TextStyle(color: kTextLightColor),
          maxLines: 1,
        )),
        Spacer(),
        Text(
          '${serviceDate.isEmpty ? '' : serviceDate} $serviceInterval',
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget buildSubtitle() {
    String outputAddress = service.getShortAddress();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            outputAddress,
            maxLines: 2,
            style: TextStyle(fontSize: 18.0, color: kTextLightColor),
          ),
          SizedBox(height: 6.0),
          Text(
            service.customer,
            style: TextStyle(fontSize: 16.0, color: kTextLightColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        isThreeLine: true,
        title: buildTitle(servicesController.isSearching.value),
        subtitle: buildSubtitle(),
      ),
      actions: [
        IconSlideAction(
          caption: 'Отмена',
          icon: Icons.cancel,
          onTap: () async {
            await serviceController.init(service.id);
            if (!serviceController.locked.value &&
                serviceController.serviceGoods.length == 0) {
              serviceController.fabsState.value = FabsState.RefusePage;
              Get.to(RefusePage());
            } else {
              if (serviceController.serviceGoods.length > 0) {
                await Get.defaultDialog(
                    title: 'Ошибка!',
                    middleText:
                        'В заказе выбраны услуги! Для отмены очистите услуги.');
              } else {
                await Get.defaultDialog(
                    title: 'Ошибка!',
                    middleText: 'Изменение заявки запрещено!');
              }
            }
          },
        ),
        IconSlideAction(
          caption: 'Перенос',
          icon: Icons.calendar_today,
          onTap: () async {
            await serviceController.init(service.id);
            if (!serviceController.locked.value &&
                serviceController.serviceGoods.length == 0) {
              serviceController.fabsState.value = FabsState.ReschedulePage;
              Get.to(ReschedulePage());
            } else {
              if (serviceController.serviceGoods.length > 0) {
                await Get.defaultDialog(
                    title: 'Ошибка!',
                    middleText:
                        'В заказе выбраны услуги! Для переноса очистите услуги.');
              } else {
                await Get.defaultDialog(
                    title: 'Ошибка!',
                    middleText: 'Изменение заявки запрещено!');
              }
            }
          },
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: 'Позвонить',
          icon: Icons.call,
          onTap: () {
            servicesController.callMethod(context, service.phone);
          },
        ),
        IconSlideAction(
          caption: 'Навигатор',
          icon: Icons.navigation,
          onTap: () {
            servicesController.openNavigator(service);
          },
        ),
      ],
    );
  }
}
