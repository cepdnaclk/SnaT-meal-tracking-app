import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/Components/Tab_Views/home_view.dart';
import 'package:mobile_app/Models/food_model.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';

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
      appBar: AppBar(
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () async {
          result = await showSearch<FoodModel?>(
            context: context,
            delegate: delegate,
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
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
                          result!.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            NumberInput(
              label: "Enter the amount",
              value: (double.parse(amount1).toInt() == double.parse(amount1)
                  ? double.parse(amount1).toInt().toString()
                  : amount1),
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
