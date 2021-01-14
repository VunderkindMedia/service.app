import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:service_app/get/services/api_service.dart';
import 'package:service_app/get/services/db_service.dart';
import 'constants/app_colors.dart';
import 'package:service_app/widgets/login_page/login_page.dart';
import 'package:service_app/widgets/services_page/services_page.dart';

import 'get/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  SharedPreferencesService sharedPreferencesService = Get.find();

  runApp(
    GetMaterialApp(
      title: 'Service App',
      theme: _appTheme,
      home: sharedPreferencesService.getAccessToken().length == 0
          ? LoginPage()
          : ServicesPage(),
      supportedLocales: const <Locale>[
        const Locale('en'),
      ],
    ),
  );
}

Future<void> initServices() async {
  print('starting services ...');

  Get.put(ApiService().init());
  await Get.putAsync(() => DbService().init());
  await Get.putAsync(() => SharedPreferencesService().init());

  print('All services started...');
}

final ThemeData _appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  /* return ThemeData.light(); */

  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      primaryColor: kMainColor,
      buttonColor: kMainColor,
      accentColor: kMainColor,
      appBarTheme: AppBarTheme(color: kMainColor),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: kMainColor));
}
