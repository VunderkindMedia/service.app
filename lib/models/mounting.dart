import 'package:service_app/models/mounting_image.dart';
import 'package:service_app/models/mounting_stage.dart';

class Mounting {
  final int id;
  String state;
  DateTime createdAt;
  DateTime updatedAt;
  String externalId;
  String number;
  bool deleteMark;
  DateTime date;
  DateTime dateStart;
  String constructionTypeId;
  String cityId;
  String brandId;
  String customer;
  String customerAddress;
  String floor;
  String lat;
  String lon;
  /* bool intercom;
  bool thermalImager; */
  String phone;
  String comment;
  bool avalible;
  bool actCommited;
  /* String paymentType;
  String customerDecision;
  String refuseReason;
  String userComment;
  DateTime dateStartNext;
  DateTime dateEndNext;
  int sumTotal;
  int sumPayment;
  int sumDiscount; */
  bool export;

  List<dynamic> mountingStages;
  List<dynamic> mountingImages;

  Mounting(this.id);

  factory Mounting.fromJson(Map<String, dynamic> json, userId) {
    var mounting = Mounting(json['ID']);
    var avalibleDocument = false;

    json['WorkersID']?.forEach((worker) {
      if (worker == userId) avalibleDocument = true;
    });

    mounting.state = json['state'];
    mounting.createdAt = DateTime.parse(json['CreatedAt']);
    mounting.updatedAt = DateTime.parse(json['UpdatedAt']);
    mounting.externalId = json['ExternalID'];
    mounting.number = json['Number'];
    mounting.deleteMark = json['DeleteMark'];
    mounting.date = DateTime.parse(json['Date']);
    mounting.dateStart = DateTime.parse(json['DateStart']);
    mounting.cityId = json['CityID'];
    mounting.brandId = json['BrandID'];
    mounting.constructionTypeId = json['ConstructionTypeID'];
    mounting.customer = json['Customer'];
    mounting.customerAddress = json['CustomerAddress'];
    mounting.floor = json['Floor'];
    mounting.lat = json['Lat'];
    mounting.lon = json['Lon'];
    /* service.intercom = json['Intercom'];
    service.thermalImager = json['ThermalImager']; */
    mounting.phone = json['Phone'];
    mounting.comment = json['Comment'];
    mounting.actCommited = json['ActCommited'];
    /* service.sumPayment = json['SumPayment'];
    service.sumDiscount = json['SumDiscount'];
    service.paymentType = json['PaymentType'];
    service.customerDecision = json['CustomerDecision'];
    service.refuseReason = json['RefuseReason'];
    service.userComment = json['UserComment'];
    service.dateStartNext = DateTime.parse(json['DateStartNext']);
    service.dateEndNext = DateTime.parse(json['DateEndNext']); */
    mounting.avalible = avalibleDocument;
    mounting.export = false;

    var mountingStages =
        json['MountingStages']?.map((json) => MountingStage.fromJson(json)) ??
            [];

    var mountingImages =
        json['MountingImages']?.map((json) => MountingImage.fromJson(json)) ??
            [];

    mounting.mountingStages = mountingStages.toList();
    mounting.mountingImages = mountingImages.toList();

    return mounting;
  }

  factory Mounting.fromMap(Map<String, dynamic> map) {
    var mounting = Mounting(map['id']);

    mounting.state = map['state'];
    mounting.createdAt = DateTime.parse(map['createdAt']);
    mounting.updatedAt = DateTime.parse(map['updatedAt']);
    mounting.externalId = map['externalId'];
    mounting.number = map['number'];
    mounting.deleteMark = map['deleteMark'] == 1 ? true : false;
    mounting.date = DateTime.parse(map['date']);
    mounting.dateStart = DateTime.parse(map['dateStart']);
    mounting.cityId = map['cityId'];
    mounting.brandId = map['brandId'];
    mounting.constructionTypeId = map['constructionTypeId'];
    mounting.customer = map['customer'];
    mounting.customerAddress = map['customerAddress'];
    mounting.floor = map['floor'];
    mounting.lat = map['lat'];
    mounting.lon = map['lon'];
    /* service.intercom = map['intercom'] == 1 ? true : false;
    service.thermalImager = map['thermalImager'] == 1 ? true : false; */
    mounting.phone = map['phone'];
    mounting.comment = map['comment'];
    mounting.avalible = map['avalible'] == 1 ? true : false;
    mounting.actCommited = map['actCommited'] == 1 ? true : false;
    /* service.sumPayment = map['sumPayment'];
    service.sumDiscount = map['sumDiscount'];
    service.paymentType = map['paymentType'];
    service.customerDecision = map['customerDecision'];
    service.refuseReason = map['refuseReason'];
    service.userComment = map['userComment'];
    service.dateStartNext = map['dateStartNext'] != null
        ? DateTime.parse(map['dateStartNext'])
        : null;
    service.dateEndNext =
        map['dateEndNext'] != null ? DateTime.parse(map['dateEndNext']) : null; */
    mounting.export = map['export'] == 1 ? true : false;

    return mounting;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'state': state,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'externalId': externalId,
      'number': number,
      'deleteMark': deleteMark ? 1 : 0,
      'date': date.toString(),
      'dateStart': dateStart.toString(),
      'cityId': cityId,
      'brandId': brandId,
      'constructionTypeId': constructionTypeId,
      'customer': customer,
      'customerAddress': customerAddress,
      'floor': floor,
      'lat': lat,
      'lon': lon,
      /* 'intercom': intercom ? 1 : 0,
      'thermalImager': thermalImager ? 1 : 0, */
      'phone': phone,
      'comment': comment,
      'avalible': avalible,
      'actCommited': actCommited,
      /* 'paymentType': paymentType,
      'customerDecision': customerDecision,
      'refuseReason': refuseReason,
      'userComment': userComment,
      'dateStartNext': dateStartNext != null
          ? dateStartNext.toString()
          : "0001-01-01 00:00:00.000",
      'dateEndNext': dateEndNext != null
          ? dateEndNext.toString()
          : "0001-01-01 00:00:00.000",
      'sumTotal': sumTotal,
      'sumPayment': sumPayment,
      'sumDiscount': sumDiscount, */
      'export': export ? 1 : 0,
    };
  }

  bool checkState(List<String> filter) {
    return filter.indexOf(state) != -1;
  }

  String getShortAddress() {
    String outputAddress = customerAddress;

    final iReg = RegExp(r',');
    int cnt = iReg.allMatches(outputAddress).length;

    if (cnt > 3) {
      outputAddress = outputAddress.substring(outputAddress.indexOf(',') + 1);
      outputAddress =
          outputAddress.substring(outputAddress.indexOf(',') + 1).trimLeft();
    }

    /* TODO: return with short address + floor + intercom */
    return outputAddress;
  }
}
