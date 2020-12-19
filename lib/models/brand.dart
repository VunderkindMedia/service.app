class Brand {
  final int id;
  String externalId;
  String name;
  String code;
  bool deleteMark;

  Brand(this.id);

  factory Brand.fromJson(Map<String, dynamic> json) {
    var brand = Brand(json['ID']);

    brand.externalId = json['ExternalID'];
    brand.name = json['Name'];
    brand.code = json['Code'];
    brand.deleteMark = json['DeleteMark'];

    return brand;
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    var brand = Brand(map['id']);

    brand.externalId = map['externalId'];
    brand.name = map['name'];
    brand.code = map['code'];
    brand.deleteMark = map['deleteMark'] == 1 ? true : false;

    return brand;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'externalId': externalId,
      'name': name,
      'code': code,
      'deleteMark': deleteMark,
    };
  }
}
