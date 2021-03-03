import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/service_status.dart';

class MountingHeader extends StatelessWidget {
  const MountingHeader({@required this.mounting});

  final Mounting mounting;

  @override
  Widget build(BuildContext context) {
    String mountingDate =
        DateFormat('dd.MM').format(mounting.dateStart).toString();

    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              ServiceState().getStateIcon(mounting.state, ServiceStatus.Start),
            ),
            title: Text('Дата монтажа: $mountingDate'),
            subtitle: Text('Описание состояния монтажа'),
          ),
        ),
      ),
    );
  }
}
