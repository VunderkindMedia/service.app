import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/models/construction_type.dart';
import 'package:service_app/models/mounting_image.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/models/service_status.dart';
import 'package:uuid/uuid.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/stage.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';

class MountingController extends GetxController {
  final SyncController syncController = Get.find();
  final MountingsController mountingsController = Get.find();
  final AccountController accountController = Get.find();

  RxBool locked = false.obs;
  Rx<Mounting> mounting = Mounting(-1).obs;
  Rx<Brand> brand = Brand(-1).obs;
  Rx<ConstructionType> constructionType = ConstructionType("").obs;
  RxList<Stage> constructionStages = <Stage>[].obs;
  RxList<MountingStage> mountingStages = <MountingStage>[].obs;
  RxList<MountingImage> mountingImages = <MountingImage>[].obs;

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
    var constructionType = mountingsController.constructionTypes.firstWhere(
        (constructionType) =>
            constructionType.id == mounting.constructionTypeId);
    var stages = mountingsController.stages
        .where((stage) => stage.constructionTypeId == constructionType.id)
        .toList();

    stages.sort((a, b) => a.id.compareTo(b.id));

    this.mounting.value = mounting;
    this.brand.value = brand;
    this.constructionType.value = constructionType;
    this.constructionStages.assignAll(stages);

    await refreshMountingStages();
    await refreshMountingImages();

    if (mounting.checkState([
      ServiceState.WorkFinished,
      ServiceState.Exported,
      ServiceState.ExportError
    ])) {
      locked.value = true;
    }
  }

  void disposeController() {
    locked = false.obs;
    mounting = Mounting(-1).obs;
    mountingStages.clear();
  }

  Future<void> refreshMountingStages() async {
    var dbStages = await _dbService.getMountingStages(mounting.value.id);
    mountingStages.assignAll(dbStages);

    print('updt mounting stages');
  }

  Future<void> refreshMountingImages() async {
    var dbImages = await _dbService.getMountingImages(mounting.value.id);
    mountingImages.assignAll(dbImages);

    print('updt mounting images');
  }
}
