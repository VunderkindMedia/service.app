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
}