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

  String getUserRoles(bool title) {
    var userRolesTitle = "";
    var userRoles = this._preferences.getString(USER_ROLES) ?? '';

    switch (userRoles) {
      case 'ServiceMember':
        userRolesTitle = 'Будет сделано\nСпециалист сервисной службы';
        break;
      case 'MountingMember':
        userRolesTitle = 'Будет сделано\nСпециалист службы монтажа';
        break;
      case 'MountingBossMember':
        userRolesTitle = 'Будет сделано\nМастер участка сервисной службы';
        break;
      default:
        userRolesTitle = 'Роль не определена';
        break;
    }
    return !title ? userRoles : userRolesTitle;
  }

  void setUserRoles(List<dynamic> roles) {
    String rolesStr = "";

    if (roles != null) {
      roles.forEach((role) {
        rolesStr = rolesStr + role;
      });
    }
    this._preferences.setString(USER_ROLES, rolesStr);
  }

  String getAccessToken() {
    return this._preferences.getString(ACCESS_TOKEN) ?? '';
  }

  void setAccessToken(String accessToken) {
    this._preferences.setString(ACCESS_TOKEN, accessToken);
  }

  String getPushToken() {
    return this._preferences.getString(PUSH_TOKEN) ?? '';
  }

  void setPushToken(String pushToken) {
    this._preferences.setString(PUSH_TOKEN, pushToken);
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
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  void setLastSyncDate(DateTime lastSyncDate) {
    if (lastSyncDate == null) {
      this._preferences.remove(LAST_SYNC_DATE);
      return;
    }
    this._preferences.setString(LAST_SYNC_DATE, lastSyncDate.toIso8601String());
  }

  bool getNeedSync() {
    var needSync = this._preferences.getBool(NEED_SYNC);
    return needSync != null ? needSync : false;
  }

  void setNeedSync(bool needSync) {
    this._preferences.setBool(NEED_SYNC, needSync);
  }
}
