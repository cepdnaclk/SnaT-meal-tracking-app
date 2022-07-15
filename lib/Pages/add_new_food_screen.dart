import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Components/Tab_Views/home_view.dart';
import 'package:mobile_app/Models/food_model.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';

final _firestore = FirebaseFirestore.instance;

List<String> SearchTerms = [];
List<Map> FoodandUnits = [];

class AddNewFoodScreen extends StatefulWidget {
  const AddNewFoodScreen(
      {required this.AppBarTitle,
      required this.ReloadState,
      required this.tileEdit,
      this.editTileDetails});
  final void Function() ReloadState;
  final Text AppBarTitle;
  final bool tileEdit;
  final void Function(String, String)? editTileDetails;

  @override
  State<AddNewFoodScreen> createState() => _AddNewFoodScreenState();
}

class _AddNewFoodScreenState extends State<AddNewFoodScreen> {
  void getFoodUnit(String foodResult) {
    for (Map food in FoodandUnits) {
      if (food['Food'] == foodResult) {
        unit = food['Units'];
      }
    }
    setState(() {});
  }

  final TextEditingController searchController = TextEditingController();

  final CustomSearchHintDelegate delegate =
      CustomSearchHintDelegate(hintText: 'Search your food Here');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.AppBarTitle,
        actions: [
          MaterialButton(
            onPressed: () async {
              //M.addMealItems(resultText, amount.toInt().toString() + unit);
              widget.ReloadState();
              //print(amount.toInt());
              //M.selectedMeal = M.selectedMeal;
              dateMeals[selectedMealTime] != null
                  ? dateMeals[selectedMealTime].add({
                      "food": result!.name,
                      'amount': amount.round(),
                      'unit': result!.unit,
                      'type': selectedMeal,
                      'iconCode': result!.iconCode,
                    })
                  : dateMeals[selectedMealTime] = [
                      {
                        "food": result!.name,
                        'amount': amount.round(),
                        'unit': result!.unit,
                        'type': selectedMeal,
                        'iconCode': result!.iconCode,
                      }
                    ];
              result = null;
              amount = 1;
              // await _firestore
              //     .collection('foodLog')
              //     .doc(selectedDate.toString())
              //     .collection(selectedMealTime.toString())
              //     .add({
              //   'food': resultText,
              //   'unit': unit,
              //   'amount': amount.toInt()
              // });
              Navigator.pop(context, amount);
            },
            child: const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () async {
          result = await showSearch<FoodModel?>(
            context: context,
            delegate: delegate,
          );
          if (result == null) {}
          if (result != null) {
            resultText = result!.name;
            getFoodUnit(resultText);
            if (widget.tileEdit == true) {
              widget.editTileDetails!(
                resultText,
                amount.toInt().toString() + " " + unit,
              );
            }
          }
          // setState(() {});
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result != null)
              Row(
                children: [
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.teal,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          resultText,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              children: const [
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

class CustomSearchHintDelegate extends SearchDelegate<FoodModel?> {
  CustomSearchHintDelegate({
    required String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildResults(BuildContext context) {
    List<FoodModel> matchQuery = [];
    for (FoodModel fruit in foodsData[selectedMeal]!) {
      if (fruit.name.toLowerCase() == (query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          FoodModel result = matchQuery[index];
          return ListTile(
            title: Text(result.name),
          );
        });
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<FoodModel> matchQuery = [];
    for (FoodModel fruit in foodsData[selectedMeal]!) {
      if (fruit.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          FoodModel result = matchQuery[index];
          return ListTile(
            onTap: () {
              showResults(context);
              Navigator.pop(context, result);
            },
            title: Text(result.name),
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
        icon: const Icon(Icons.arrow_back));
    throw UnimplementedError();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
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
            const Spacer(),
            Text(
              amount.toInt().toString() + " ",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Slider.adaptive(
          value: amount,
          divisions: 15,
          max: 15.0,
          label: "$amount",
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
