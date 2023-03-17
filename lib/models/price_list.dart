class ListPrice {
  int? amountInMicros;
  String? currencyCode;

  ListPrice({this.amountInMicros, this.currencyCode});

  ListPrice.fromJson(Map<String, dynamic> json) {
    amountInMicros = json['amountInMicros'];
    currencyCode = json['currencyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountInMicros'] = amountInMicros;
    data['currencyCode'] = currencyCode;
    return data;
  }
}
