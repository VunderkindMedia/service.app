class Stage {
  final String id;
  String name;
  String constructionTypeId;
  String workDir;

  Stage(this.id);

  factory Stage.fromJson(Map<String, dynamic> json) {
    var stage = Stage(json['ID']);

    stage.name = json['Name'];
    stage.constructionTypeId = json['ConstructionTypeID'];

    return stage;
  }

  factory Stage.fromMap(Map<String, dynamic> map) {
    var stage = Stage(map['id']);

    stage.name = map['name'];
    stage.constructionTypeId = map['constructionTypeId'];

    return stage;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'constructionTypeId': constructionTypeId,
    };
  }
}
