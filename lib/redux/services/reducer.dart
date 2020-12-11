import 'package:redux/redux.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/redux/services/actions.dart';

final servicesReducer = combineReducers<List<Service>>([
  TypedReducer<List<Service>, AddServiceAction>(_addService),
  TypedReducer<List<Service>, DeleteServiceAction>(_deleteService),
  TypedReducer<List<Service>, UpdateServiceAction>(_updateService),
]);

List<Service> _addService(List<Service> services, AddServiceAction action) {
  return List.from(services)..add(action.service);
}

List<Service> _deleteService(List<Service> services, DeleteServiceAction action) {
  return services.where((service) => service.id != action.service.id).toList();
}

List<Service> _updateService(List<Service> todos, UpdateServiceAction action) {
  return todos
      .map((service) => service.id == action.service.id ? action.service : service)
      .toList();
}