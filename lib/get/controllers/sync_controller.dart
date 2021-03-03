import 'package:get/get.dart';
import 'package:service_app/constants/api.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';

class SyncController extends GetxController {
  AccountController accountController = Get.find();
  ApiService _apiService = Get.find();
  DbService _dbService = Get.find();

  RxString syncStatus = SyncStatus.OK.obs;
  Rx<DateTime> _lastSyncDate = DateTime.now().obs;
  RxBool _needSync = false.obs;
  RxBool _isSync = false.obs;

  /* ApiService _apiService;
  DbService _dbService; */
  SharedPreferencesService _sharedPreferencesService;

  bool get needSync => _needSync.value;
  bool get isSync => _isSync.value;

  Future<SyncController> init() async {
    Get.put(SyncController());
    return this;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> initController() async {
    /* _apiService = Get.find();
    _dbService = Get.find(); */
    _sharedPreferencesService = Get.find();

    _lastSyncDate.value = _sharedPreferencesService.getLastSyncDate();

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

  Future<void> initServiceCatalogs() async {
    if (_isSync.value) return;

    _isSync.value = true;

    try {
      await Future.wait([
        _syncBrands(),
        _syncGoods(),
        _syncGoodPrices(),
        _syncNotifications(),
        _syncServices(null, null, true)
      ]);

      _lastSyncDate.value = DateTime.now();
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

  Future<void> initMountingCatalogs() async {
    if (_isSync.value) return;

    _isSync.value = true;

    try {
      await Future.wait([
        _syncBrands(),
        _syncConstructionTypes(),
        _syncStages(),
        _syncMountings(null, null, true),
      ]);

      _lastSyncDate.value = DateTime.now();
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

  Future<void> syncMountings(DateTime dateStart, DateTime dateEnd,
      [bool showError = true, bool syncAll = false]) async {
    try {
      syncStatus.value = SyncStatus.Loading;

      await _syncMountings(dateStart, dateEnd, syncAll);
    } catch (e) {
      syncStatus.value = SyncStatus.Error;
      if (showError)
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

  Future<void> syncServices(DateTime dateStart, DateTime dateEnd,
      [bool showError = true, bool syncAll = false]) async {
    /* TODO: why _apiService and _dbService here can be null after restart, but ok after login */
    /* if (_apiService == null) _apiService = Get.put(ApiService());
    if (_dbService == null) _dbService = Get.put(DbService()); */
    if (_isSync.value) return;

    _isSync.value = true;

    try {
      syncStatus.value = SyncStatus.Loading;

      _syncNotifications();

      await _syncServices(dateStart, dateEnd, syncAll);

      // Upload all changes to server
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

      await _dbService
          .getExportServices(accountController.personId)
          .then((services) async {
        await Future.forEach(services, (s) async {
          await syncService(s, resync: true);
        });
      });

      if (!syncAll) _lastSyncDate.value = DateTime.now();
      if (_needSync.value) _needSync.value = false;
    } catch (e) {
      syncStatus.value = SyncStatus.Error;
      if (showError)
        await Get.defaultDialog(
          title: "Нет сети",
          middleText:
              "Не удалось подключиться к серверу, попробуйте позднее, когда будет интернет\n$e",
        );
    } finally {
      syncStatus.value = SyncStatus.OK;
    }

    _isSync.value = false;
  }

  Future<bool> syncClosedDates(String cityId) async {
    _apiService
        .getClosedDates(accountController.token, cityId, _lastSyncDate.value)
        .then((cldates) async {
      if (cldates.length > 0) {
        await _dbService.saveClosedDates(cldates);
        return true;
      }
      return false;
    });
    return false;
  }

  Future<void> _syncServices(DateTime dateStart, DateTime dateEnd,
      [bool syncAll = false]) async {
    var services = await _apiService.getServices(accountController.token,
        syncAll ? null : _lastSyncDate.value, dateStart, dateEnd);
    if (services.length > 0) _dbService.saveServices(services);
  }

  Future<void> _syncMountings(DateTime dateStart, DateTime dateEnd,
      [bool syncAll = false]) async {
    var mountings = await _apiService.getMountings(
        accountController.token,
        accountController.personId,
        syncAll ? null : _lastSyncDate.value,
        dateStart,
        dateEnd);
    if (mountings.length > 0) await _dbService.saveMountings(mountings);
  }

  Future<void> _syncBrands() async {
    var brands = await _apiService.getBrands(
        accountController.token, _lastSyncDate.value);
    if (brands.length > 0) await _dbService.saveBrands(brands);
  }

  Future<void> _syncConstructionTypes() async {
    var constructionTypes =
        await _apiService.getConstructionTypes(accountController.token);
    if (constructionTypes.length > 0)
      await _dbService.saveConstructionTypes(constructionTypes);
  }

  Future<void> _syncStages() async {
    var stages = await _apiService.getStages(accountController.token);
    if (stages.length > 0) await _dbService.saveStages(stages);
  }

  Future<void> _syncGoods() async {
    var goods = await _apiService.getGoods(
        accountController.token, _lastSyncDate.value);
    if (goods.length > 0) await _dbService.saveGoods(goods);
  }

  Future<void> _syncGoodPrices() async {
    var goodPrices = await _apiService.getGoodPrices(
        accountController.token, _lastSyncDate.value);
    if (goodPrices.length > 0) await _dbService.saveGoodPrices(goodPrices);
  }

  Future<void> _syncNotifications() async {
    var notifications = await _apiService.getNotifications(
        accountController.token, _lastSyncDate.value);
    if (notifications.length > 0) await _dbService.savePush(notifications);
  }

  Future<void> saveService(Service service) async {
    await _dbService.saveServices([service]);
  }

  Future<void> syncService(Service service, {bool resync = false}) async {
    await _apiService
        .setService(service, accountController.token)
        .then((result) async {
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
    await _apiService
        .addServiceGood(serviceGood, accountController.token)
        .then((result) async {
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
      deleted = await _apiService.deleteServiceGood(
          serviceGood, accountController.token);

    if (deleted) await _dbService.deleteServiceGood(serviceGood);
  }

  Future<void> saveServiceImage(ServiceImage serviceImage) async {
    await _dbService.addServiceImage(serviceImage);
  }

  Future<void> syncServiceImage(ServiceImage serviceImage,
      {bool resync = false}) async {
    await _apiService
        .addServiceImage(serviceImage, accountController.token)
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
      deleted = await _apiService.deleteServiceImage(
          serviceImage, accountController.token);

    if (deleted) await _dbService.deleteServiceImage(serviceImage);
  }

  String getServiceImageUrl(ServiceImage serviceImage) {
    return '$API_FILES/service/${serviceImage.fileId}';
  }
}

class SyncStatus {
  static const OK = 'ok';
  static const Loading = 'loading';
  static const Error = 'error';
  static const NoInternet = 'noInternet';
}
