import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/constants/api.dart';
import 'package:service_app/models/account_info.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/closed_dates.dart';
import 'package:service_app/models/construction_type.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/push_notifications.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';
import 'package:service_app/models/stage.dart';

class ApiService extends GetxService {
  Future<ApiService> init() async {
    return this;
  }

  String _getIntervalParam(String name, DateTime date) {
    return '&$name=${DateFormat('yyyy-MM-dd').format(date)}';
  }

  String _getUpdtParam(DateTime lSync) {
    var updtParam = '';
    if (lSync != null)
      updtParam = '&updt=${DateFormat('yyyy-MM-ddTHH:mm:ss').format(lSync)}';
    return updtParam;
  }

  String _getUrlString(String url, int limit, int offset, DateTime lSync,
      {DateTime dateStart, DateTime dateEnd}) {
    var limitParam = '?limit=$limit';
    var offsetParam = '&offset=$offset';
    var updtParam = _getUpdtParam(lSync);
    var fromParam = '';
    var toParam = '';

    if (dateStart != null) fromParam = _getIntervalParam('from', dateStart);
    if (dateEnd != null) toParam = _getIntervalParam('to', dateEnd);

    return '$url$limitParam$offsetParam$updtParam$fromParam$toParam';
  }

  Future<AccountInfo> login(
      String username, String password, String pushToken) async {
    try {
      var response = await http.post(API_LOGIN,
          body: jsonEncode(<String, dynamic>{
            'username': username,
            'password': password,
            'ostype': pushToken != null ? 2 : 0,
            'token': pushToken
          }));
      if (response.statusCode != 200) {
        throw response.body;
      }

      return AccountInfo.fromJson(jsonDecode(response.body));
    } catch (e) {
      Get.showSnackbar(GetBar(
        title: 'Error!',
        message: e.toString(),
      ));
      return null;
    }
  }

  Future<List<Mounting>> getMountings(String accessToken, String userId,
      DateTime lSync, DateTime dateSt, DateTime dateEnd) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(
        _getUrlString(API_MOUNTINGS, 150, 0, lSync,
            dateStart: dateSt, dateEnd: dateEnd),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var mountingsJson = List.from(responseJson['results']);
    var mountings =
        mountingsJson.map((json) => Mounting.fromJson(json, userId)).toList();

    print("get mountings ${mountings.length}");

    return mountings;
  }

  Future<List<Service>> getServices(String accessToken, DateTime lSync,
      DateTime dateSt, DateTime dateEnd) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(
        _getUrlString(API_SERVICES, 150, 0, lSync,
            dateStart: dateSt, dateEnd: dateEnd),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var servicesJson = List.from(responseJson['results']);
    var services = servicesJson.map((json) => Service.fromJson(json)).toList();

    print("get services ${services.length}");

    return services;
  }

  Future<List<Brand>> getBrands(String accessToken, DateTime lSync) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(_getUrlString(API_BRANDS, 9999, 0, lSync),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var brandsJson = List.from(responseJson['results']);
    var brands = brandsJson.map((json) => Brand.fromJson(json)).toList();

    print("get brands ${brands.length}");

    return brands;
  }

  Future<List<ConstructionType>> getConstructionTypes(
      String accessToken) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(
        _getUrlString(API_CONSTRUCTION_TYPES, 9999, 0, null),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var constructionTypesJson = List.from(responseJson['results']);
    var constructionTypes = constructionTypesJson
        .map((json) => ConstructionType.fromJson(json))
        .toList();

    print("get construction types ${constructionTypes.length}");

    return constructionTypes;
  }

  Future<List<Stage>> getStages(String accessToken) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(
        _getUrlString(API_CONSTRUCTION_STAGES, 9999, 0, null),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var stagesJson = List.from(responseJson['results']);
    var stages = stagesJson.map((json) => Stage.fromJson(json)).toList();

    print("get stages ${stages.length}");

    return stages;
  }

