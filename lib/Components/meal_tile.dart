import 'package:flutter/material.dart';

class MealTile extends StatelessWidget {
  const MealTile({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Map meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
      )),
      child: Row(
        children: [
          Icon(
            meal["icon"],
            size: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            meal["name"],
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                size: 30,
              ))
        ],
      ),
    );
  }
}
