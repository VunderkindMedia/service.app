import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service.dart';

class ServicesController extends GetxController {
  final SyncController syncController = Get.find();
  final AccountController accountController = Get.find();

  var _isSync = false.obs;
  var isSearching = false.obs;

  Rx<DateTime> selectedDateStart =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  Rx<DateTime> selectedDateEnd = DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, 23, 59, 59)
      .obs;

  RxList<Service> _services = <Service>[].obs;
  RxList<Brand> brands = <Brand>[].obs;
  RxList<Service> filteredServices = <Service>[].obs;

  int get servicesCount =>
      filteredServices.length == 0 ? _services.length : filteredServices.length;
  bool get isSync => _isSync.value;

  String searchString = "";
  List<String> statusFilters = <String>[];

  DbService _dbService;

  Future<ServicesController> init() async {
    return this;
  }

  @override
  void onInit() async {
    super.onInit();

    _dbService = Get.find();

    _services.listen((value) => updateFilteredServices());

    ref(selectedDateStart.value, selectedDateEnd.value);
  }

  void disposeController() {
    _services.clear();
  }

  Future<void> sync(bool showError, [bool syncAll = false]) async {
    _isSync.value = true;
    await syncController
        .syncServices(
            selectedDateStart.value, selectedDateEnd.value, showError, syncAll)
        .then((value) async {
      await _refreshServices();
    });
    _isSync.value = false;
  }

  Future<void> ref(DateTime dtstart, DateTime dtend) async {
    try {
      selectedDateStart.value = dtstart;
      selectedDateEnd.value = dtend;

      await _refreshServices();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _refreshServices() async {
    if (brands.isEmpty) {
      var dbBrands = await _dbService.getBrands();
      brands.assignAll(dbBrands);
    }

    if (!isSearching.value) {
      DateTime d1 = selectedDateStart.value;
      DateTime d2 = selectedDateEnd.value;

      DateTime _dateStart = DateTime(d1.year, d1.month, d1.day);
      DateTime _dateEnd = DateTime(d2.year, d2.month, d2.day, 23, 59, 59);

      var dbServices = await _dbService.getServices(
          accountController.personId, _dateStart, _dateEnd);
      _services.assignAll(dbServices);
    }
    if (isSearching.value && searchString.isNotEmpty) {
      var dbServices = await _dbService.getServicesBySearch(
          accountController.personId, searchString);
      _services.assignAll(dbServices);
    }
  }

  void updateFilteredServices() {
    filteredServices.assignAll(_services
        .where((service) => statusFilters.length > 0
            ? service.checkStatus(statusFilters)
            : true)
        .toList());
  }

  void callMethod(BuildContext context, String phones) async {
    var phonesList = phones.split(",");
    var selectedPhone = "";

    if (phonesList.length > 1) {
      List<SimpleDialogOption> chooseList = [];

      phones.split(",").forEach((element) {
        SimpleDialogOption option = SimpleDialogOption(
          child: Text(element.trim()),
          onPressed: () {
            Navigator.pop(context, element);
          },
        );

        chooseList.add(option);
      });

      selectedPhone = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Выберите номер'),
              children: chooseList,
            );
          });
    } else {
      selectedPhone = phonesList.first;
    }

    if (selectedPhone != null) launch('tel:$selectedPhone');
  }

  void openNavigator(Service service) {
    if (service.lat != "" && service.lon != "") {
      MapsLauncher.launchCoordinates(
          double.parse(service.lat), double.parse(service.lon));
    } else {
      MapsLauncher.launchQuery('${service.getShortAddress()}');
    }
  }
}
