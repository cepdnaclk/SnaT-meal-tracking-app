import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart' as M;
import 'package:mobile_app/Components/meal_tile.dart' as tile;
import 'package:mobile_app/Pages/add_a_meal_screen.dart';

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

//   @override
//   State<AddNewFoodScreen> createState() => _AddNewFoodScreenState();
// }
//
// class _AddNewFoodScreenState extends State<AddNewFoodScreen> {
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
            onPressed: () {
              M.addMealItems(resultText, amount.toInt().toString() + "kCals");
              ReloadState();
              print(amount.toInt());
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
          final String? result = await showSearch<String?>(
            context: context,
            delegate: delegate,
          );
          print('result: $result');
          resultText = result!;
          if (tileEdit == true) {
            editTileDetails!(resultText, amount.toInt().toString() + "kCals");
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
                Expanded(
                  child: TextField(
                    onTap: () {
                      // showSearch(
                      //     context: context, delegate: CustomSearchDelegate());
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "search",
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      // CustomSearchDelegate();
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ))
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
  List<String> SearchTerms = [
    'Apple',
    'Banana',
    'Pineapple',
    'Pears',
    'Watermelons',
    'Oranges',
    'Strawberries',
    'Grapes'
  ];
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
  double amount = 50;
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
            const Text(
              " kCals",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Slider(
          value: amount,
          onChanged: (val) {
            amount = val;
            widget.onChanged(val);
            setState(() {});
          },
          max: 100,
          min: 0,
        ),
      ],
    );
  }
}
