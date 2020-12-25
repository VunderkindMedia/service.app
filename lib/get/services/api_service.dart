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

  String _getUpdtParam(DateTime lSync) {
    var updtParam = '';
    if (lSync != null)
      updtParam = '&updt=${DateFormat('yyyy-MM-ddTHH:mm:ss').format(lSync)}';
    return updtParam;
  }

  String _getUrlString(String url, int limit, int offset, DateTime lSync) {
    var limitParam = '?limit=$limit';
    var offsetParam = '&offset=$offset';
    var updtParam = _getUpdtParam(lSync);

    return '$url$limitParam$offsetParam$updtParam';
  }

  Future<AccountInfo> login(String username, String password) async {
    var response = await http.post(API_LOGIN,
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    return AccountInfo.fromJson(jsonDecode(response.body));
  }

  Future<List<Service>> getServices(String accessToken, DateTime lSync) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(_getUrlString(API_SERVICES, 150, 0, lSync),
        headers: headers);
    var responseJson = jsonDecode(response.body);
    var servicesJson = List.from(responseJson['results']);
    var services = servicesJson.map((json) => Service.fromJson(json)).toList();

    /* Нужно как-то вернуть списки услуг и изображений контроллеру для записи в базу */
    /* var serviceGoods = <ServiceGood>[];
    var serviceImages = <ServiceImage>[];

    servicesJson.forEach((value) {
      var sgJson = value['ServiceGoods'];
      var siJson = value['ServiceImages'];

      if (sgJson != null) {
        serviceGoods
            .addAll(sgJson.map((json) => ServiceGood.fromJson(json)).toList());
      }
      if (siJson != null) {
        serviceImages
            .addAll(siJson.map((json) => ServiceImage.fromJson(json)).toList());
      }
    }); */

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
}
