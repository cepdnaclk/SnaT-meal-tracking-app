import 'package:flutter/material.dart';

import '../Theme/theme_info.dart';

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
        return DropdownButtonFormField<String>(
          iconEnabledColor: ThemeInfo.textFieldBorderColor,
          decoration: InputDecoration(
            fillColor: ThemeInfo.textFieldFillColor,
            filled: true,
            hintText: '',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeInfo.textFieldBorderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeInfo.textFieldBorderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeInfo.textFieldBorderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
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
        );
      },
    );
  }
}
