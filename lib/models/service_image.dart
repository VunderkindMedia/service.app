class ServiceImage {
  final int fileId;
  String fileName;
  bool uploaded;

  ServiceImage(this.fileId);

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    var serviceGood = ServiceImage(json['fileId']);

    serviceGood.fileName = json['fileName'];
    serviceGood.uploaded = true;

    return serviceGood;
  }

  factory ServiceImage.fromMap(Map<String, dynamic> map) {
    var serviceImage = ServiceImage(map['fileId']);

    serviceImage.fileName = map['fileName'];
    serviceImage.uploaded = map['uploaded'] == 1 ? true : false;

    return serviceImage;
  }

  Map<String, dynamic> toMap() {
    return {
      'fileId': fileId,
      'fileName': fileName,
      'uploaded': uploaded ? 1 : 0,
    };
  }
}
