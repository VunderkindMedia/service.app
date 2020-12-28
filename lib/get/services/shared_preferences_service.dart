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

  String getPersonName() {
    return this._preferences.getString(PERSON_NAME) ?? '';
  }

  void setPersonName(String personName) {
    this._preferences.setString(PERSON_NAME, personName);
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

  DateTime getLastSyncDate() {
    var dateString = this._preferences.getString(LAST_SYNC_DATE);
    return dateString !=null ? DateTime.parse(dateString) : null;
  }

  void setLastSyncDate(DateTime lastSyncDate) {
    if (lastSyncDate == null) {
      this._preferences.remove(LAST_SYNC_DATE);
      return;
    }
    this._preferences.setString(LAST_SYNC_DATE, lastSyncDate.toIso8601String());
  }
}
