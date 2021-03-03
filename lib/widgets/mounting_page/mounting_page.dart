import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/widgets/mounting_page/mounting_header.dart';
import 'package:service_app/widgets/mounting_page/mounting_body.dart';

class MountingPage extends StatefulWidget {
  final int mountingId;

  MountingPage({@required this.mountingId});

  @override
  _MountingPageState createState() => _MountingPageState();
}

class _MountingPageState extends State<MountingPage> {
  final MountingController mountingController = Get.find();
  final MountingsController mountingsController = Get.find();
  final SyncController syncController = Get.find();

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mountingController.disposeController();
      mountingsController.ref(mountingsController.selectedDateStart.value,
          mountingsController.selectedDateEnd.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mountingController.mounting.value.id == -1) {
      Get.back();
    }

    var mounting = mountingController.mounting.value;

    /* var mountingState = mountingController.mounting.value.state; */

    return Scaffold(
      appBar: AppBar(
        title: Text('${mountingController.mounting.value.number}'),
        actions: [],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Obx(() => MountingHeader(
                      mounting: mountingController.mounting.value)),
                  Obx(() => MountingBody(
                        mounting: mountingController.mounting.value,
                        callPhone: () => mountingsController.callMethod(
                            context, mounting.phone),
                        openNavigator: () =>
                            mountingsController.openNavigator(mounting),
                      )),
                  /* Obx(() => MountingStages()), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
