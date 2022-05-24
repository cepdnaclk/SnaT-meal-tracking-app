import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget(
      {Key? key,
      required this.items,
      this.hintText = "Select",
      required this.onChanged})
      : super(key: key);
  final List<String> items;
  final String hintText;
  final Function onChanged;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedMeal;
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            //labelStyle: textStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          //isEmpty: selectedMeal == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(widget.hintText),
              value: selectedMeal,
              isDense: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMeal = newValue;
                  widget.onChanged(selectedMeal);
                  state.didChange(newValue);
                });
              },
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
