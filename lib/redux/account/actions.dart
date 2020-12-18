import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:service_app/constants/api.dart';
import 'package:service_app/constants/shared_preferences.dart';
import 'package:service_app/models/account_info.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:service_app/widgets/services_page/services_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SetAccountInfoAction {
  final AccountInfo accountInfo;

  SetAccountInfoAction(this.accountInfo);

  @override
  String toString() {
    return 'SetAccountInfoAction{accountInfo: $accountInfo}';
  }
}

ThunkAction<AppState> loginAction(BuildContext context, String username, String password) {
  return (Store<AppState> store) async {
    try {
      if (username?.trim() == null || username.length == 0 || password?.trim() == null || password.length == 0) {
        return;
      }

      var response = await http.post(API_LOGIN, body: jsonEncode(<String, String>{'username': username, 'password': password}));
      var accountInfo = AccountInfo.fromJson(jsonDecode(response.body));

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(ACCESS_TOKEN, accountInfo.accessToken);
      prefs.setString(PERSON_EXTERNAL_ID, accountInfo.personExternalId);
      prefs.setString(CITY_EXTERNAL_ID, accountInfo.cityExternalId);

      store.dispatch(SetAccountInfoAction(accountInfo));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServicesPage()));
    } catch (e) {
      print(e);
    }
  };
}

ThunkAction<AppState> initAction() {
  return (Store<AppState> store) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getString(ACCESS_TOKEN) ?? '';
      var personExternalId = prefs.getString(PERSON_EXTERNAL_ID) ?? '';
      var cityExternalId = prefs.getString(CITY_EXTERNAL_ID) ?? '';

      if (accessToken.length == 0 || personExternalId.length == 0 || cityExternalId.length == 0) {
        return;
      }

      print(accessToken);

      store.dispatch(
          SetAccountInfoAction(AccountInfo(accessToken: accessToken, personExternalId: personExternalId, cityExternalId: cityExternalId)));
    } catch (e) {
      print(e);
    }
  };
}
