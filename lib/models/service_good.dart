class ServiceGood {
  final String id;
  String workType;
  int serviceId;
  String construction;
  int goodId;
  int price;
  int qty;
  int sum;
  bool export;

  ServiceGood(this.id);

  factory ServiceGood.fromJson(Map<String, dynamic> json) {
    var serviceGood = ServiceGood(json['ID']);

    serviceGood.workType = json['WorkType'];
    serviceGood.serviceId = json['ServiceID'];
    serviceGood.construction = json['Construction'];
    serviceGood.goodId = json['GoodID'];
    serviceGood.price = json['Price'];
    serviceGood.qty = json['Qty'];
    serviceGood.sum = json['Summ'];
    serviceGood.export = false;

    return serviceGood;
  }

  factory ServiceGood.fromMap(Map<String, dynamic> map) {
    var serviceGood = ServiceGood(map['id']);

    serviceGood.workType = map['workType'];
    serviceGood.serviceId = map['serviceId'];
    serviceGood.construction = map['construction'];
    serviceGood.goodId = map['goodId'];
    serviceGood.price = map['price'];
    serviceGood.qty = map['qty'];
    serviceGood.sum = map['sum'];
    serviceGood.export = map['export'] == 1 ? true : false;

    return serviceGood;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workType': workType,
      'serviceId': serviceId,
      'construction': construction,
      'goodId': goodId,
      'price': price,
      'qty': qty,
      'sum': sum,
      'export': export ? 1 : 0,
    };
  }
}
