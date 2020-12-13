import 'package:service_app/models/service.dart';

class SyncServicesAction {}

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