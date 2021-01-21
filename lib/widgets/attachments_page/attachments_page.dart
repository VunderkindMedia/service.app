import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'images_list.dart';

class AttachmentsPage extends StatefulWidget {
  @override
  _AttachmentsPageState createState() => _AttachmentsPageState();
}

class _AttachmentsPageState extends State<AttachmentsPage> {
  final ServiceController serviceController = Get.find();

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fabsState.value = FabsState.Main;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            'Вложения заявки (${serviceController.serviceImages.length})')),
      ),
      body: SafeArea(
        child: ImagesList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(null)),
    );
  }
}
