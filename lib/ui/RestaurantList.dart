import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:aciktim/ui/RestaurantDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class RestaurantList extends StatefulWidget {
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: getRestaurantList(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        List restaurants = snapshot.data;
        if (restaurants != null) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Card(
                  child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: restaurants[index]["Image"],
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(8.0)),
                                      color: Colors.green[400],
                                    ),
                                    child: Text(
                                      "${restaurants[index]["Points"][0]}",
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      "${restaurants[index]["Name"]}",
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.0),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  "min: ₺${restaurants[index]["MinPrice"]}",
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.red[800]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                onTap: () {
                  var router =
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RestaurantDetails(
                        restaurantID: restaurants[index]["_id"],
                        restaurantName: restaurants[index]["Name"],
                        imageURL: restaurants[index]["Image"]);
                  });
                  Navigator.of(context).push(router);
                },
              );
            },
            itemCount: restaurants.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        }
      },
    );
  }
}

Future<List> getRestaurantList() async {
  String apiUrl = "https://kalkanlisepeti.appspot.com/api/vendor";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
