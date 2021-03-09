import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/mounting_page/mounting_header.dart';
import 'package:service_app/widgets/mounting_page/mounting_body.dart';
import 'package:service_app/widgets/mounting_page/mounting_stages.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';
import 'package:service_app/widgets/buttons/action_button.dart';

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

  RxBool mountingFinished = false.obs;

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

    return Scaffold(
      appBar: AppBar(
        title: Text('${mountingController.mounting.value.number}'),
        actions: [
          Obx(
            () => Visibility(
              visible: mountingController.needSync.value,
              child: MainActionButton(
                label: 'Сохранить',
                color: kFabAcceptColor,
                icon: Icons.save_rounded,
                onPressed: () async {},
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: mountingController.isLoading.value,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Obx(() => MountingHeader(
                            mounting: mountingController.mounting.value,
                            constructionType:
                                mountingController.constructionType.value,
                          )),
                      Obx(() => MountingBody(
                            mounting: mountingController.mounting.value,
                            callPhone: () => mountingsController.callMethod(
                                context, mounting.phone),
                            openNavigator: () =>
                                mountingsController.openNavigator(mounting),
                          )),
                      Obx(
                        () => mountingController.mountingStages.length > 0
                            ? MountingStages(
                                mounting: mountingController.mounting.value)
                            : SizedBox(),
                      ),
                      SizedBox(height: 70.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => mountingController.mainAction.value,
      ),
    );
  }
}
