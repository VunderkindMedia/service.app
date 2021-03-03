import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/models/service_status.dart';
import 'package:uuid/uuid.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';

class MountingController extends GetxController {
  final SyncController syncController = Get.find();
  final MountingsController mountingsController = Get.find();
  final AccountController accountController = Get.find();

  Rx<Mounting> mounting = Mounting(-1).obs;
  Rx<Brand> brand = Brand(-1).obs;
  RxBool locked = true.obs;
  RxList<MountingStage> mountingStages = <MountingStage>[].obs;

  RxString search = ''.obs;

  DbService _dbService;

  Future<void> onInit() async {
    super.onInit();

    _dbService = Get.find();
  }

  Future<void> init(int mountingId) async {
    var mountingMap = await _dbService.getRecordByField(
        DbService.MOUNTINGS_TABLE_NAME, "id", mountingId);
    var mounting = Mounting.fromMap(mountingMap);
    var brand = mountingsController.brands
        .firstWhere((brand) => brand.externalId == mounting.brandId);

    this.mounting.value = mounting;
    this.brand.value = brand;

    await refreshMountingStages();
  }

  void disposeController() {
    mounting = Mounting(-1).obs;
    mountingStages.clear();
  }

  Future<void> refreshMountingStages() async {
    var dbStages = await _dbService.getMountingStages(mounting.value.id);
    mountingStages.assignAll(dbStages);

    print('updt mounting stages');
  }
}
