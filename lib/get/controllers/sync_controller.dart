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
  RxBool _needSync = false.obs;
  RxBool _isSync = false.obs;

  ApiService _apiService;
  DbService _dbService;
  SharedPreferencesService _sharedPreferencesService;
  String _personId;
  String _token;

  bool get needSync => _needSync.value;
  bool get isSync => _isSync.value;

  @override
  void onInit() async {
    super.onInit();

    _apiService = Get.find();
    _dbService = Get.find();
    _sharedPreferencesService = Get.find();

    _lastSyncDate.value = _sharedPreferencesService.getLastSyncDate();
    _token = _sharedPreferencesService.getAccessToken();
    _personId = _sharedPreferencesService.getPersonExternalId();

    _lastSyncDate.listen((value) {
      _sharedPreferencesService.setLastSyncDate(value);
    });

    _needSync.listen((value) {
      _sharedPreferencesService.setNeedSync(value);
    });
  }

  void disposeController() {
    _lastSyncDate.value = null;
  }

  Future<void> sync(DateTime dateStart, DateTime dateEnd) async {
    if (_isSync.value) return;

    _isSync.value = true;

    try {
      syncStatus.value = SyncStatus.Loading;

      _syncBrands();
      _syncGoods();
      _syncGoodPrices();
      _syncNotifications();

      await _syncServices(
        dateStart,
        dateEnd,
      );

      await _dbService.getExportServiceGoods().then((serviceGoods) async {
        await Future.forEach(serviceGoods, (sg) async {
          await syncServiceGood(sg, resync: true);
        });
      });

      await _dbService.getExportServiceImages().then((serviceImages) async {
        await Future.forEach(serviceImages, (si) async {
          await syncServiceImage(si, resync: true);
        });
      });

      await _dbService.getExportServices(_personId).then((services) async {
        await Future.forEach(services, (s) async {
          await syncService(s, resync: true);
        });
      });

      _lastSyncDate.value = DateTime.now();
      if (_needSync.value) _needSync.value = false;
    } catch (e) {
      syncStatus.value = SyncStatus.Error;
      await Get.defaultDialog(
        title: "Нет сети",
        middleText:
            "Не удалось подключиться к серверу, попробуйте позднее, когда будет интернет",
      );
    } finally {
      syncStatus.value = SyncStatus.OK;
    }

    _isSync.value = false;
  }

  Future<bool> syncClosedDates(String cityId) async {
    _apiService
        .getClosedDates(_token, cityId, _lastSyncDate.value)
        .then((cldates) async {
      if (cldates.length > 0) {
        await _dbService.saveClosedDates(cldates);
        return true;
      }
      return false;
    });
    return false;
  }

  Future<void> _syncServices(DateTime dateStart, DateTime dateEnd) async {
    var services = await _apiService.getServices(
        _token, _lastSyncDate.value, dateStart, dateEnd);
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

  Future<void> _syncNotifications() async {
    var notifications =
        await _apiService.getNotifications(_token, _lastSyncDate.value);
    await _dbService.savePush(notifications);
  }

  Future<void> saveService(Service service) async {
    await _dbService.saveServices([service]);
  }

  Future<void> syncService(Service service, {bool resync = false}) async {
    await _apiService.setService(service, _token).then((result) async {
      if (result != null) {
        await saveService(result);
      } else if (!_needSync.value) {
        _needSync.value = true;
      }
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
      } else if (!_needSync.value) {
        _needSync.value = true;
      }
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
        .then((imageModel) async {
      if (imageModel != null) {
        await _dbService.addServiceImage(imageModel);
      } else if (!_needSync.value) {
        _needSync.value = true;
      }
    });
  }

  Future<void> deleteServiceImage(ServiceImage serviceImage) async {
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
