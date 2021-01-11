import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';
import 'package:service_app/widgets/payment_page/payment_page.dart';
import 'package:service_app/widgets/refuse_page/refuse_page.dart';
import 'package:service_app/widgets/reschedule_page/reschedule_page.dart';
import 'package:service_app/widgets/goods_page/goods_page.dart';

class ServiceController extends GetxController {
  Rx<Service> service = Service(-1).obs;
  RxList<ServiceGood> serviceGoods = <ServiceGood>[].obs;
  RxList<ServiceImage> serviceImages = <ServiceImage>[].obs;

  RxList<Good> goods = <Good>[].obs;
  RxList<GoodPrice> goodPrices = <GoodPrice>[].obs;

  ApiService _apiService;
  DbService _dbService;
  SharedPreferencesService _sharedPreferencesService;
  String _token;
  String _personId;

  RxString fabsState = FabsState.Main.obs;
  RxString workType = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    _apiService = Get.find();
    _dbService = Get.find();
    _sharedPreferencesService = Get.find();

    _token = _sharedPreferencesService.getAccessToken();
    _personId = _sharedPreferencesService.getPersonExternalId();

    var dbGoods = await _dbService.getGoods();
    goods.assignAll(dbGoods);

    var dbGoodPrices = await _dbService.getGoodPrices();
    goodPrices.assignAll(dbGoodPrices);

    fabsState.listen((value) {
      refreshFabButtons(null);
    });
  }

  Future<void> init(int serviceId) async {
    var dbService = await _dbService.getServiceById(serviceId);
    this.service.value = dbService;

    await refreshServiceGoods();
    await refreshServiceImages();
  }

  @override
  void dispose() {
    super.dispose();

    service = Service(-1).obs;
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

  Future<void> addServiceGood(
      Good good, String construction, GoodPrice goodPrice, int qty) async {
    var price = goodPrice == null ? 0 : goodPrice.price;

    var serviceGood = new ServiceGood(-1);
    serviceGood.workType = workType.value;
    serviceGood.serviceId = service.value.id;
    serviceGood.construction = construction;
    serviceGood.goodId = good.id;
    serviceGood.price = price * 100;
    serviceGood.qty = qty * 100;
    serviceGood.sum = price * qty * 100;

    var appliedServiceGood =
        await _apiService.setServiceGood(service.value, serviceGood, _token);

    await _dbService
        .addServiceGood(
            appliedServiceGood == null ? serviceGood : appliedServiceGood)
        .then((value) async {
      await refreshServiceGoods();
    });
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
        ),
      ];

  List<Widget> _addGoodFabs() => <Widget>[
        FloatingButton(
          label: 'Добавить',
          heroTag: 'rfab',
          alignment: Alignment.bottomRight,
          onPressed: () {
            fabsState.value = FabsState.AddGood;
            Get.to(GoodsPage());
          },
          iconData: Icons.add,
          extended: true,
        ),
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

  List<Widget> _refusePageFabs() => <Widget>[
        FloatingButton(
          label: 'Отказ',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            fabsState.value = FabsState.Main;
            Get.back();
            print('refusing');
          },
          iconData: Icons.cancel,
          extended: true,
        ),
      ];

  List<Widget> _reschedulePage() => <Widget>[
        FloatingButton(
          label: 'Перенос даты',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            fabsState.value = FabsState.Main;
            Get.back();
            print('reshelduing');
          },
          iconData: Icons.calendar_today_rounded,
          extended: true,
        ),
      ];

  List<Widget> _paymentPage() => <Widget>[
        FloatingButton(
          label: 'Принять оплату',
          heroTag: 'mfab',
          alignment: Alignment.bottomCenter,
          onPressed: () {
            fabsState.value = FabsState.Main;
            Get.back();
            print('payment');
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
        fabs.addAll(Iterable.castFrom(_mainFabs()));
        break;
      case FabsState.AddGood:
        fabs.addAll(Iterable.castFrom(_addGoodFabs()));
        break;
      case FabsState.GoodAdding:
        fabs.addAll(Iterable.castFrom(_goodAddingFabs(callback)));
        break;
      case FabsState.RefusePage:
        fabs.addAll(Iterable.castFrom(_refusePageFabs()));
        break;
      case FabsState.ReschedulePage:
        fabs.addAll(Iterable.castFrom(_reschedulePage()));
        break;
      case FabsState.PaymentPage:
        fabs.addAll(Iterable.castFrom(_paymentPage()));
        break;
    }

    if (fabs.length > 1) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: fabs,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: fabs.first,
      );
    }
  }

  List<Good> getChildrenGoodsByParent(Good parent) {
    if (parent == null) {
      return goods
          .where((good) =>
              goods.firstWhere((g) => g.externalId == good.parentId,
                  orElse: () => null) ==
              null)
          .toList();
    }
    return goods.where((good) => good.parentId == parent.externalId).toList();
  }
}