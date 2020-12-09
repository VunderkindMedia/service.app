import 'package:flutter/cupertino.dart';

class Service {
  final int id;
  String cratedAt;
  String updatedAt;
  String externalId;
  String number;
  bool deleteMark;
  String status;
  String dateStart;
  String dateEnd;
  int cityId;
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

  Service({
    @required this.id,
    this.customer,
    this.customerAddress,
    this.phone,
    this.comment,
    this.brandId,
    this.number,
    this.status
  });
}