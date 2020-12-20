class Good {
  final int id;
  String externalId;
  String name;
  String parentId;
  String code;
  bool deleteMark;
  String article;
  bool isGroup;
  int minPrice;
  String image;

  Good(this.id);

  factory Good.fromJson(Map<String, dynamic> json) {
    var good = Good(json['ID']);

    good.externalId = json['ExternalID'];
    good.name = json['Name'];
    good.parentId = json['ParentID'];
    good.code = json['Code'];
    good.deleteMark = json['DeleteMark'];
    good.article = json['Article'];
    good.isGroup = json['IsGroup'];
    good.minPrice = json['MinPrice'];
    good.image = json['Image'];

    return good;
  }

  factory Good.fromMap(Map<String, dynamic> map) {
    var good = Good(map['ID']);

    good.externalId = map['externalId'];
    good.name = map['name'];
    good.parentId = map['parentId'];
    good.code = map['code'];
    good.deleteMark = map['deleteMark'] == 1 ? true : false;
    good.article = map['article'];
    good.isGroup = map['isGroup'] == 1 ? true : false;
    good.minPrice = map['minPrice'];
    good.image = map['image'];

    return good;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'externalId': externalId,
      'name': name,
      'parentId': parentId,
      'code': code,
      'deleteMark': deleteMark ? 1 : 0,
      'article': article,
      'isGroup': isGroup ? 1 : 0,
      'minPrice': minPrice,
      'image': image,
    };
  }
}