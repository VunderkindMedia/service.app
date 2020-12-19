import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:service_app/constants/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  SharedPreferences _preferences;

  Future<SharedPreferencesService> init() async {
    this._preferences = await SharedPreferences.getInstance();
    print('$runtimeType ready!');
    return this;
  }

  String getAccessToken() {
    return this._preferences.getString(ACCESS_TOKEN) ?? '';
  }

  void setAccessToken(String accessToken) {
    this._preferences.setString(ACCESS_TOKEN, accessToken);
  }

  String getPersonExternalId() {
    return this._preferences.getString(PERSON_EXTERNAL_ID) ?? '';
  }

  void setPersonExternalId(String personExternalId) {
    this._preferences.setString(PERSON_EXTERNAL_ID, personExternalId);
  }

  String getCityExternalId() {
    return this._preferences.getString(CITY_EXTERNAL_ID) ?? '';
  }

  void setCityExternalId(String cityExternalId) {
    this._preferences.setString(CITY_EXTERNAL_ID, cityExternalId);
  }
}