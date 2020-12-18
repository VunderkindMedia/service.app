import 'dart:convert';
import 'dart:io';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:service_app/constants/api.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/redux/catalog/actions.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:http/http.dart' as http;

class AddServicesAction {
  final List<Service> services;

  AddServicesAction(this.services);

  @override
  String toString() {
    return 'AddServicesAction{services: $services}';
  }
}

class AddServiceAction {
  final Service service;

  AddServiceAction(this.service);

  @override
  String toString() {
    return 'AddServiceAction{service: $service}';
  }
}

class DeleteServiceAction {
  final Service service;

  DeleteServiceAction(this.service);

  @override
  String toString() {
    return 'DeleteServiceAction{service: $service}';
  }
}

class UpdateServiceAction {
  final Service service;

  UpdateServiceAction(this.service);

  @override
  String toString() {
    return 'UpdateServiceAction{service: $service}';
  }
}

class SetIsLoadingAction {
  final bool isLoading;

  SetIsLoadingAction(this.isLoading);

  @override
  String toString() {
    return 'SetIsLoadingAction{isLoading: $isLoading}';
  }
}

class SetSyncDateAction {
  final DateTime syncDate;

  SetSyncDateAction(this.syncDate);

  @override
  String toString() {
    return 'SetSyncDateAction{syncDate: $syncDate}';
  }
}

//TODO: sync with db
ThunkAction<AppState> syncServicesAction() {
  return (Store<AppState> store) async {
    store.dispatch(SetIsLoadingAction(true));
    try {
      var headers = {HttpHeaders.authorizationHeader: 'Bearer ${store.state.accountState.accountInfo.accessToken}'};

      var brandsResponse = await http.get(API_BRANDS, headers: headers);
      var brandsResponseJson = jsonDecode(brandsResponse.body);
      var brandsJson = List.from(brandsResponseJson['results']);
      var brands = brandsJson.map((json) => Brand.fromJson(json)).toList();
      store.dispatch(SetBrandsAction(brands));

      var servicesResponse = await http.get(API_SERVICES, headers: headers);
      var servicesResponseJson = jsonDecode(servicesResponse.body);
      var servicesJson = List.from(servicesResponseJson['results']);
      var services = servicesJson.map((json) => Service.fromJson(json)).toList();
      store.dispatch(AddServicesAction(services));

      store.dispatch(SetSyncDateAction(DateTime.now()));
    } catch (e) {
      print(e);
    } finally {
      store.dispatch(SetIsLoadingAction(false));
    }
  };
}