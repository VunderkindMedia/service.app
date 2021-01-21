import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';
import 'package:service_app/widgets/payment_page/payment_page.dart';
import 'package:service_app/widgets/refuse_page/refuse_page.dart';
import 'package:service_app/widgets/reschedule_page/reschedule_page.dart';

class ServiceController extends GetxController {
  final SyncController syncController = Get.find();
  final ServicesController servicesController = Get.find();
  final picker = ImagePicker();

  Rx<Service> service = Service(-1).obs;
  RxBool locked = true.obs;
  RxList<ServiceGood> serviceGoods = <ServiceGood>[].obs;
  RxList<ServiceImage> serviceImages = <ServiceImage>[].obs;

  RxString search = ''.obs;
  RxBool isSarching = false.obs;
  RxList<Good> goods = <Good>[].obs;
  RxList<Good> filteredGoods = <Good>[].obs;
  RxList<GoodPrice> goodPrices = <GoodPrice>[].obs;

  DbService _dbService;

  RxString fabsState = FabsState.Main.obs;
  RxString workType = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    _dbService = Get.find();

    fabsState.listen((value) {
      refreshFabButtons(null);
    });
  }

  Future<void> init(int serviceId) async {
    var dbService = await _dbService.getServiceById(serviceId);
    this.service.value = dbService;

    var resync = goodPrices.length > 0
        ? goodPrices.first.brandId != dbService.brandId
        : true;

    if (resync) {
      var dbGoods = await _dbService.getGoods(dbService);
      goods.assignAll(dbGoods);

      var dbGoodPrices = await _dbService.getGoodPrices(dbService);
      goodPrices.assignAll(dbGoodPrices);
    }

    workType = ''.obs;
    await refreshServiceGoods();
    await refreshServiceImages();

    if (service.value.status == ServiceStatus.Start) locked.value = false;
  }

  void disposeController() {
    service = Service(-1).obs;
    locked = true.obs;
    workType = ''.obs;
    serviceGoods.clear();
    serviceImages.clear();
  }

  Future<void> refreshServiceGoods() async {
    if (service.value.id == -1) return;

    var sGoods = await _dbService.getServiceGoods(service.value.id);
    serviceGoods.assignAll(sGoods);

    print('updt sgoods');
  }

  Future<void> refreshServiceImages() async {
    if (service.value.id == -1) return;

    var sImages = await _dbService.getServiceImages(service.value.id);
    serviceImages.assignAll(sImages);
    print('updt simages');
  }

  Future<void> addServiceImage(String imageName, String imagePath) async {
    var serviceImage = new ServiceImage(Uuid().v1());
    serviceImage.serviceId = service.value.id;
    serviceImage.fileName = '';
    serviceImage.local = imagePath;
    serviceImage.export = true;

    await syncController
        .saveServiceImage(serviceImage)
        .then((value) => refreshServiceImages())
        .whenComplete(() => syncController
            .syncServiceImage(serviceImage)
            .then((value) => refreshServiceImages()));
  }

  Future<void> deleteServiceImage(ServiceImage serviceImage) async {
    await syncController
        .deleteServiceImage(service.value, serviceImage)
        .then((value) => refreshServiceImages());
  }

  Future<void> addServiceGood(
      Good good, String construction, GoodPrice goodPrice, double qty) async {
    var price = goodPrice == null ? 0 : goodPrice.price;

    var serviceGood = new ServiceGood(Uuid().v1());
    serviceGood.workType = workType.value;
    serviceGood.serviceId = service.value.id;
    serviceGood.construction = construction;
    serviceGood.goodId = good.id;
    serviceGood.price = price;
    serviceGood.qty = (qty * 100).round().toInt();
    serviceGood.sum = (price * qty * 100).round().toInt();
    serviceGood.export = true;

    await syncController
        .saveServiceGood(serviceGood)
        .then((value) => refreshServiceGoods())
        .whenComplete(() => syncController
            .syncServiceGood(serviceGood)
            .then((value) => refreshServiceGoods()));
  }

  Future<void> deleteServiceGood(ServiceGood serviceGood) async {
    await syncController
        .deleteServiceGood(service.value, serviceGood)
        .then((value) => refreshServiceGoods());
  }

  Future<void> refuseService(
      Service service, String reason, String userComment) async {
    service.state = ServiceState.Exported;
    service.status = ServiceStatus.Refuse;
    service.refuseReason = reason;
    service.userComment = userComment;
    service.export = true;

    await syncController.saveService(service).then((value) {
      init(service.id);
      servicesController.ref(DateTime.now());
    }).whenComplete(() => syncController
        .syncService(service)
        .then((value) => servicesController.ref(DateTime.now())));
  }

  Future<void> rescheduleService(
      Service service, DateTime nextDate, String userComment) async {
    service.state = ServiceState.Exported;
    service.status = ServiceStatus.DateSwap;
    service.userComment = 'Желаемая дата $nextDate\n' + userComment;
    service.export = true;

    await syncController.saveService(service).then((value) {
      init(service.id);
      servicesController.ref(DateTime.now());
    }).whenComplete(() => syncController
        .syncService(service)
        .then((value) => servicesController.ref(DateTime.now())));
  }

  Future<void> finishService(
      Service service,
      String customerDecision,
      DateTime dateNext,
      String userComment,
      String paymentType,
      int sumTotal,
      int sumPayment,
      int sumDiscount) async {
    service.state = ServiceState.Exported;
    service.status = ServiceStatus.Done;
    service.dateStartNext = dateNext;
    service.dateEndNext = dateNext;
    service.userComment = userComment;
    service.customerDecision = customerDecision;
    service.paymentType = paymentType;
    service.sumTotal = sumTotal;
    service.sumPayment = sumPayment;
    service.sumDiscount = sumDiscount;
    service.export = true;

    await syncController.saveService(service).then((value) {
      init(service.id);
      servicesController.ref(DateTime.now());
    }).whenComplete(() => syncController
        .syncService(service)
        .then((value) => servicesController.ref(DateTime.now())));
  }

  List<Widget> _mainFabs() => <Widget>[
        FloatingButton(
          label: 'Отменить заявку',
          heroTag: 'lfab',
          alignment: Alignment.bottomLeft,
          onPressed: () {
            fabsState.value = FabsState.RefusePage;
            Get.to(RefusePage());
          },
          iconData: Icons.cancel,
        ),
        FloatingButton(
          label: 'Перенести дату заявки',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            fabsState.value = FabsState.ReschedulePage;
            Get.to(ReschedulePage());
          },
          iconData: Icons.calendar_today_rounded,
        ),
        FloatingButton(
          label: 'Завершить',
          heroTag: 'rfab',
          alignment: Alignment.bottomRight,
          onPressed: () {
            fabsState.value = FabsState.PaymentPage;
            Get.to(PaymentPage());
          },
          iconData: Icons.check_circle,
          extended: true,
        ),
      ];

  List<Widget> _exportedFabs() => <Widget>[
        FloatingButton(
          label: 'Выгрузка...',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: null,
          iconData: Icons.pending,
          extended: true,
        )
      ];

  List<Widget> _exportErrorFabs() => <Widget>[
        FloatingButton(
          label: 'Ошибка выгрузки!',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: null,
          iconData: Icons.error_outline,
          extended: true,
        )
      ];

  List<Widget> _finisedFabs() => <Widget>[
        FloatingButton(
          label: 'Заявка выполнена',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: null,
          iconData: Icons.check_box,
          extended: true,
        )
      ];

  List<Widget> _goodAddingFabs(Function callback) => <Widget>[
        FloatingButton(
          label: 'Добавить',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            callback();
            fabsState.value = FabsState.GoodAdding;
            Get.back();
            print('adding good');
          },
          iconData: Icons.add,
          extended: true,
        ),
      ];

  List<Widget> _imageAddingFabs(Function callback) => <Widget>[
        FloatingButton(
          label: 'Вложение',
          heroTag: 'lfab',
          alignment: Alignment.bottomLeft,
          onPressed: () async {
            PickedFile image = await picker.getImage(
              source: ImageSource.gallery,
              imageQuality: 60,
            );
            if (image != null) {
              String imagePath = image.path;
              await ImageGallerySaver.saveFile(imagePath);
              await addServiceImage(
                  DateTime.now().microsecondsSinceEpoch.toString() + '.png',
                  imagePath);
            }
            print('galerry image');
          },
          iconData: Icons.library_add,
          extended: true,
        ),
        FloatingButton(
          label: 'Камера',
          heroTag: 'rfab',
          alignment: Alignment.bottomRight,
          onPressed: () async {
            PickedFile image = await picker.getImage(
              source: ImageSource.camera,
              imageQuality: 60,
            );
            if (image != null) {
              String imagePath = image.path;
              await ImageGallerySaver.saveFile(imagePath);
              await addServiceImage(
                  DateTime.now().microsecondsSinceEpoch.toString() + '.png',
                  imagePath);
            }
            print('camera image');
          },
          iconData: Icons.camera_alt,
          extended: true,
        )
      ];

  List<Widget> _refusePageFabs(Function callback) => <Widget>[
        FloatingButton(
          label: 'Отказ',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            callback();

            if (fabsState.value == FabsState.Main) {
              Get.back();
              print('refusing');
            }
          },
          iconData: Icons.cancel,
          extended: true,
        ),
      ];

  List<Widget> _reschedulePage(Function callback) => <Widget>[
        FloatingButton(
          label: 'Перенос даты',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            callback();

            if (fabsState.value == FabsState.Main) {
              Get.back();
              print('reshelduing');
            }
          },
          iconData: Icons.calendar_today_rounded,
          extended: true,
        ),
      ];

  List<Widget> _paymentPage(Function callback) => <Widget>[
        FloatingButton(
          label: 'Принять оплату',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            callback();

            if (fabsState.value == FabsState.Main) {
              Get.back();
              print('payment');
            }
          },
          iconData: Icons.check_circle,
          extended: true,
        ),
      ];

  Widget refreshFabButtons(Function callback) {
    var fabs = <Widget>[];

    if (service.value.id == -1) return FloatingActionButton(onPressed: null);

    switch (fabsState.value) {
      case FabsState.Main:
        switch (service.value.state) {
          case ServiceState.New:
          case ServiceState.WorkInProgress:
          case ServiceState.Updated:
            if (service.value.status == ServiceStatus.Start) {
              fabs.addAll(Iterable.castFrom(_mainFabs()));
              locked.value = false;
            } else if (service.value.status == ServiceStatus.End)
              fabs.addAll(_finisedFabs());
            break;
          case ServiceState.Exported:
          case ServiceState.WorkFinished:
            fabs.addAll(Iterable.castFrom(_exportedFabs()));
            break;
          case ServiceState.ExportError:
            fabs.addAll(Iterable.castFrom(_exportErrorFabs()));
            break;
          default:
        }
        break;
      case FabsState.GoodAdding:
        fabs.addAll(Iterable.castFrom(_goodAddingFabs(callback)));
        break;
      case FabsState.AddImage:
        fabs.addAll(Iterable.castFrom(_imageAddingFabs(callback)));
        break;
      case FabsState.RefusePage:
        fabs.addAll(Iterable.castFrom(_refusePageFabs(callback)));
        break;
      case FabsState.ReschedulePage:
        fabs.addAll(Iterable.castFrom(_reschedulePage(callback)));
        break;
      case FabsState.PaymentPage:
        fabs.addAll(Iterable.castFrom(_paymentPage(callback)));
        break;
      default:
    }

    if (fabs.length > 1) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: fabs,
        ),
      );
    } else if (fabs.length > 0) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: fabs.first,
      );
    } else {
      return SizedBox();
    }
  }

  void refreshGoods() {
    if (isSarching.value)
      filteredGoods.assignAll(goods
          .where((good) =>
              (good.name.toLowerCase().contains(search.value.toLowerCase()) ||
                  good.article
                      .toLowerCase()
                      .contains(search.value.toLowerCase())) &&
              !good.isGroup &&
              !good.deleteMark)
          .toList());
  }

  List<Good> getListGoodsByParent(Good parent) {
    if (parent == null) {
      return goods
          .where((good) =>
              goods.firstWhere((g) => g.externalId == good.parentId,
                  orElse: () => null) ==
              null)
          .toList();
    } else {
      return goods.where((good) => good.parentId == parent.externalId).toList();
    }
  }
}
