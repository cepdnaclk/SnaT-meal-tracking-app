import 'package:flutter/material.dart';

class AddNewFoodScreen extends StatelessWidget {
  AddNewFoodScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  double amount = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new food"),
        actions: [
          GestureDetector(
            onTap: () {},
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
                    onPressed: () {},
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
