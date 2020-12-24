import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service.dart';

class ServiceListTile extends StatelessWidget {
  final ServicesController servicesController = Get.find();
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          ServiceState().getStateIcon(service.state),
          color: brand.bColor(),
        ),
        SizedBox(width: 5.0),
        Expanded(child: Text('${service.status}')),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.customer,
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            outputAddress,
            maxLines: 2,
            style: TextStyle(fontSize: 18.0),
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
          color: Colors.redAccent,
          icon: Icons.cancel,
          onTap: () {},
        ),
        IconSlideAction(
          caption: 'Перенос',
          color: Colors.blueAccent,
          icon: Icons.calendar_today,
          onTap: () {},
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: 'Позвонить',
          color: Colors.green,
          icon: Icons.call,
          onTap: () {
            servicesController.callMethod(context, service.phone);
          },
        ),
        IconSlideAction(
          caption: 'Навигатор',
          color: Colors.grey,
          icon: Icons.navigation,
          onTap: () {
            servicesController.openNavigator(service);
          },
        ),
      ],
    );
  }
}
