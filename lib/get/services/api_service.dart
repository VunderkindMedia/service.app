import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/constants/api.dart';
import 'package:service_app/models/account_info.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';

class ApiService extends GetxService {
  ApiService init() {
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

  Future<AccountInfo> login(String username, String password) async {
    try {
      var response = await http.post(API_LOGIN,
          body: jsonEncode(
              <String, String>{'username': username, 'password': password}));
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

  Future<List<Service>> getServices(String accessToken, DateTime lSync) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(
        _getUrlString(API_SERVICES, 150, 0, lSync,
            dateStart: DateTime.now().add(Duration(days: -2)),
            dateEnd: DateTime.now().add(Duration(days: 2))),
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

  Future<bool> addServiceImage(
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
        return false;
      }

      request = null;

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteServiceImage(
      ServiceImage serviceImage, String accessToken) async {
    return true;
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
