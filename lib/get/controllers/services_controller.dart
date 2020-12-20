import 'package:get/get.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/models/service.dart';

class ServicesController extends GetxController {
  var isLoading = false.obs;
  var isSynchronized = false.obs;
  Rx<DateTime> lastSyncDate = DateTime.now().obs;
  var hideFinished = false.obs;
  RxList<Brand> brands = <Brand>[].obs;
  RxList<Service> _services = <Service>[].obs;
  RxList<Service> filteredServices = <Service>[].obs;

  ApiService _apiService;
  DbService _dbService;
  SharedPreferencesService _sharedPreferencesService;
  String _token;

  @override
  void onInit() {
    super.onInit();

    _apiService = Get.find();
    _dbService = Get.find();
    _sharedPreferencesService = Get.find();
    _token = _sharedPreferencesService.getAccessToken();

    hideFinished.listen((value) => _updateFilteredServices());
    _services.listen((value) => _updateFilteredServices());


    sync();
  }

  void sync() async {
    try {
      isLoading.value = true;

      await _syncBrands();
      await _syncServices();

      lastSyncDate.value = DateTime.now();
      isSynchronized.value = true;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _syncServices() async {
    var dbServices = await _dbService.getServices();
    _services.assignAll(dbServices);

    var services = await _apiService.getServices(_token);
    await _dbService.saveServices(services);
    _services.assignAll(services);
  }

  Future<void> _syncBrands() async {
    var dbBrands = await _apiService.getBrands(_token);
    this.brands.assignAll(dbBrands);

    var brands = await _apiService.getBrands(_token);
    await _dbService.saveBrands(brands);
    this.brands.assignAll(brands);
  }

  void _updateFilteredServices() {
    filteredServices.assignAll(_services.where((service) => hideFinished.value ? service.status != ServiceStatus.End : true).toList());
  }
}
