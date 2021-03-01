import 'package:get/get.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/models/account_info.dart';
import 'package:service_app/widgets/login_page/login_page.dart';

class AccountController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;

  SharedPreferencesService _sharedPreferencesService;

  String _personName;
  String _userRoles;
  String _userRolesTitle;
  String _personId;
  String _token;

  String get personId => _personId;
  String get userRoles => _userRoles;
  String get userRolesTitle => _userRolesTitle;
  String get personName => _personName;
  String get token => _token;

  Future<AccountController> init() async {
    _sharedPreferencesService = Get.find();

    _personName = _sharedPreferencesService.getPersonName();
    _userRoles = _sharedPreferencesService.getUserRoles(false);
    _userRolesTitle = _sharedPreferencesService.getUserRoles(true);
    _personId = _sharedPreferencesService.getPersonExternalId();
    _token = _sharedPreferencesService.getAccessToken();

    return this;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<AccountInfo> login() async {
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
      sharedPreferencesService.setUserRoles(accountInfo.userRole);
      sharedPreferencesService.setAccessToken(accountInfo.accessToken);

      await init();

      return accountInfo;
    } catch (e) {
      print(e);
    }

    return null;
  }

  void logout() async {
    DbService dbService = Get.find();
    SyncController syncController = Get.find();

    SharedPreferencesService sharedPreferencesService = Get.find();

    try {
      switch (userRoles) {
        case "ServiceMember":
          ServiceController serviceController = Get.find();
          ServicesController servicesController = Get.find();
          serviceController.disposeController();
          servicesController.disposeController();
          break;
        case "MountingMember":
          /* TODO: add mounting controller */
          MountingsController mountingsController = Get.find();
          mountingsController.disposeController();
          break;
      }

      sharedPreferencesService.setAccessToken(null);
      sharedPreferencesService.setPersonExternalId(null);
      sharedPreferencesService.setCityExternalId(null);
      sharedPreferencesService.setPersonName(null);
      sharedPreferencesService.setLastSyncDate(null);
      sharedPreferencesService.setUserRoles(null);

      syncController.disposeController();

      await dbService.disposeTables();

      Get.offAll(LoginPage());
    } catch (e) {
      print(e);
    }
  }
}
