import 'package:flutter/material.dart';

class DrawerTab extends StatelessWidget {
  const DrawerTab({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
