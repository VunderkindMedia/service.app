import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';

class Service {
  final int id;
  String state;
  DateTime createdAt;
  DateTime updatedAt;
  String externalId;
  String number;
  bool deleteMark;
  String status;
  DateTime dateStart;
  DateTime dateEnd;
  String cityId;
  String brandId;
  String customer;
  String customerAddress;
  String floor;
  String lat;
  String lon;
  bool intercom;
  bool thermalImager;
  String phone;
  String comment;
  String userId;
  String paymentType;
  String customerDecision;
  String refuseReason;
  String userComment;
  DateTime dateStartNext;
  DateTime dateEndNext;
  int sumTotal;
  int sumPayment;
  int sumDiscount;
  bool export;
  List<dynamic> serviceGoods;
  List<dynamic> serviceImages;

  Service(this.id);

  factory Service.fromJson(Map<String, dynamic> json) {
    var service = Service(json['ID']);

    service.state = json['state'];
    service.createdAt = DateTime.parse(json['CreatedAt']);
    service.updatedAt = DateTime.parse(json['UpdatedAt']);
    service.externalId = json['ExternalID'];
    service.number = json['Number'];
    service.deleteMark = json['DeleteMark'];
    service.status = json['Status'];
    service.dateStart = DateTime.parse(json['DateStart']);
    service.dateEnd = DateTime.parse(json['DateEnd']);
    service.cityId = json['CityID'];
    service.brandId = json['BrandID'];
    service.customer = json['Customer'];
    service.customerAddress = json['CustomerAddress'];
    service.floor = json['Floor'];
    service.lat = json['Lat'];
    service.lon = json['Lon'];
    service.intercom = json['Intercom'];
    service.thermalImager = json['ThermalImager'];
    service.phone = json['Phone'];
    service.comment = json['Comment'];
    service.userId = json['UserID'];
    service.sumTotal = json['SumTotal'];
    service.sumPayment = json['SumPayment'];
    service.sumDiscount = json['SumDiscount'];
    service.paymentType = json['PaymentType'];
    service.customerDecision = json['CustomerDecision'];
    service.refuseReason = json['RefuseReason'];
    service.userComment = json['UserComment'];
    service.dateStartNext = DateTime.parse(json['DateStartNext']);
    service.dateEndNext = DateTime.parse(json['DateEndNext']);
    service.export = false;

    var serviceGoods =
        json['ServiceGoods']?.map((json) => ServiceGood.fromJson(json)) ?? [];
    var serviceImages =
        json['ServiceImages']?.map((json) => ServiceImage.fromJson(json)) ?? [];

    if (serviceGoods.isNotEmpty) {
      service.serviceGoods = serviceGoods.toList();
    }

    if (serviceImages.isNotEmpty) {
      service.serviceImages = serviceImages.toList();
    }

    return service;
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    var service = Service(map['id']);

    service.state = map['state'];
    service.createdAt = DateTime.parse(map['createdAt']);
    service.updatedAt = DateTime.parse(map['updatedAt']);
    service.externalId = map['externalId'];
    service.number = map['number'];
    service.deleteMark = map['deleteMark'] == 1 ? true : false;
    service.status = map['status'];
    service.dateStart = DateTime.parse(map['dateStart']);
    service.dateEnd = DateTime.parse(map['dateEnd']);
    service.cityId = map['cityId'];
    service.brandId = map['brandId'];
    service.customer = map['customer'];
    service.customerAddress = map['customerAddress'];
    service.floor = map['floor'];
    service.lat = map['lat'];
    service.lon = map['lon'];
    service.intercom = map['intercom'] == 1 ? true : false;
    service.thermalImager = map['thermalImager'] == 1 ? true : false;
    service.phone = map['phone'];
    service.comment = map['comment'];
    service.userId = map['userId'];
    service.sumTotal = map['sumTotal'];
    service.sumPayment = map['sumPayment'];
    service.sumDiscount = map['sumDiscount'];
    service.paymentType = map['paymentType'];
    service.customerDecision = map['customerDecision'];
    service.refuseReason = map['refuseReason'];
    service.userComment = map['userComment'];
    service.dateStartNext = map['dateStartNext'] != null
        ? DateTime.parse(map['dateStartNext'])
        : null;
    service.dateEndNext =
        map['dateEndNext'] != null ? DateTime.parse(map['dateEndNext']) : null;
    service.export = map['export'] == 1 ? true : false;

    return service;
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
      'status': status,
      'dateStart': dateStart.toString(),
      'dateEnd': dateEnd.toString(),
      'cityId': cityId,
      'brandId': brandId,
      'customer': customer,
      'customerAddress': customerAddress,
      'floor': floor,
      'lat': lat,
      'lon': lon,
      'intercom': intercom ? 1 : 0,
      'thermalImager': thermalImager ? 1 : 0,
      'phone': phone,
      'comment': comment,
      'userId': userId,
      'paymentType': paymentType,
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
      'sumDiscount': sumDiscount,
      'export': export ? 1 : 0,
    };
  }

  bool checkStatus(List<String> filter) {
    return filter.indexOf(status) != -1;
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

    return outputAddress;
  }
}
