class MountingImage {
  final String id;
  int mountingId;
  String stageId;
  int fileId;
  String fileName;
  String local;
  bool export;

  MountingImage(this.id);

  factory MountingImage.fromJson(Map<String, dynamic> json) {
    var mountingImage = MountingImage(json['id']);

    mountingImage.mountingId = json['mountingId'];
    mountingImage.stageId = json['stageId'];
    mountingImage.fileId = json['fileId'];
    mountingImage.fileName = json['fileName'];
    mountingImage.local = '';
    mountingImage.export = false;

    return mountingImage;
  }

  factory MountingImage.fromMap(Map<String, dynamic> map) {
    var mountingImage = MountingImage(map['id']);

    mountingImage.mountingId = map['mountingId'];
    mountingImage.stageId = map['stageId'];
    mountingImage.fileId = map['fileId'];
    mountingImage.fileName = map['fileName'];
    mountingImage.local = map['local'];
    mountingImage.export = map['export'] == 1 ? true : false;

    return mountingImage;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mountingId': mountingId,
      'stageId': stageId,
      'fileId': fileId,
      'fileName': fileName,
      'local': local,
      'export': export ? 1 : 0,
    };
  }
}
