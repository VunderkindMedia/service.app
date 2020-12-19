class Service {
  final int id;
  String createdAt;
  String updatedAt;
  String externalId;
  String number;
  bool deleteMark;
  String status;
  String dateStart;
  String dateEnd;
  String cityId;
  String brandId;
  String customer;
  String customerAddress;
  String floor;
  bool intercom;
  bool thermalImager;
  String phone;
  String comment;
  String userId;
  String paymentType;
  String customerDecision;
  String refuseReason;
  String userComment;
  String dateStartNext;
  String dateEndNext;
  int sumTotal;
  int sumPayment;
  int sumDiscount;

  Service(this.id);

  factory Service.fromJson(Map<String, dynamic> json) {
    var service = Service(json['ID']);

    service.createdAt = json['CreatedAt'];
    service.updatedAt = json['UpdatedAt'];
    service.externalId = json['ExternalID'];
    service.number = json['Number'];
    service.deleteMark = json['DeleteMark'];
    service.status = json['Status'];
    service.dateStart = json['DateStart'];
    service.dateEnd = json['DateEnd'];
    service.cityId = json['CityID'];
    service.brandId = json['BrandID'];
    service.customer = json['Customer'];
    service.customerAddress = json['CustomerAddress'];
    service.floor = json['Floor'];
    service.intercom = json['Intercom'];
    service.thermalImager = json['ThermalImager'];
    service.phone = json['Phone'];
    service.comment = json['Comment'];
    service.userId = json['UserID'];
    service.sumTotal = json['SummTotal'];
    service.sumPayment = json['SummPayment'];
    service.sumDiscount = json['SummDiscount'];
    service.paymentType = json['PaymentType'];
    service.customerDecision = json['CustomerDecision'];
    service.refuseReason = json['RefuseReason'];
    service.userComment = json['UserComment'];
    service.dateStartNext = json['DateStartNext'];
    service.dateEndNext = json['DateEndNext'];

    return service;
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    var service = Service(map['id']);

    service.createdAt = map['createdAt'];
    service.updatedAt = map['updatedAt'];
    service.externalId = map['externalId'];
    service.number = map['number'];
    service.deleteMark = map['deleteMark'] == 1 ? true : false;
    service.status = map['status'];
    service.dateStart = map['dateStart'];
    service.dateEnd = map['dateEnd'];
    service.cityId = map['cityId'];
    service.brandId = map['brandId'];
    service.customer = map['customer'];
    service.customerAddress = map['customerAddress'];
    service.floor = map['floor'];
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
    service.dateStartNext = map['dateStartNext'];
    service.dateEndNext = map['dateEndNext'];

    return service;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'externalId': externalId,
      'number': number,
      'deleteMark': deleteMark ? 1 : 0,
      'status': status,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'cityId': cityId,
      'brandId': brandId,
      'customer': customer,
      'customerAddress': customerAddress,
      'floor': floor,
      'intercom': intercom ? 1 : 0,
      'thermalImager': thermalImager ? 1 : 0,
      'phone': phone,
      'comment': comment,
      'userId': userId,
      'paymentType': paymentType,
      'customerDecision': customerDecision,
      'refuseReason': refuseReason,
      'userComment': userComment,
      'dateStartNext': dateStartNext,
      'dateEndNext': dateEndNext,
      'sumTotal': sumTotal,
      'sumPayment': sumPayment,
      'sumDiscount': sumDiscount
    };
  }
}
