import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:cosmocloset/widgets/text_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ClothingOptions extends StatefulWidget {
  final Function retrieveAndSetOptions;
  final Map<String, dynamic> originalSpecifications;
  const ClothingOptions({super.key, required this.retrieveAndSetOptions, required this.originalSpecifications});

  @override
  State<ClothingOptions> createState() => _ClothingOptionsState();
}

class _ClothingOptionsState extends State<ClothingOptions> {
  TextEditingController _textEditingController = TextEditingController();
  String? dropDownValue;
  Color? selectedColor;
  bool _colorHasChanged = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.originalSpecifications['name'];
    dropDownValue = widget.originalSpecifications['clothingType'];
    selectedColor = Color(int.parse(widget.originalSpecifications['color']));
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //name,
        TextFieldInput(
          hintText: 'name your clothing',
          textEditingController: _textEditingController,
          textInputType: TextInputType.name,
        ),
        const SizedBox(
          height: 16,
        ),
        //type,
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButton<String>(
            hint: Text(
              "set clothing type",
              style: descriptionStyleBlack,
            ),
            value: dropDownValue,
            icon: const Icon(Icons.expand_more),
            onChanged: (newValue) {
              setState(() {
                dropDownValue = newValue;
              });
            },
            items: clothingTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: descriptionStyleBlack,
                ),
              );
            }).toList(),
            dropdownColor: textFieldColor,
            isExpanded: true,
            underline: const SizedBox(),
            style: descriptionStyle,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        //color,
        GestureDetector(
          onTap: () => showColorPicker(context),
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: buttonColor, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "set clothing color",
                  style: descriptionStyle,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: selectedColor,
                  ),
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
        _colorHasChanged == true
            ? Container(
                padding: const EdgeInsets.only(right: 8),
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: revertColorToOriginal,
                  child: Text(
                    "revert to original",
                    style: descriptionStyle,
                  ),
                ))
            : const SizedBox(),
      ]);
  }

  void showColorPicker(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("pick your color"),
          content: Column(
            children: [
              buildColorPicker(),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("close"))
            ],
          )));

  Widget buildColorPicker() => ColorPicker(
        pickerColor: selectedColor!,
        onColorChanged: (color) => setState(() {
          selectedColor = color;
          _colorHasChanged = true;
        }),
        enableAlpha: false,
        labelTypes: const [],
      );

  void revertColorToOriginal() {
    setState(() {
      selectedColor = Color(int.parse(widget.originalSpecifications['color']));
      _colorHasChanged = false;
    });
  }
}
