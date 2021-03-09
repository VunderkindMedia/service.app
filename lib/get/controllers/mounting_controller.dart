import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:service_app/models/construction_type.dart';
import 'package:service_app/models/mounting_image.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/models/service_status.dart';
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
  final picker = ImagePicker();

  RxBool locked = false.obs;
  RxBool needSync = false.obs;
  RxBool isLoading = false.obs;
  Rx<Mounting> mounting = Mounting(-1).obs;
  Rx<Brand> brand = Brand(-1).obs;
  Rx<ConstructionType> constructionType = ConstructionType("").obs;
  Rx<MountingStage> currentStage = MountingStage("").obs;
  RxList<Stage> constructionStages = <Stage>[].obs;
  RxList<MountingStage> mountingStages = <MountingStage>[].obs;
  RxList<MountingImage> mountingImages = <MountingImage>[].obs;

  Rx<Widget> mainAction;

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

    var button = await buildCurrentAction();
    mainAction = button.obs;

    mountingStages.listen((stage) async {
      var button = await buildCurrentAction();
      mainAction.value = button;
    });
    currentStage.listen((stage) async {
      var button = await buildCurrentAction();
      mainAction.value = button;
    });
  }

  void disposeController() {
    mountingStages.clear();
    mountingImages.clear();

    locked = false.obs;
    needSync = false.obs;
    mounting = Mounting(-1).obs;
    currentStage = MountingStage("").obs;
  }

  Future<void> refreshMountingStages() async {
    var dbStages = await _dbService.getMountingStages(mounting.value.id);
    mountingStages.assignAll(dbStages);

    print('updt mounting stages');

    switch (dbStages.length) {
      case 0:
        currentStage.value = MountingStage.initStage(
            mounting.value, constructionStages[0], accountController.personId);
        break;
      case 1:
        currentStage.value = MountingStage.initStage(
            mounting.value, constructionStages[1], accountController.personId);
        break;
      case 2:
        currentStage.value = MountingStage.initStage(
            mounting.value, constructionStages[2], accountController.personId);
        break;
    }
  }

  Future<void> refreshMountingImages() async {
    var dbImages = await _dbService.getMountingImages(mounting.value.id);
    mountingImages.assignAll(dbImages);

    print('updt mounting images');
  }

  Future<void> stageCheck() async {
    var finishedStage = currentStage.value;

    await Get.defaultDialog(
        title: 'Подтвердите выполнение',
        titleStyle: kCardTitleStyle,
        content: Text(
          'Этап ${finishedStage.stage.name}',
          style: kCardTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              finishedStage.result = StageResult.Done;
              await _dbService.addMountingStage(finishedStage).then(
                  (value) => syncController.syncMountingStage(finishedStage));

              await refreshMountingStages();

              Get.back();
            },
            child: Text('Выполнен'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
            },
            child: Text('Отмена'),
          )
        ]);
  }

  Widget mountingInit() {
    return FloatingButton(
      label: currentStage.value.stage.name,
      heroTag: 'mfab',
      color: kFabActionColor,
      alignment: Alignment.bottomCenter,
      onPressed: () async {
        await stageCheck();
      },
      iconData: Icons.handyman,
      extended: true,
      isSecondary: true,
    );
  }

  Widget mountingDone() {
    return FloatingButton(
      label: currentStage.value.stage.name,
      heroTag: 'mfab',
      color: kFabAcceptColor,
      alignment: Alignment.bottomCenter,
      onPressed: () async {
        await stageCheck();
      },
      iconData: Icons.done,
      extended: true,
      isSecondary: true,
    );
  }

  Widget mountingFinish() {
    return FloatingButton(
      label: currentStage.value.stage.name,
      heroTag: 'mfab',
      color: kFabAcceptColor,
      alignment: Alignment.bottomCenter,
      onPressed: () async {
        isLoading.value = true;

        PickedFile image = await picker.getImage(
          source: ImageSource.camera,
          imageQuality: 60,
        );
        if (image != null) {
          var finishedStage = currentStage.value;
          finishedStage.result = StageResult.Done;
          await _dbService
              .addMountingStage(finishedStage)
              .then((value) => syncController.syncMountingStage(finishedStage));

          String imagePath = image.path;
          await ImageGallerySaver.saveFile(imagePath);
          await addMountingImage(currentStage.value, imagePath);

          await refreshMountingStages();
          await finishMounting();
        } else {
          Get.defaultDialog(
            title: 'Ошибка',
            titleStyle: kCardTitleStyle,
            content: Center(
              child: Text(
                'Для завершения этапа нужно сфотографировать акт выполненных работ',
                style: kCardTextStyle,
              ),
            ),
          );
        }

        isLoading.value = false;
      },
      iconData: Icons.list_alt,
      extended: true,
      isSecondary: true,
    );
  }

  Widget mountingFinished() {
    return Visibility(
      visible: false,
      child: FloatingActionButton.extended(
        onPressed: null,
        backgroundColor: kFabAcceptColor,
        label: Text('Монтаж завершен'),
      ),
    );
  }

  Future<Widget> buildCurrentAction() async {
    var actionWidget;

    if (currentStage.value.id.isEmpty) return mountingFinished();

    switch (mountingStages.length) {
      case 0:
        actionWidget = mountingInit();
        break;
      case 1:
        actionWidget = mountingDone();
        break;
      case 2:
        actionWidget = mountingFinish();
        break;
      case 3:
        actionWidget = mountingFinished();
        break;
    }

    var gotUnstagedChanges = false;
    mountingStages?.forEach((st) {
      gotUnstagedChanges = gotUnstagedChanges || st.export;
    });
    mountingImages?.forEach((im) {
      gotUnstagedChanges = gotUnstagedChanges || im.export;
    });
    needSync.value = gotUnstagedChanges;

    return actionWidget;
  }

  Future<void> finishMounting() async {
    mounting.value.actCommited = true;

    await _dbService.saveMountings([mounting.value]).then(
        (value) => syncController.syncMounting(mounting.value));
  }

  Future<void> editMountingStage(MountingStage stage, String comment) async {
    stage.comment = comment;
    stage.export = true;

    await _dbService
        .addMountingStage(stage)
        .then((value) => syncController.syncMountingStage(stage, resync: true));
  }

  Future<void> addMountingImage(MountingStage stage, String imagePath) async {
    var mountingImage = new MountingImage(Uuid().v1());

    mountingImage.mountingId = stage.mountingId;
    mountingImage.stageId = stage.stageId;
    mountingImage.local = imagePath;
    mountingImage.export = true;

    await syncController.saveMountingImage(mountingImage).whenComplete(() =>
        syncController
            .syncMountingImage(mountingImage)
            .then((value) => refreshMountingImages()));
  }

  Future<void> deleteMountingImage(MountingImage mountingImage) async {
    await syncController
        .deleteMountingImage(mountingImage)
        .then((value) => refreshMountingImages());
  }
}
