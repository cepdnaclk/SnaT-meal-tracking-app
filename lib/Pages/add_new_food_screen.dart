import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/Components/Tab_Views/home_view.dart';
import 'package:mobile_app/Components/count_adder.dart';
import 'package:mobile_app/Models/food_model.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:mobile_app/constants.dart';

class AddNewFoodScreen extends StatefulWidget {
  const AddNewFoodScreen({
    Key? key,
    required this.appBarTitle,
    required this.reloadState,
    required this.tileEdit,
  }) : super(key: key);
  final void Function() reloadState;
  final Text appBarTitle;
  final bool tileEdit;

  @override
  State<AddNewFoodScreen> createState() => _AddNewFoodScreenState();
}

class _AddNewFoodScreenState extends State<AddNewFoodScreen> {
  final TextEditingController searchController = TextEditingController();

  final CustomSearchHintDelegate delegate =
      CustomSearchHintDelegate(hintText: 'Search your food Here');

  @override
  void initState() {
    super.initState();
    print("12xs");
    print(result?.name);
  }

  @override
  void dispose() {
    result = null;
    amount1 = "1";
    editedIndex = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ThemeInfo.appBarColor,
        title: widget.appBarTitle,
        actions: [
          MaterialButton(
            onPressed: () async {
              double amount = double.parse(amount1);
              widget.reloadState();
              print(editedIndex);
              if (editedIndex != null) {
                dateMeals[selectedMealTime]
                    .replaceRange(editedIndex, editedIndex! + 1, [
                  {
                    "food": result!.name,
                    'amount': (2 * amount).ceilToDouble() / 2,
                    'unit': result!.unit,
                    'type': result!.mealType,
                    'iconCode': result!.iconCode,
                  }
                ]);
              } else {
                dateMeals[selectedMealTime] != null
                    ? dateMeals[selectedMealTime].add({
                        "food": result!.name,
                        'amount': (2 * amount).ceilToDouble() / 2,
                        'unit': result!.unit,
                        'type': result!.mealType,
                        'iconCode': result!.iconCode,
                      })
                    : dateMeals[selectedMealTime] = [
                        {
                          "food": result!.name,
                          'amount': (2 * amount).ceilToDouble() / 2,
                          'unit': result!.unit,
                          'type': result!.mealType,
                          'iconCode': result!.iconCode,
                        }
                      ];
              }
              result = null;
              amount = 1;
              amount1 = "1";
              editedIndex = null;
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
      /*floatingActionButton: FloatingActionButton(
        child: Icon(searchIcon),
        backgroundColor: ThemeInfo.appAndBottomBarColor,
        onPressed: () async {
          result = await showSearch<FoodModel?>(
            context: context,
            delegate: delegate,
          );
        },
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () async {
                result = await showSearch<FoodModel?>(
                  context: context,
                  delegate: delegate,
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: ThemeInfo.dropdownColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      result == null ? "Search food" : result!.name,
                      style: TextStyle(
                          color: result == null
                              ? Colors.grey[600]
                              : ThemeInfo.primaryTextColor,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    Icon(
                      searchIcon,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (result != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add servings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: CountAdder(
                            onChanged: (val) {
                              amount1 = val.toString();
                            },
                            isInt: false,
                            height: 50,
                            initialValue: double.parse(amount1),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      if (result != null)
                        Text(
                          result!.unit.replaceRange(
                              0, 1, result!.unit.substring(0, 1).toUpperCase()),
                          style: const TextStyle(fontSize: 17),
                        ),
                    ],
                  ),
                ],
              ),
            /*NumberInput(
              label: "Enter the amount",
              value: (double.parse(amount1).toInt() == double.parse(amount1)
                  ? double.parse(amount1).toInt().toString()
                  : amount1),
            )*/
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
  }

  @override
  Widget? buildLeading(BuildContext context) {
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
  }
}

class NumberInput extends StatelessWidget {
  const NumberInput({
    Key? key,
    required this.label,
    this.controller,
    this.value,
    this.onChanged,
    this.error,
    this.icon,
    this.allowDecimal = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? value;
  final String label;
  final Function? onChanged;
  final String? error;
  final Widget? icon;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: value,
      onChanged: (value) {
        amount1 = value;
      },
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(),
        ),
      ],
      decoration: InputDecoration(
        label: Text(label),
        errorText: error,
        icon: const Icon(Icons.rice_bowl),
      ),
    );
  }

  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
}
