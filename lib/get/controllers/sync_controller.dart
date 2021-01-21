import 'package:get/get.dart';
import 'package:service_app/constants/api.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';

class SyncController extends GetxController {
  RxString syncStatus = SyncStatus.OK.obs;
  Rx<DateTime> _lastSyncDate = DateTime.now().obs;
  RxList<Service> _services = <Service>[].obs;
  RxList<ServiceGood> _serviceGoods = <ServiceGood>[].obs;
  RxList<ServiceImage> _serviceImages = <ServiceImage>[].obs;

  ApiService _apiService;
  DbService _dbService;
  SharedPreferencesService _sharedPreferencesService;
  String _personId;
  String _token;

  @override
  void onInit() async {
    super.onInit();

    _apiService = Get.find();
    _dbService = Get.find();
    _sharedPreferencesService = Get.find();

    _lastSyncDate.value = _sharedPreferencesService.getLastSyncDate();
    _token = _sharedPreferencesService.getAccessToken();
    _personId = _sharedPreferencesService.getPersonExternalId();

    var expServices = await _dbService.getExportServices(_personId);
    var expServiceGoods = await _dbService.getExportServiceGoods();
    var expServiceImages = await _dbService.getExportServiceImages();

    _services.assignAll(expServices);
    _serviceGoods.assignAll(expServiceGoods);
    _serviceImages.assignAll(expServiceImages);

    _lastSyncDate.listen((value) {
      _sharedPreferencesService.setLastSyncDate(value);
    });
  }

  void disposeController() {
    _lastSyncDate.value = null;
    _services.clear();
    _serviceGoods.clear();
    _serviceImages.clear();
  }

  Future<void> sync() async {
    try {
      syncStatus.value = SyncStatus.Loading;

      await _syncBrands();
      await _syncGoods();
      await _syncGoodPrices();
      await _syncServices();

      _serviceGoods.forEach((sg) async {
        await syncServiceGood(sg, resync: true);
      });
      _serviceImages.forEach((si) async {
        await syncServiceImage(si, resync: true);
      });
      _services.forEach((s) async {
        await syncService(s, resync: true);
      });

      _lastSyncDate.value = DateTime.now();
    } catch (e) {
      syncStatus.value = SyncStatus.Error;
    } finally {
      syncStatus.value = SyncStatus.OK;
    }
  }

  Future<void> _syncServices() async {
    var services = await _apiService.getServices(_token, _lastSyncDate.value);
    await _dbService.saveServices(services);
  }

  Future<void> _syncBrands() async {
    var brands = await _apiService.getBrands(_token, _lastSyncDate.value);
    await _dbService.saveBrands(brands);
  }

  Future<void> _syncGoods() async {
    var goods = await _apiService.getGoods(_token, _lastSyncDate.value);
    await _dbService.saveGoods(goods);
  }

  Future<void> _syncGoodPrices() async {
    var goodPrices =
        await _apiService.getGoodPrices(_token, _lastSyncDate.value);
    await _dbService.saveGoodPrices(goodPrices);
  }

  Future<void> saveService(Service service) async {
    await _dbService.saveServices([service]);
  }

  Future<void> syncService(Service service, {bool resync = false}) async {
    await _apiService.setService(service, _token).then((result) async {
      if (result != null) {
        await _dbService.saveServices([result]);
        if (resync) _services.remove(service);
      } else if (!resync) _services.add(service);
    });
  }

  Future<void> saveServiceGood(ServiceGood serviceGood) async {
    await _dbService.addServiceGood(serviceGood);
  }

  Future<void> syncServiceGood(ServiceGood serviceGood,
      {bool resync = false}) async {
    await _apiService.addServiceGood(serviceGood, _token).then((result) async {
      if (result != null) {
        await _dbService.addServiceGood(result);
        if (resync) _serviceGoods.remove(serviceGood);
      } else if (!resync) _serviceGoods.add(serviceGood);
    });
  }

  Future<void> deleteServiceGood(
      Service service, ServiceGood serviceGood) async {
    var deleted = true;
    if (!serviceGood.export)
      deleted = await _apiService.deleteServiceGood(serviceGood, _token);

    if (deleted) await _dbService.deleteServiceGood(serviceGood);
  }

  Future<void> saveServiceImage(ServiceImage serviceImage) async {
    await _dbService.addServiceImage(serviceImage);
  }

  Future<void> syncServiceImage(ServiceImage serviceImage,
      {bool resync = false}) async {
    await _apiService
        .addServiceImage(serviceImage, _token)
        .then((result) async {
      if (result) {
        serviceImage.export = false;
        await _dbService.addServiceImage(serviceImage);
        if (resync) _serviceImages.remove(serviceImage);
      } else if (!resync) _serviceImages.add(serviceImage);
    });
  }

  Future<void> deleteServiceImage(
      Service service, ServiceImage serviceImage) async {
    var deleted = true;
    if (!serviceImage.export)
      deleted = await _apiService.deleteServiceImage(serviceImage, _token);

    if (deleted) await _dbService.deleteServiceImage(serviceImage);
  }

  String getServiceImageUrl(ServiceImage serviceImage) {
    return '$API_FILES/service/${serviceImage.fileId}';
  }

  String getAuthToken() {
    return _token;
  }
}

class SyncStatus {
  static const OK = 'ok';
  static const Loading = 'loading';
  static const Error = 'error';
  static const NoInternet = 'noInternet';
}
