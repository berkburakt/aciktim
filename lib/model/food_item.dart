class FoodItem {
  String _vendorId;
  String _foodId;
  String _foodName;
  String _foodPrice;
  int _id;

  FoodItem(this._vendorId, this._foodId, this._foodName, this._foodPrice);

  FoodItem.map(dynamic obj) {
    this._vendorId = obj["vendorId"];
    this._foodId = obj["foodId"];
    this._foodName = obj["foodName"];
    this._foodPrice = obj["FoodPrice"];
    this._id = obj["id"];
  }

  String get vendorId => _vendorId;

  String get foodId => _foodId;

  String get foodName => _foodName;

  String get foodPrice => _foodPrice;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["vendorId"] = _vendorId;
    map["foodId"] = _foodId;
    map["foodName"] = _foodName;
    map["foodPrice"] = _foodPrice;

    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  FoodItem.fromMap(Map<String, dynamic> map) {
    this._vendorId = map["vendorId"];
    this._foodId = map["foodId"];
    this._foodName = map["foodName"];
    this._foodPrice = map["FoodPrice"];
    this._id = map["id"];
  }
}
