import 'package:flutter/material.dart';

class Brand {
  final int id;
  String externalId;
  String name;
  String code;
  bool deleteMark;
  String brandColor;

  Brand(this.id);

  factory Brand.fromJson(Map<String, dynamic> json) {
    var brand = Brand(json['ID']);

    brand.externalId = json['ExternalID'];
    brand.name = json['Name'];
    brand.code = json['Code'];
    brand.deleteMark = json['DeleteMark'];
    brand.brandColor = json['BrandColor'];

    return brand;
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    var brand = Brand(map['id']);

    brand.externalId = map['externalId'];
    brand.name = map['name'];
    brand.code = map['code'];
    brand.deleteMark = map['deleteMark'] == 1 ? true : false;
    brand.brandColor = map['brandColor'];

    return brand;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'externalId': externalId,
      'name': name,
      'code': code,
      'deleteMark': deleteMark ? 1 : 0,
      'brandColor': brandColor,
    };
  }

  Color hexToColor(String code) {
    if (code != null && code != "") {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return Colors.grey;
    }
  }

  Color bColor() {
    var bColor;

    if (brandColor != '') {
      bColor = hexToColor(brandColor);
    } else {
      bColor = Colors.grey[200];
    }

    return bColor;
  }
}
