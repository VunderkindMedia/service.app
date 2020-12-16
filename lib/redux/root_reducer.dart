import 'package:service_app/redux/account/reducer.dart';
import 'package:service_app/redux/catalog/actions.dart';
import 'package:service_app/redux/catalog/reducer.dart';
import 'package:service_app/redux/services/reducer.dart';

//TODO: переопределить в основном и дочерних состояниях методы провреки на равентсво и подсчета хеша
class AppState {
  ServicesState servicesState;
  AccountState accountState;
  CatalogState catalogState;

  AppState({this.servicesState, this.accountState, this.catalogState});

  AppState.initial() {
    this.servicesState = ServicesState();
    this.accountState = AccountState();
    this.catalogState = CatalogState();
  }
}

AppState appReducer(AppState state, action) {
  return AppState(
    servicesState: servicesReducer(state.servicesState, action),
    accountState: accountReducer(state.accountState, action),
    catalogState: catalogReducer(state.catalogState, action),
  );
}
