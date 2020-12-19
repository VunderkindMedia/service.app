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

  @override
  void onInit() {
    super.onInit();

    hideFinished.listen((value) => _updateFilteredServices());
    _services.listen((value) => _updateFilteredServices());

    syncServices();
  }

  void syncServices() async {
    ApiService apiService = Get.find();
    SharedPreferencesService sharedPreferencesService = Get.find();
    DbService dbService = Get.find();

    try {
      isLoading.value = true;

      var token = sharedPreferencesService.getAccessToken();

      //sync brands
      var dbBrands = await apiService.getBrands(token);
      this.brands.assignAll(dbBrands);

      var brands = await apiService.getBrands(token);
      await dbService.saveBrands(brands);
      this.brands.assignAll(brands);

      //sync services
      var dbServices = await dbService.getServices();
      _services.assignAll(dbServices);

      var services = await apiService.getServices(token);
      await dbService.saveServices(services);
      _services.assignAll(services);

      lastSyncDate.value = DateTime.now();
      isSynchronized.value = true;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFilteredServices() {
    filteredServices.assignAll(_services.where((service) => hideFinished.value ? service.status != ServiceStatus.End : true).toList());
  }
}
