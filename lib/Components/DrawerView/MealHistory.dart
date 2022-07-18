import 'package:flutter/material.dart';
import 'package:mobile_app/Components/meal_tile.dart';

class MealHistory extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserPhotoWidget(),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: (Row(
                  children: <Widget>[
                    // ...
                    Expanded(
                      child: Column(
                        children: <Widget>[Divider(color: Colors.black)],
                      ),
                    )
                  ],
                )),
              ),
              Row(
                children: [
                  Text(
                    'Hariharan',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Container(
                color: Colors.white,
                child: (Row(
                  children: <Widget>[
                    // ...
                    Expanded(
                      child: Column(
                        children: <Widget>[Divider(color: Colors.black)],
                      ),
                    )
                  ],
                )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your History',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.more_vert_outlined,
                      color: Colors.grey[500],
                    )
                  ],
                ),
              ),
              HistoryCard(
                meal: {
                  "name": "Rice & Curry",
                  "icon": Icons.rice_bowl,
                  "amount": "2 cups"
                },
              ),
              HistoryCard(meal: {
                "name": "Bread",
                "icon": Icons.food_bank,
                "amount": "1 portion"
              }),
              HistoryCard(meal: {
                "name": "Tea",
                "icon": Icons.emoji_food_beverage,
                "amount": "1 cup"
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.3,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(180)),
            image: DecorationImage(
                image: AssetImage('assets/images/images.jpg'),
                fit: BoxFit.fill),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 240, right: 250),
        //   child: Container(
        //     height: size.height * 0.13,
        //     width: size.width,
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         border: Border.all(color: Colors.white, width: 2),
        //         image: DecorationImage(
        //           fit: BoxFit.contain,
        //           image: AssetImage('assets/images/man.png'),
        //         ),
        //         boxShadow: [
        //           BoxShadow(
        //               color: Colors.grey,
        //               offset: Offset(4.5, 4.5),
        //               spreadRadius: 2.5,
        //               blurRadius: 2.5)
        //         ]),
        //   ),
        // )
      ],
    );
  }
}

class HistoryCard extends StatelessWidget {
  final Map meal;
  // final String? name;
  // final String? foodUrl;
  const HistoryCard({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('assets/images/login.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${meal['name'] ?? 'Pizza'}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 30,
                        ),
                        // IconData(int.parse('0x' + meal["iconCode"]),
                        //     fontFamily: "MaterialIcons"),
                        Text(
                          meal["amount"].toString() + ' ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.star,
                    //       color: Colors.yellow,
                    //     ),
                    //     Text(
                    //       '45K',
                    //       style: TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.grey[700],
                    //           fontWeight: FontWeight.w500),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Veg",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
