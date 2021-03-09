import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';

class ServiceController extends GetxController {
  final SyncController syncController = Get.find();
  final ServicesController servicesController = Get.find();
  final AccountController accountController = Get.find();

  Rx<Service> service = Service(-1).obs;
  Rx<Brand> brand = Brand(-1).obs;
  RxBool locked = true.obs;
  RxList<ServiceGood> serviceGoods = <ServiceGood>[].obs;
  RxList<ServiceImage> serviceImages = <ServiceImage>[].obs;

  RxString search = ''.obs;
  RxList<Good> goods = <Good>[].obs;
  RxList<Good> filteredGoods = <Good>[].obs;
  RxList<GoodPrice> goodPrices = <GoodPrice>[].obs;
  RxList<DateTime> closedDates = <DateTime>[].obs;

  DbService _dbService;

  RxString fabsState = FabsState.Main.obs;
  RxString workType = ''.obs;

  Future<ServiceController> initialinit() async {
    return this;
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    _dbService = Get.find();

    fabsState.listen((value) {
      refreshFabButtons(null);
    });

    search.listen((value) {
      refreshGoods();
    });
  }

  Future<void> init(int serviceId) async {
    var dbService = await _dbService.getServiceById(serviceId);
    var brand = servicesController.brands
        .firstWhere((brand) => brand.externalId == dbService.brandId);
    this.service.value = dbService;
    this.brand.value = brand;

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
    await updateClosedDates();

    if (service.value.status == ServiceStatus.Start &&
        service.value.userId == accountController.personId)
      locked.value = false;
    else
      locked.value = true;
  }

  void disposeController() {
    service = Service(-1).obs;
    locked = false.obs;
    workType = ''.obs;
    serviceGoods.clear();
    serviceImages.clear();
    closedDates.clear();
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

  Future<void> updateClosedDates() async {
    var dbClosedDates =
        await _dbService.getClosedDates(this.service.value.cityId);
    dbClosedDates.forEach((cldate) {
      closedDates.add(DateTime.parse(cldate.date));
    });
  }

  Future<void> saveServiceChanges(Service service) async {
    await syncController.saveService(service).then((value) {
      init(service.id);
    }).whenComplete(
      () => syncController.syncService(service).then(
            (value) => servicesController.ref(
                servicesController.selectedDateStart.value,
                servicesController.selectedDateEnd.value),
          ),
    );
  }

  Future<void> addServiceImage(String imageName, String imagePath) async {
    var serviceImage = new ServiceImage(Uuid().v1());
    serviceImage.serviceId = service.value.id;
    serviceImage.fileName = '';
    serviceImage.local = imagePath;
    serviceImage.export = true;

    await syncController.saveServiceImage(serviceImage).whenComplete(() =>
        syncController
            .syncServiceImage(serviceImage)
            .then((value) => refreshServiceImages()));
  }

  Future<void> deleteServiceImage(ServiceImage serviceImage) async {
    await syncController
        .deleteServiceImage(serviceImage)
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

    await syncController.saveServiceGood(serviceGood).whenComplete(() =>
        syncController
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

    await saveServiceChanges(service);
  }

  Future<void> rescheduleService(
      Service service, DateTime nextDate, String userComment) async {
    service.state = ServiceState.Exported;
    service.status = ServiceStatus.DateSwap;
    service.userComment = 'Желаемая дата $nextDate\n' + userComment;
    service.export = true;

    saveServiceChanges(service);
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

    saveServiceChanges(service);
  }

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
          color: kFabRefuseColor,
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
          color: kFabAcceptColor,
        )
      ];

  Widget refreshFabButtons(Function callback) {
    var fabs = <Widget>[];
    var fabsSecondary = <Widget>[];

    if (service.value.id == -1 ||
        service.value.userId != accountController.personId) return SizedBox();

    switch (fabsState.value) {
      case FabsState.Main:
        switch (service.value.state) {
          case ServiceState.New:
          case ServiceState.WorkInProgress:
          case ServiceState.Updated:
            if (service.value.status == ServiceStatus.Start) {
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
        break;
      case FabsState.AddImage:
        break;
      case FabsState.RefusePage:
        break;
      case FabsState.ReschedulePage:
        break;
      case FabsState.PaymentPage:
        break;
      default:
    }

    if (fabsSecondary.length == 0) {
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
    } else {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: fabsSecondary,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: fabs,
            )
          ],
        ),
      );
    }
  }

  void refreshGoods() {
    if (search.value.length > 0)
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
