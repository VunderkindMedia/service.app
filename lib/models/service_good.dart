class ServiceGood {
  final int id;
  String workType;
  int serviceId;
  String construction;
  String goodId;
  int price;
  int qty;
  int sum;

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

    return serviceGood;
  }
}