import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart' as M;
import 'package:mobile_app/Components/meal_tile.dart' as tile;
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

String unit = "";
List<String> SearchTerms = [];
List<Map> FoodandUnits = [];

class AddNewFoodScreen extends StatelessWidget {
  AddNewFoodScreen(
      {required this.AppBarTitle,
      required this.ReloadState,
      required this.tileEdit,
      this.editTileDetails});
  final void Function() ReloadState;
  final Text AppBarTitle;
  final bool tileEdit;
  final void Function(String, String)? editTileDetails;

  void getFoodUnit(String foodResult) {
    // print("sdsds" + foodResult);
    for (Map food in FoodandUnits) {
      if (food['Food'] == foodResult) {
        print(food);
        unit = food['Units'];
        print(unit);
      }
    }
  }

  void updateFood() {}
  final TextEditingController searchController = TextEditingController();

  final CustomSearchHintDelegate delegate =
      CustomSearchHintDelegate(hintText: 'Search your food Here');

  double amount = 0.0;

  String resultText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle,
        actions: [
          MaterialButton(
            onPressed: () async {
              M.addMealItems(resultText, amount.toInt().toString() + unit);
              ReloadState();
              print(amount.toInt());
              M.selectedMeal = M.selectedMeal;
              await _firestore
                  .collection('foodLog')
                  .doc(selectedDate.toString())
                  .collection(selectedMealTime.toString())
                  .add({
                'food': resultText,
                'unit': unit,
                'amount': amount.toInt()
              });
              Navigator.pop(context, amount);
            },
            child: const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Save"),
            )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          String? result = await showSearch<String?>(
            context: context,
            delegate: delegate,
          );
          print('result: $result');
          if (result == null) {
            print("Please select a food");
          }
          if (result != null) {
            resultText = result;
            getFoodUnit(resultText);
            if (tileEdit == true) {
              editTileDetails!(resultText, amount.toInt().toString() + "kCals");
            }
          }
          // setState(() {});
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.teal,
              elevation: 10,
              child: Text(resultText),
            ),
            Row(
              children: [
                // Expanded(
                //   child: TextField(
                //     onTap: () {
                //       // showSearch(
                //       //     context: context, delegate: CustomSearchDelegate());
                //     },
                //     controller: searchController,
                //     decoration: const InputDecoration(
                //       hintText: "search",
                //       hintStyle: TextStyle(fontSize: 18),
                //       border: OutlineInputBorder(
                //         borderSide:
                //             BorderSide(color: Colors.blueAccent, width: 1.0),
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(32.0),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // IconButton(
                //     onPressed: () {
                //       // CustomSearchDelegate();
                //     },
                //     icon: const Icon(
                //       Icons.search,
                //       size: 30,
                //     ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SliderWidget(
              onChanged: (val) {
                amount = val;
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomSearchHintDelegate extends SearchDelegate<String?> {
  CustomSearchHintDelegate({
    required String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in SearchTerms) {
      if (fruit.toLowerCase() == (query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in SearchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            onTap: () {
              showResults(context);
              Navigator.pop(context, result);
            },
            title: Text(result),
          );
        });
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }

  // @override
  // PreferredSizeWidget buildBottom(BuildContext context) {
  //   return const PreferredSize(
  //       preferredSize: Size.fromHeight(56.0), child: Text('bottom'));
  // }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
    throw UnimplementedError();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            close(context, null);
          })
    ];
    // TODO: implement buildActions
    throw UnimplementedError();
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final Function onChanged;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double amount = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Amount",
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Text(
              amount.toInt().toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              unit,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Slider(
          value: amount,
          divisions: 15,
          max: 15.0,
          onChanged: (val) {
            amount = val;
            widget.onChanged(val);
            setState(() {});
          },
          min: 0,
        ),
      ],
    );
  }
}
