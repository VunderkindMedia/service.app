import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'constants/app_colors.dart';
import 'package:service_app/widgets/login_page/login_page.dart';
import 'package:service_app/widgets/services_page/services_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'get/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  SharedPreferencesService sharedPreferencesService = Get.find();

  await initPushServices(sharedPreferencesService);

  runApp(
    GetMaterialApp(
      title: 'Service App',
      theme: _appTheme,
      home: sharedPreferencesService.getAccessToken().length == 0
          ? LoginPage()
          : ServicesPage(),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: const <Locale>[
        const Locale('en'),
        const Locale('ru'),
      ],
    ),
  );
}

Future<void> initServices() async {
  print('starting services ...');

  await Get.putAsync(() => DbService().init());
  await Get.putAsync(() => SharedPreferencesService().init());
  await Get.putAsync(() => AccountController().init());
  await Get.putAsync(() => ApiService().init());
  await Get.putAsync(() => SyncController().init());

  print('All services started...');
}

Future<void> initPushServices(
    SharedPreferencesService sharedPreferencesService) async {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  await _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print(token);
    sharedPreferencesService.setPushToken(token);
  });
}

final ThemeData _appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  /* return ThemeData.light(); */

  /* final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: kMainColor,
    appBarTheme: AppBarTheme(color: Colors.white),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: kMainColor),
  ); */

  /* return ThemeData(
    brightness: Brightness.light,
    primaryColor: kMainColor,
    backgroundColor: Colors.black,
    accentColor: Colors.green[600],
    fontFamily: 'Lato',
  ); */

  return ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
    primaryColor: kAppHeaderColor,
    primaryColorBrightness: Brightness.light,
    canvasColor: Colors.grey[800],
    accentColor: kMainColor,
    accentColorBrightness: Brightness.light,
    scaffoldBackgroundColor: kMainSecondColor,
    cardColor: Colors.white,
    dividerColor: Colors.white,
    focusColor: kBackgroundLight,
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(color: Colors.black),
      contentTextStyle: TextStyle(color: Colors.black),
    ),
  );
}
