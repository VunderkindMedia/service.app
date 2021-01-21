class ServiceImage {
  final String id;
  int serviceId;
  int fileId;
  String fileName;
  String local;
  bool export;

  ServiceImage(this.id);

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    var serviceImage = ServiceImage(json['id']);

    serviceImage.serviceId = json['serviceId'];
    serviceImage.fileId = json['fileId'];
    serviceImage.fileName = json['fileName'];
    serviceImage.local = '';
    serviceImage.export = false;

    return serviceImage;
  }

  factory ServiceImage.fromMap(Map<String, dynamic> map) {
    var serviceImage = ServiceImage(map['id']);

    serviceImage.serviceId = map['serviceId'];
    serviceImage.fileId = map['fileId'];
    serviceImage.fileName = map['fileName'];
    serviceImage.local = map['local'];
    serviceImage.export = map['export'] == 1 ? true : false;

    return serviceImage;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'fileId': fileId,
      'fileName': fileName,
      'local': local,
      'export': export ? 1 : 0,
    };
  }
}
