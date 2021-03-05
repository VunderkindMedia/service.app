class MountingResult {
  static const Done = "done";
  static const Cancel = "cancel";
}

class MountingStage {
  final String id;
  DateTime createdAt;
  String stageId;
  String mountingId;
  String result;
  int fileId;
  String local;
  String comment;
  bool export;

  MountingStage(this.id);

  factory MountingStage.fromJson(Map<String, dynamic> json) {
    var mountingStage = MountingStage(json['id']);

    mountingStage.createdAt = DateTime.parse(json['CreatedAt']);
    mountingStage.stageId = json['stageId'];
    mountingStage.mountingId = json['mountingId'];
    mountingStage.result = json['result'];
    mountingStage.fileId = json['fileId'];
    mountingStage.comment = json['comment'];
    mountingStage.local = json['local'];
    mountingStage.export = false;

    return mountingStage;
  }

  factory MountingStage.fromMap(Map<String, dynamic> map) {
    var mountingStage = MountingStage(map['id']);

    mountingStage.createdAt = DateTime.parse(map['createdAt']);
    mountingStage.stageId = map['stageId'];
    mountingStage.mountingId = map['mountingId'];
    mountingStage.result = map['DeleteMark'];
    mountingStage.fileId = map['fileId'];
    mountingStage.comment = map['comment'];
    mountingStage.local = map['local'];
    mountingStage.export = map['export'] == 1 ? true : false;

    return mountingStage;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'stageId': stageId,
      'mountingId': mountingId,
      'result': result,
      'fileId': fileId,
      'comment': comment,
      'local': local,
      'export': export ? 1 : 0,
    };
  }
}
