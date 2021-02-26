class ConstructionType {
  final String id;
  String name;
  String code;
  String workDir;

  ConstructionType(this.id);

  factory ConstructionType.fromJson(Map<String, dynamic> json) {
    var constructionType = ConstructionType(json['ID']);

    constructionType.name = json['Name'];
    constructionType.code = json['Code'];
    constructionType.workDir = json['WorkDir'];

    return constructionType;
  }

  factory ConstructionType.fromMap(Map<String, dynamic> map) {
    var constructionType = ConstructionType(map['id']);

    constructionType.name = map['workType'];
    constructionType.code = map['serviceId'];
    constructionType.workDir = map['construction'];

    return constructionType;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'workDir': workDir,
    };
  }
}
