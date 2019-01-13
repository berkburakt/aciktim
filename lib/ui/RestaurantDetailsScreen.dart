import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:aciktim/model/food_item.dart';
import 'package:aciktim/util/ShoppingCardDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class RestaurantDetails extends StatefulWidget {
  final String restaurantID;
  final String restaurantName;
  final String imageURL;

  RestaurantDetails(
      {Key key, this.restaurantID, this.restaurantName, this.imageURL})
      : super(key: key);

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
          body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.red[800],
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    widget.restaurantName,
                    style: TextStyle(color: Colors.white),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imageURL),
                          fit: BoxFit.cover),
                    ),
                    child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 00.0, sigmaY: 00.0),
                      child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.black.withOpacity(0.6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Icon(Icons.star, color: Colors.yellow),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    "10",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 0.0, 0.0, 0.0),
                                  child: Icon(Icons.shopping_basket,
                                      color: Colors.grey),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: Text("₺10",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 0.0, 0.0, 0.0),
                                  child: Icon(Icons.access_time,
                                      color: Colors.grey),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: Text("09.00-12.00",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.menu),
                      ),
                      Tab(
                        icon: Icon(Icons.comment),
                      )
                    ],
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.blueGrey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.red,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              updateMenuList(widget.restaurantID),
              Container(
                color: Colors.yellow,
              ),
            ],
          ),
        ),
      )),
    );
  }
}

Future<Map> getMenuList(String restaurantID) async {
  String apiUrl = "https://kalkanlisepeti.appspot.com/api/vendor/$restaurantID";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}

_handleSaveFood(FoodItem foodItem) async {
  var db = new ShoppingCardDatabase();
  int savedItemId = await db.saveItem(foodItem);
  print(await db.getItem(savedItemId));
}

Widget updateMenuList(String restaurantID) {
  return FutureBuilder(
    future: getMenuList(restaurantID),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      try {
        List restaurantMenu = snapshot.data["Categories"];
        List menu = new List<ListItem>();

        for (int i = 0; i < restaurantMenu.length; i++) {
          menu.add(CategoryData(restaurantMenu[i]["Name"]));
          for (int j = 0; j < restaurantMenu[i]["Foods"].length; j++) {
            menu.add(FoodData(
                snapshot.data["_id"],
                restaurantMenu[i]["Foods"][j]["Name"],
                restaurantMenu[i]["Foods"][j]["Price"].toString(),
                restaurantMenu[i]["Foods"][j]["_id"]));
          }
        }

        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final item = menu[index];
            if (item is FoodData) {
              return GestureDetector(
                child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  child: Text(
                                    "${item.foodName}",
                                    style: TextStyle(
                                        fontFamily: "RobotoBold",
                                        fontSize: 15.0),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  child: Text("İçindekiler: ",
                                      style: TextStyle(
                                          fontFamily: "RobotoRegular",
                                          fontSize: 15.0,
                                          color: Colors.grey[500])),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  child: Text(
                                    "₺${item.foodPrice}",
                                    style: TextStyle(
                                        fontFamily: "RobotoBold",
                                        fontSize: 20.0,
                                        color: Colors.red[800]),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 32.0,
                          ),
                        )
                      ],
                    )),
                onTap: () {
                  FoodItem foodItem = FoodItem(item.vendorId, item.foodId,
                      item.foodName, item.foodPrice);
                  _handleSaveFood(foodItem);
                },
              );
            } else if (item is CategoryData) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                child: Text("${item.categoryName}",
                    style: TextStyle(fontFamily: "RobotoThin", fontSize: 25.0)),
              );
            }
          },
          itemCount: menu.length,
        );
      } catch (e) {
        print("ErrorCode 1: " + e.toString());
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        );
      }
    },
  );
}

abstract class ListItem {}

class FoodData implements ListItem {
  final String vendorId;
  final String foodId;
  final String foodName;
  final String foodPrice;

  FoodData(this.vendorId, this.foodName, this.foodPrice, this.foodId);
}

class CategoryData implements ListItem {
  final String categoryName;

  CategoryData(this.categoryName);
}
