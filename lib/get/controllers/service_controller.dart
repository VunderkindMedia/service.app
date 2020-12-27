import 'package:get/get.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
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

  RxList<Good> goods = <Good>[].obs;
  RxList<GoodPrice> goodPrices = <GoodPrice>[].obs;

  Rx<Service> service;

  ApiService _apiService;
  DbService _dbService;
  SharedPreferencesService _sharedPreferencesService;
  String _token;
  String _personId;

  @override
  void onInit() async {
    super.onInit();

    _apiService = Get.find();
    _dbService = Get.find();
    _sharedPreferencesService = Get.find();

    _token = _sharedPreferencesService.getAccessToken();
    _personId = _sharedPreferencesService.getPersonExternalId();

    var dbGoods = await _dbService.getGoods();
    goods.assignAll(dbGoods);

    var dbGoodPrices = await _dbService.getGoodPrices();
    goodPrices.assignAll(dbGoodPrices);

    serviceGoods.listen((value) => _updateServiceGoods());
    serviceImages.listen((value) => _updateServiceImages());
  }

  void init(int serviceId) async {
    var dbService = await _dbService.getServiceById(serviceId);
    this.service = dbService.obs;
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

  List<Good> getChildrenGoodsByParent(Good parent) {
    if (parent == null) {
      return goods.where((good) => goods.firstWhere((g) => g.externalId == good.parentId, orElse: () => null) == null).toList();
    }
    return goods.where((good) => good.parentId == parent.externalId).toList();
  }
}
