import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:service_app/constants/shared_preferences.dart';
import 'package:service_app/redux/account/actions.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:service_app/widgets/login_page/login_page.dart';
import 'package:service_app/widgets/services_page/services_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );

  runApp(ServiceApp(store));

  store.dispatch(initAction());
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
            home: FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.hasData) {
                  var prefs = snapshot.data;
                  var accessToken = prefs.getString(ACCESS_TOKEN) ?? '';
                  print(accessToken);

                  if (accessToken.length > 0) {
                    return ServicesPage();
                  }
                }

                return LoginPage();
              },
            )
        )
    );
  }
}
