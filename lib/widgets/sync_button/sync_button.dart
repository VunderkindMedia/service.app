import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app/get/controllers/services_controller.dart';

class SyncButton extends StatelessWidget {
  ServicesController servicesController = Get.find();

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy\nHH:mm:ss');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: servicesController.sync,
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: Icon(Icons.sync, color: Colors.green, size: 24.0),
            ),
           Obx(() => Container(
             child: Text(servicesController.isLoading.value
                 ? 'Данные обновляются...'
                 : servicesController.isSynchronized.value
                 ? 'Обновлено ${formattedDate(servicesController.lastSyncDate.value)}'
                 : 'Синхроинзировать'),
           ))
          ],
        ),
      ),
    );
  }
}
