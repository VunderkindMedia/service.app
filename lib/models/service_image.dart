class ServiceImage {
  final int id;
  int serviceId;
  int fileId;
  String fileName;
  bool uploaded;

  ServiceImage(this.id);

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    var serviceImage = ServiceImage(json['id']);

    serviceImage.serviceId = json['serviceId'];
    serviceImage.fileId = json['fileId'];
    serviceImage.fileName = json['fileName'];
    serviceImage.uploaded = true;

    return serviceImage;
  }

  factory ServiceImage.fromMap(Map<String, dynamic> map) {
    var serviceImage = ServiceImage(map['id']);

    serviceImage.serviceId = map['serviceId'];
    serviceImage.fileId = map['fileId'];
    serviceImage.fileName = map['fileName'];
    serviceImage.uploaded = map['uploaded'] == 1 ? true : false;

    return serviceImage;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'fileId': fileId,
      'fileName': fileName,
      'uploaded': uploaded ? 1 : 0,
    };
  }
}
