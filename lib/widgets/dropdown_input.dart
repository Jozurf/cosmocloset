import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cosmocloset/utils/global_variables.dart';

class DropdownInput extends StatefulWidget {
  final List<String> itemList;
  final String hint;
  final TextEditingController dropdownController;
  const DropdownInput({super.key, required this.itemList, required this.hint, required this.dropdownController});

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(widget.hint, style: descriptionStyle,),
      value: dropDownValue,
      icon: const Icon(Icons.expand_more),
      onChanged: (newValue) {
        setState(() {
          dropDownValue = newValue;
        });
      },
      items: widget.itemList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      dropdownColor: textFieldColor,
      isExpanded: true,
      underline: const SizedBox(),
      style: buttonTextStyle,
      );
      
  }
}