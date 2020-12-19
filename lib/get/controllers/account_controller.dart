import 'package:get/get.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/widgets/services_page/services_page.dart';

class AccountController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;

  void login() async {
    ApiService apiService = Get.find();
    SharedPreferencesService sharedPreferencesService = Get.find();

    try {
      var accountInfo = await apiService.login(username.value, password.value);

      sharedPreferencesService.setAccessToken(accountInfo.accessToken);
      sharedPreferencesService.setPersonExternalId(accountInfo.personExternalId);
      sharedPreferencesService.setCityExternalId(accountInfo.cityExternalId);

      Get.off(ServicesPage());
    } catch (e) {
      print(e);
    }
  }
}