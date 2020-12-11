import 'package:service_app/models/service.dart';

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