  Future<List<ClosedDates>> getClosedDates(
      String accessToken, String cityId, DateTime lSync) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};
    var updParam = _getUpdtParam(lSync);

    var response = await http.get('$API_CLOSED_DATES/$cityId?updt=$updParam',
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var clDatesJson = List.from(responseJson['results']);
    var clDates =
        clDatesJson.map((json) => ClosedDates.fromJson(json)).toList();

    print("get closed dates ${clDates.length}");

    return clDates;
  }

  Future<List<Good>> getGoods(String accessToken, DateTime lSync) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(_getUrlString(API_GOODS, 9999, 0, lSync),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var goodsJson = List.from(responseJson['results']);
    var goods = goodsJson.map((json) => Good.fromJson(json)).toList();

    print("get goods ${goods.length}");

    return goods;
  }

  Future<List<GoodPrice>> getGoodPrices(
      String accessToken, DateTime lSync) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http
        .get(_getUrlString(API_GOOD_PRICES, 9999, 0, lSync), headers: headers);
    var responseJson = jsonDecode(response.body);
    var goodPricesJson = List.from(responseJson['results']);
    var goodPrices =
        goodPricesJson.map((json) => GoodPrice.fromJson(json)).toList();

    print("get goodPrices ${goodPrices.length}");

    return goodPrices;
  }

  Future<List<PushNotification>> getNotifications(
      String accessToken, DateTime lSync,
      [bool init = false]) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(
        _getUrlString(API_PUSH_NOTIFICATIONS, 9999, 0, lSync),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var pushJson = List.from(responseJson['results']);
    var push = pushJson
        .map((json) => PushNotification.fromJson(json, !lSync.isNull))
        .toList();

    print("get notifications ${push.length}");

    return push;
  }

  Future<ServiceGood> addServiceGood(
      ServiceGood serviceGood, String accessToken) async {
    try {
      var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

      var response = await http.post(
        '$API_SERVICES/${serviceGood.serviceId.toString()}/good',
        headers: headers,
        body: jsonEncode(
          serviceGood.toMap(),
        ),
      );

      if (response.statusCode != 200) {
        return null;
      }

      return ServiceGood.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteServiceGood(
      ServiceGood serviceGood, String accessToken) async {
    try {
      var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

      var response = await http.delete(
          '$API_SERVICES/${serviceGood.serviceId.toString()}/good/${serviceGood.id}',
          headers: headers);

      if (response.statusCode != 200) {
        throw response.body;
      }

      return true;
    } catch (e) {
      Get.showSnackbar(GetBar(
        title: 'Error!',
        message: e.toString(),
      ));
      return false;
    }
  }

  Future<ServiceImage> addServiceImage(
      ServiceImage serviceImage, String accessToken) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_FILES'
            '/service/${serviceImage.serviceId.toString()}'
            '/${serviceImage.id}'),
      );
      request.headers['authorization'] = 'Bearer $accessToken';
      request.headers['content-type'] = 'multipart/form-data';
      request.files.add(http.MultipartFile(
          'attachment',
          File(serviceImage.local).readAsBytes().asStream(),
          File(serviceImage.local).lengthSync(),
          filename: serviceImage.local.split('/').last));
      var response = await request.send();

      if (response.statusCode != 200) {
        return null;
      }

      request = null;
      var respStr = await response.stream.bytesToString();

      return ServiceImage.fromJson(jsonDecode(respStr));
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteServiceImage(
      ServiceImage serviceImage, String accessToken) async {
    try {
      var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

      var response = await http.delete(
          '$API_FILES/${serviceImage.fileId.toString()}',
          headers: headers);

      if (response.statusCode != 200) {
        throw response.body;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Service> getService(String accessToken, int serviceID) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get('$API_SERVICES/${serviceID.toString()}',
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var service = Service.fromJson(responseJson);

    print("get service ${service.id}");

    return service;
  }

  Future<Service> setService(Service service, String accessToken) async {
    try {
      var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

      var response = await http.post(
        '$API_SERVICES/${service.id.toString()}',
        headers: headers,
        body: jsonEncode(service.toMap()),
      );

      if (response.statusCode != 200) {
        return null;
      }

      return Service.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }
}
