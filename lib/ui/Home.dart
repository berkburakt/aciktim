import 'package:aciktim/ui/AddressPage.dart';
import 'package:aciktim/ui/RestaurantList.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> page = [
    RestaurantList(),
    Container(
      child: Center(
        child: Text(
          "Geçmiş Sipariş Yok",
          style: TextStyle(
              fontSize: 30.0, fontFamily: "RobotoThin", color: Colors.black),
        ),
      ),
    ),
    Container(
      child: Center(
        child: Text(
          "Sepet Boş",
          style: TextStyle(
              fontSize: 30.0, fontFamily: "RobotoThin", color: Colors.black),
        ),
      ),
    ),
    AddressPage(),
  ];

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _body() {
    return Stack(
      children: List<Widget>.generate(4, (int index) {
        return IgnorePointer(
          ignoring: index != _currentIndex,
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 250),
              opacity: _currentIndex == index ? 1.0 : 0.0,
              child: page[index]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Text(
          "Acıktım",
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: SafeArea(
          top: false,
          bottom: true,
          child: BottomNavigationBar(
              fixedColor: Colors.red,
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.fastfood),
                  title: new Text('Restorantlar'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.access_time),
                  title: new Text('Siparişler'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text('Sepet'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text('Profil'),
                )
              ])),
      body: _body(),
    );
  }
}
