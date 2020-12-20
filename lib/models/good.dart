class Good {
  final int id;
  String externalID;
  String name;
  String parentID;
  String code;
  bool deleteMark;
  String article;
  bool isGroup;
  int minPrice;
  String image;

  Good(this.id);

  factory Good.fromJson(Map<String, dynamic> json) {
    var good = Good(json['ID']);

    good.externalID = json['ExternalID'];
    good.name = json['Name'];
    good.parentID = json['ParentID'];
    good.code = json['Code'];
    good.deleteMark = json['DeleteMark'];
    good.article = json['Article'];
    good.isGroup = json['IsGroup'];
    good.minPrice = json['MinPrice'];
    good.image = json['Image'];

    return good;
  }
}