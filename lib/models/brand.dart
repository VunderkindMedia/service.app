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
}
