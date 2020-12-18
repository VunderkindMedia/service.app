import 'package:redux/redux.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/redux/services/actions.dart';

final servicesReducer = combineReducers<ServicesState>([
  TypedReducer<ServicesState, AddServicesAction>(_addServices),
  TypedReducer<ServicesState, AddServiceAction>(_addService),
  TypedReducer<ServicesState, DeleteServiceAction>(_deleteService),
  TypedReducer<ServicesState, UpdateServiceAction>(_updateService),
  TypedReducer<ServicesState, SetIsLoadingAction>(_setIsLoading),
  TypedReducer<ServicesState, SetSyncDateAction>(_setSyncDate),
]);

ServicesState _addServices(ServicesState state, AddServicesAction action) {
  return state.copyWith(services: List.from(state.services)..addAll(action.services));
}

ServicesState _addService(ServicesState state, AddServiceAction action) {
  return state.copyWith(services: List.from(state.services)..add(action.service));
}

ServicesState _deleteService(ServicesState state, DeleteServiceAction action) {
  return state.copyWith(services: state.services.where((service) => service.id != action.service.id).toList());
}

ServicesState _updateService(ServicesState state, UpdateServiceAction action) {
  return state.copyWith(services: state.services.map((service) => service.id == action.service.id ? action.service : service).toList());
}

ServicesState _setIsLoading(ServicesState state, SetIsLoadingAction action) {
  return state.copyWith(isLoading: action.isLoading);
}

ServicesState _setSyncDate(ServicesState state, SetSyncDateAction action) {
  return state.copyWith(syncDate: action.syncDate);
}

class ServicesState {
  final bool isLoading;
  final DateTime syncDate;
  final List<Service> services;

  ServicesState({this.isLoading = false, this.syncDate, this.services = const []});

  ServicesState copyWith({
    bool isLoading,
    DateTime syncDate,
    List<Service> services,
  }) {
    return ServicesState(
      isLoading: isLoading ?? this.isLoading,
      syncDate: syncDate ?? this.syncDate,
      services: services ?? this.services,
    );
  }
}
