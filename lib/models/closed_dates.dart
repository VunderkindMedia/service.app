class ClosedDates {
  String cityId;
  String date;

  ClosedDates(this.cityId, this.date);

  factory ClosedDates.fromJson(Map<String, dynamic> json) {
    var goodPrice = ClosedDates(json['CityID'], json['Date']);
    return goodPrice;
  }

  factory ClosedDates.fromMap(Map<String, dynamic> map) {
    var goodPrice = ClosedDates(map['сityID'], map['date']);
    return goodPrice;
  }

  Map<String, dynamic> toMap() {
    return {
      'cityId': cityId,
      'date': date,
    };
  }
}
