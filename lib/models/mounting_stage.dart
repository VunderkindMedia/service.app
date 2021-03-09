import 'package:uuid/uuid.dart';
import 'mounting.dart';
import 'stage.dart';

class StageResult {
  static const Initialized = "initialized";
  static const Done = "done";
  static const Cancel = "cancel";
}

class MountingStage {
  final String id;
  DateTime createdAt;
  DateTime updatedAt;
  String stageId;
  int mountingId;
  String personId;
  String result;
  String comment;
  bool export;

  Mounting mounting;
  Stage stage;

  MountingStage(this.id);

  factory MountingStage.initStage(
      Mounting mounting, Stage stage, String personId) {
    var mountingStage = MountingStage(Uuid().v5("mounting", "stage"));

    mountingStage.createdAt = DateTime.now();
    mountingStage.updatedAt = DateTime.now();
    mountingStage.stageId = stage.id;
    mountingStage.mountingId = mounting.id;
    mountingStage.personId = personId;
    mountingStage.result = StageResult.Initialized;
    mountingStage.comment = "";
    mountingStage.export = true;

    mountingStage.mounting = mounting;
    mountingStage.stage = stage;

    return mountingStage;
  }

  factory MountingStage.fromJson(Map<String, dynamic> json) {
    var mountingStage = MountingStage(json['ID']);

    mountingStage.createdAt = DateTime.parse(json['CreatedAt']);
    mountingStage.updatedAt = DateTime.parse(json['UpdatedAt']);
    mountingStage.stageId = json['stageId'];
    mountingStage.mountingId = json['mountingId'];
    mountingStage.personId = json['personId'];
    mountingStage.result = json['result'];
    mountingStage.comment = json['comment'];
    mountingStage.export = false;

    return mountingStage;
  }

  factory MountingStage.fromMap(Map<String, dynamic> map) {
    var mountingStage = MountingStage(map['id']);

    mountingStage.createdAt = DateTime.parse(map['createdAt']);
    mountingStage.updatedAt = DateTime.parse(map['updatedAt']);
    mountingStage.stageId = map['stageId'];
    mountingStage.mountingId = map['mountingId'];
    mountingStage.personId = map['personId'];
    mountingStage.result = map['result'];
    mountingStage.comment = map['comment'];
    mountingStage.export = map['export'] == 1 ? true : false;

    return mountingStage;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'stageId': stageId,
      'mountingId': mountingId,
      'personId': personId,
      'result': result,
      'comment': comment,
      'export': export ? 1 : 0,
    };
  }
}
