import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart' as M;

class AddNewFoodScreen extends StatelessWidget {
  AddNewFoodScreen({required this.AppBarTitle});

  final Text AppBarTitle;

  final TextEditingController searchController = TextEditingController();
  double amount = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle,
        actions: [
          GestureDetector(
            onTap: () {
              print(amount.toInt());
            },
            child: const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Save"),
            )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () {
                      showSearch(
                          context: context, delegate: CustomSearchDelegate());
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
                      showSearch(
                          context: context, delegate: CustomSearchDelegate());
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

class CustomSearchDelegate extends SearchDelegate {
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
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in SearchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        // M.addMealItems(fruit);
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
              M.addMealItems(result);
              showResults(context);
            },
            title: Text(result),
          );
        });
    // TODO: implement buildSuggestions
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
