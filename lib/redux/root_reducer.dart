import 'package:service_app/models/service.dart';
import 'package:service_app/redux/services/reducer.dart';

class AppState {
  final List<Service> services;

  AppState({this.services = const []});
}

AppState appReducer(AppState state, action) {
  return AppState(
    services: servicesReducer(state.services, action),
  );
}
