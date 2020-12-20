import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/constants/api.dart';
import 'package:service_app/models/account_info.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';

class ApiService extends GetxService {
  ApiService init() {
    return this;
  }

  Future<AccountInfo> login(String username, String password) async {
    var response = await http.post(API_LOGIN, body: jsonEncode(<String, String>{'username': username, 'password': password}));
    return AccountInfo.fromJson(jsonDecode(response.body));
  }

  Future<List<Service>> getServices(String accessToken) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(API_SERVICES, headers: headers);
    var responseJson = jsonDecode(response.body);
    var servicesJson = List.from(responseJson['results']);
    var services = servicesJson.map((json) => Service.fromJson(json)).toList();

    return services;
  }

  Future<List<Brand>> getBrands(String accessToken) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(API_BRANDS, headers: headers);
    var responseJson = jsonDecode(response.body);
    var brandsJson = List.from(responseJson['results']);
    var brands = brandsJson.map((json) => Brand.fromJson(json)).toList();

    return brands;
  }

  Future<List<Good>> getGoods(String accessToken) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(API_GOODS, headers: headers);
    var responseJson = jsonDecode(response.body);
    var goodsJson = List.from(responseJson['results']);
    var goods = goodsJson.map((json) => Good.fromJson(json)).toList();

    return goods;
  }

  Future<List<GoodPrice>> getGoodPrices(String accessToken) async {
    var headers = {HttpHeaders.authorizationHeader: 'Bearer $accessToken'};

    var response = await http.get(API_GOOD_PRICES, headers: headers);
    var responseJson = jsonDecode(response.body);
    var goodPricesJson = List.from(responseJson['results']);
    var goodPrices = goodPricesJson.map((json) => GoodPrice.fromJson(json)).toList();

    return goodPrices;
  }
}
