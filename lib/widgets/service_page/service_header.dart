import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/service.dart';

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({
    Key key,
    @required this.service,
  }) : super(key: key);

  final Service service;

  @override
  Widget build(BuildContext context) {
    if (service == null) {
      return Text('');
    }

    String measureDate = DateFormat('dd.MM').format(service.dateStart).toString();
    String measureInterval = DateFormat.Hm().format(service.dateStart).toString() + " - " + DateFormat.Hm().format(service.dateEnd).toString();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          title: Text("Статус заявки: ${service.status}" + "\n\nДата: $measureDate \t\t Время: $measureInterval"),
          subtitle: Text("${(service.thermalImager ? '\n\nТребуется тепловизор' : '')}" +
              "${(service.customerDecision != "") ? '\n Решение ТО-2: ' + service.customerDecision : ''}" +
              "${(service.sumTotal > 0) ? '\nОбщая сумма: ' + service.sumTotal.toString() : ''}" +
              "${(service.sumPayment > 0) ? '\nСумма оплаты (' + service.paymentType + '): ' + service.sumPayment.toString() : ''}"),
        ),
      ),
    );
  }
}
