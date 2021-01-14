class GoodPrice {
  final int id;
  String period;
  String goodId;
  String cityId;
  String brandId;
  String name;
  int price;

  GoodPrice(this.id, this.price);

  factory GoodPrice.fromJson(Map<String, dynamic> json) {
    var goodPrice = GoodPrice(json['ID'], 0);

    goodPrice.period = json['Period'];
    goodPrice.goodId = json['GoodID'];
    goodPrice.cityId = json['CityID'];
    goodPrice.brandId = json['BrandID'];
    goodPrice.name = json['Name'];
    goodPrice.price = json['Price'];

    return goodPrice;
  }

  factory GoodPrice.fromMap(Map<String, dynamic> map) {
    var goodPrice = GoodPrice(map['id'], 0);

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

  @override
  String toString() {
    if (price == 0) {
      return '0,0';
    }
    int rub = price ~/ 100;
    int cop = price % 100;
    return '$rub,$cop';
  }
}
