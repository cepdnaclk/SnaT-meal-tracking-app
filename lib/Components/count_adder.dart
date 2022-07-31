import 'package:flutter/material.dart';
import 'package:mobile_app/Theme/theme_info.dart';

class CountAdder extends StatefulWidget {
  const CountAdder({
    Key? key,
    required this.onChanged,
    required this.isInt,
    this.validator,
    this.hasError = false,
    this.height,
    this.initialValue,
  }) : super(key: key);
  final Function onChanged;
  final bool isInt;
  final Function? validator;
  final double? height;
  final bool hasError;
  final double? initialValue;

  @override
  State<CountAdder> createState() => _CountAdderState();
}

class _CountAdderState extends State<CountAdder> {
  double count = 0;
  TextEditingController countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countController.text = (widget.initialValue ?? count.toInt()).toString();
    count = widget.initialValue ?? count;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? 60,
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: ThemeInfo.textFieldFillColor,
              border: Border.all(
                  width: 1,
                  color: widget.hasError
                      ? Colors.red[700]!
                      : ThemeInfo.textFieldBorderColor),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: countController,
                  onChanged: (val) {
                    count = (double.tryParse(val) ?? 0.0) < 0
                        ? 0.0
                        : (double.tryParse(val) ?? 0.0);
                    widget.onChanged(count);
                  },
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        count++;
                        countController.text = count.toString();
                        widget.onChanged(count);
                        setState(() {});
                      },
                      child: Container(
                        width: 50,
                        child: Icon(Icons.keyboard_arrow_up,
                            color: ThemeInfo.textFieldBorderColor),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: 1,
                                color: ThemeInfo.textFieldBorderColor),
                            bottom: BorderSide(
                                width: 1,
                                color: ThemeInfo.textFieldBorderColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print(count >= 1);
                        if (count > 1) {
                          count--;
                          countController.text = count.toString();
                          widget.onChanged(count);
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: 50,
                        child: Icon(Icons.keyboard_arrow_down,
                            color: count > 1
                                ? ThemeInfo.textFieldBorderColor
                                : ThemeInfo.disabledColor),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: 1,
                                color: ThemeInfo.textFieldBorderColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.hasError)
          Padding(
            padding: EdgeInsets.only(top: 5, left: 15),
            child: Text(
              "Invalid value",
              style: TextStyle(color: Colors.red[700], fontSize: 11),
            ),
          )
      ],
    );
  }
}
