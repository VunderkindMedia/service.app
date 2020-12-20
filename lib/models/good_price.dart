class GoodPrice {
  final int id;
  String period;
  String goodID;
  String cityID;
  String brandID;
  String name;
  int price;

  GoodPrice(this.id);

  factory GoodPrice.fromJson(Map<String, dynamic> json) {
    var goodPrice = GoodPrice(json['ID']);

    goodPrice.period = json['Period'];
    goodPrice.goodID = json['GoodID'];
    goodPrice.cityID = json['CityID'];
    goodPrice.brandID = json['BrandID'];
    goodPrice.name = json['Name'];
    goodPrice.price = json['Price'];

    return goodPrice;
  }
}