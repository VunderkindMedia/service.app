import 'package:service_app/redux/account/reducer.dart';
import 'package:service_app/redux/services/reducer.dart';

class AppState {
  ServicesState servicesState;
  AccountState accountState;

  AppState({this.servicesState, this.accountState});

  AppState.initial() {
    this.servicesState = ServicesState();
    this.accountState = AccountState();
  }
}

AppState appReducer(AppState state, action) {
  return AppState(
    servicesState: servicesReducer(state.servicesState, action),
  );
}
