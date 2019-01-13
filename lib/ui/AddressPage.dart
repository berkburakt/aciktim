import 'package:aciktim/model/address_item.dart';
import 'package:aciktim/util/AddressDatabase.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _textEditingControllerTitle = TextEditingController();
  final _textEditingControllerBody = TextEditingController();
  var db = new AddressDatabase();
  final List<AddressItem> _addressList = <AddressItem>[];

  @override
  void initState() {
    _readAddressItem();
    super.initState();
  }

  Widget updateAddressList() {
    return FutureBuilder(
        future: db.getCount(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != 0) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                    child: Text(
                      "Adreslerim",
                      style: TextStyle(
                        fontFamily: "RobotoThin",
                        fontSize: 24.9,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 1.0,
                  ),
                  Flexible(
                    child: ListView.builder(
                        reverse: false,
                        itemCount: _addressList.length,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(_addressList[index].title),
                              subtitle: Text(_addressList[index].body),
                              trailing: Listener(
                                key: Key(_addressList[index].body),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPointerDown: (pointerEvent) =>
                                    _deleteAddressItem(
                                        _addressList[index].id, index),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "Lütfen adres ekleyin",
                style: TextStyle(fontFamily: "RobotoThin", fontSize: 32.0),
              ),
            );
          }
        });
  }

  void _handleSubmitted(String title, String body) async {
    _textEditingControllerTitle.clear();
    _textEditingControllerBody.clear();
    AddressItem addressItem = AddressItem(title, body);
    int savedItemId = await db.saveItem(addressItem);

    AddressItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _addressList.add(addedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: updateAddressList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showFormDialog,
        tooltip: "Adres Ekle",
        child: new ListTile(
          title: Icon(Icons.add),
        ),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _textEditingControllerTitle,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Başlık",
                hintText: "Opsiyonel",
                icon: Icon(Icons.title)),
          ),
          TextField(
            controller: _textEditingControllerBody,
            decoration: InputDecoration(
                labelText: "Adres", icon: Icon(Icons.description)),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                _handleSubmitted(_textEditingControllerTitle.text,
                    _textEditingControllerBody.text);
                Navigator.pop(context);
              },
              child: Text("Kaydet"),
            ),
            FlatButton(
              onPressed: () {
                _textEditingControllerTitle.clear();
                _textEditingControllerBody.clear();
                Navigator.pop(context);
              },
              child: Text("İptal"),
            )
          ],
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  _readAddressItem() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _addressList.add(AddressItem.map(item));
      });
    });
  }

  _deleteAddressItem(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      _addressList.removeAt(index);
    });
  }
}
