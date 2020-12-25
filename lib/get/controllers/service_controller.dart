import 'package:get/get.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/get/services/shared_preferences_service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';

class ServiceController extends GetxController {
  Rx<Service> _service;
  RxList<ServiceGood> serviceGoods = <ServiceGood>[].obs;
  RxList<ServiceImage> serviceImages = <ServiceImage>[].obs;

  ApiService _apiService;
  DbService _dbService;
  SharedPreferencesService _sharedPreferencesService;
  String _token;

  @override
  void onInit() {
    super.onInit();

    _apiService = Get.find();
    _dbService = Get.find();
    _token = _sharedPreferencesService.getAccessToken();

    serviceGoods.listen((value) => _updateServiceGoods());
    serviceImages.listen((value) => _updateServiceImages());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setService(Service service) {
    _service.value = service;
  }

  void _updateServiceGoods() {}

  void _updateServiceImages() {}
}
