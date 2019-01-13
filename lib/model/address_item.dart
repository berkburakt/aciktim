class AddressItem {
  String _title;
  String _body;
  int _id;

  AddressItem(this._title, this._body);

  AddressItem.map(dynamic obj) {
    this._title = obj["title"];
    this._body = obj["body"];
    this._id = obj["id"];
  }

  String get title => _title;

  String get body => _body;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["title"] = _title;
    map["body"] = _body;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  AddressItem.fromMap(Map<String, dynamic> map) {
    this._title = map["title"];
    this._body = map["body"];
    this._id = map["id"];
  }
}
