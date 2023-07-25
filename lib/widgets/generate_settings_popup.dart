import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:flutter/material.dart';

class GenerateSettingsPopup extends StatefulWidget {
  final Function setConsiderWeather;
  final Function setConsiderFormal;
  final bool initialConsiderWeather;
  final bool initialConsiderFormal;
  const GenerateSettingsPopup(
      {super.key,
      required this.setConsiderWeather,
      required this.setConsiderFormal,
      required this.initialConsiderWeather,
      required this.initialConsiderFormal});

  @override
  State<GenerateSettingsPopup> createState() => _GenerateSettingsPopupState();
}

class _GenerateSettingsPopupState extends State<GenerateSettingsPopup> {
  bool? currConsiderWeather;
  bool? currConsiderFormal;
  @override
  void initState() {
    super.initState();
    initStates();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Hero(
            tag: generateSettingsHero,
            child: Material(
              elevation: 2,
              color: panelColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "Generate based on weather",
                            style: descriptionStyle,
                          )),
                          Switch(
                              value: currConsiderWeather!,
                              onChanged: (value) {
                                setState(() {
                                  currConsiderWeather = value;
                                });
                                widget.setConsiderWeather(value);
                              })
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "Generate based on formality",
                            style: descriptionStyle,
                          )),
                          Switch(
                              value: currConsiderFormal!,
                              onChanged: (value) {
                                setState(() {
                                  currConsiderFormal = value;
                                });
                                widget.setConsiderFormal(value);
                              })
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "Features incoming...",
                            style: descriptionStyle,
                          )),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "include/exclude items or more!",
                            style: descriptionStyle,
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void initStates() {
    setState(() {
      currConsiderFormal = widget.initialConsiderFormal;
      currConsiderWeather = widget.initialConsiderWeather;
    });
  }
}
