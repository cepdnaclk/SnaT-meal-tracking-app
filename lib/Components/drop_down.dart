import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget(
      {Key? key,
      required this.items,
      this.validator,
      this.hintText = "Select",
      this.hasError = false,
      required this.onChanged})
      : super(key: key);
  final List<String> items;
  final String hintText;
  final Function onChanged;
  final validator;
  final bool hasError;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedMeal;
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.hasError ? Colors.red[700]! : Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration.collapsed(hintText: ''),
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
        );
      },
    );
  }
}
