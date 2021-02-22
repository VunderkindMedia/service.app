class AccountInfo {
  final String accessToken;
  final String personName;
  final String personExternalId;
  final String cityExternalId;
  final List<dynamic> userRole;

  AccountInfo(
      {this.accessToken,
      this.personName,
      this.personExternalId,
      this.cityExternalId,
      this.userRole});

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      accessToken: json['access_token'],
      personName: json['person_name'],
      personExternalId: json['person_external_id'],
      cityExternalId: json['city_external_id'],
      userRole: json['user_role'],
    );
  }
}
