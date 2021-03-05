import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/models/construction_type.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/service_status.dart';

class MountingHeader extends StatelessWidget {
  MountingHeader({@required this.mounting, @required this.constructionType});

  final MountingController mountingController = Get.find();
  final Mounting mounting;
  final ConstructionType constructionType;

  @override
  Widget build(BuildContext context) {
    String mountingDate =
        DateFormat('dd.MM HH:mm').format(mounting.dateStart).toString();

    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              ServiceState().getStateIcon(mounting.state, ServiceStatus.Start),
              color: mountingController.brand.value.bColor(),
              size: 52.0,
            ),
            title: Text(
              'Дата монтажа: $mountingDate',
              style: kCardTitleStyle,
            ),
            subtitle: Text(
              'Бренд: ${mountingController.brand.value.name}' +
                  '\nВид конструкции: ${constructionType.name}',
              style: kCardSubtitleStyle,
            ),
          ),
        ),
      ),
    );
  }
}
