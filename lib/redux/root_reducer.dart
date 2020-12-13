import 'package:service_app/redux/services/reducer.dart';

class AppState {
  ServicesState servicesState;

  AppState({this.servicesState});

  AppState.initial() {
    this.servicesState = ServicesState();
  }
}

AppState appReducer(AppState state, action) {
  return AppState(
    servicesState: servicesReducer(state.servicesState, action),
  );
}
