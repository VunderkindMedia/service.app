class GoodPrice {
  final int id;
  String period;
  String goodId;
  String cityId;
  String brandId;
  String name;
  int price;

  GoodPrice(this.id);

  factory GoodPrice.fromJson(Map<String, dynamic> json) {
    var goodPrice = GoodPrice(json['ID']);

    goodPrice.period = json['Period'];
    goodPrice.goodId = json['GoodID'];
    goodPrice.cityId = json['CityID'];
    goodPrice.brandId = json['BrandID'];
    goodPrice.name = json['Name'];
    goodPrice.price = json['Price'];

    return goodPrice;
  }

  factory GoodPrice.fromMap(Map<String, dynamic> map) {
    var goodPrice = GoodPrice(map['ID']);

    goodPrice.period = map['period'];
    goodPrice.goodId = map['goodId'];
    goodPrice.cityId = map['cityId'];
    goodPrice.brandId = map['brandId'];
    goodPrice.name = map['name'];
    goodPrice.price = map['price'];

    return goodPrice;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'period': period,
      'goodId': goodId,
      'cityId': cityId,
      'brandId': brandId,
      'name': name,
      'price': price,
    };
  }
}