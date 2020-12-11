import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:service_app/login_page/login_page.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:service_app/repo/repo.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
      services: services
    ),
  );

  runApp(ServiceApp(store));
}

class ServiceApp extends StatelessWidget {
  final Store<AppState> store;

  ServiceApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: LoginPage()
        )
    );
  }
}
