import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/widgets/login_page/login_page.dart';
import 'package:service_app/widgets/services_page/services_page.dart';

class AccountController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;

  Future<void> login() async {
    ApiService apiService = Get.find();
    SharedPreferencesService sharedPreferencesService = Get.find();

    var pushToken = sharedPreferencesService.getPushToken();

    try {
      var accountInfo =
          await apiService.login(username.value, password.value, pushToken);

      sharedPreferencesService.setAccessToken(accountInfo.accessToken);
      sharedPreferencesService
          .setPersonExternalId(accountInfo.personExternalId);
      sharedPreferencesService.setCityExternalId(accountInfo.cityExternalId);
      sharedPreferencesService.setPersonName(accountInfo.personName);

      Get.off(ServicesPage());
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    DbService dbService = Get.find();
    SyncController syncController = Get.find();
    ServiceController serviceController = Get.find();
    ServicesController servicesController = Get.find();
    SharedPreferencesService sharedPreferencesService = Get.find();

    try {
      sharedPreferencesService.setAccessToken(null);
      sharedPreferencesService.setPersonExternalId(null);
      sharedPreferencesService.setCityExternalId(null);
      sharedPreferencesService.setPersonName(null);
      sharedPreferencesService.setLastSyncDate(null);

      syncController.disposeController();
      serviceController.disposeController();
      servicesController.disposeController();
      await dbService.disposeTables();

      Get.offAll(LoginPage());
    } catch (e) {
      print(e);
    }
  }
}
