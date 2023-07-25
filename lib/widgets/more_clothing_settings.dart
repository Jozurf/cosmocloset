import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:flutter/material.dart';

class MoreClothingSettings extends StatefulWidget {
  final String heroTag;
  final String clothingType;
  final Function setFormal;
  final Function setWaterProof;
  final Function setLight;
  final Function setAreShorts;
  final Function changeSubType;
  final bool? initialFormal;
  final bool? initialWaterproof;
  final bool? initialAreShorts;
  final bool? initialLight;
  final String? initialSubType;

  const MoreClothingSettings(
      {super.key,
      required this.heroTag,
      required this.clothingType,
      required this.setFormal,
      required this.setWaterProof,
      required this.setAreShorts,
      required this.setLight,
      required this.changeSubType,
      required this.initialFormal,
      required this.initialWaterproof,
      required this.initialAreShorts,
      required this.initialLight,
      required this.initialSubType});

  @override
  State<MoreClothingSettings> createState() => _MoreClothingSettingsState();
}

class _MoreClothingSettingsState extends State<MoreClothingSettings> {
  List<Map<String, dynamic>> optionsToShow = [];
  bool? _currentFormal;
  bool? _currentWaterproof;
  bool? _currentAreShorts;
  bool? _currentLight;
  String?  _currentSubType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeOptionsToShow();
    initializeStateValues();
  }

  @override
  Widget build(BuildContext context) {
    
    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: optionsToShow.length,
    //     itemBuilder: (context, index) {
    //       return Text(optionsToShow[index]["feature"]);
    //     });

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Hero(
            tag: widget.heroTag,
            child: Material(
              elevation: 2,
              color: panelColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: optionsToShow.length,
                      itemBuilder: (context, index) {
                        // if feature is sub type then return a dropdown instead of Switch
                        String feature = optionsToShow[index]["feature"];
                        return feature != "subtype" ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(feature),
                            switchFunctions(feature),
                          ],
                        ) : DropdownButton<String>(
                          hint: Text(
                            "sub type",
                            style: descriptionStyleBlack,
                          ),
                          value: _currentSubType,
                          icon: const Icon(Icons.expand_more),
                          onChanged: (newValue) {
                            setState(() {
                              _currentSubType = newValue;
                            });
                            widget.changeSubType(_currentSubType);
                          },
                          items: accessoriesSubTypes
                              .map<DropdownMenuItem<String>>((String value) {
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
                        );
                      }),
                ),
              ),
            )),
      ),
    );
  }

  void initializeOptionsToShow() {
    List<Map<String, dynamic>> result = [];
    result = typesToFeatures
        .where((element) => element['id'] == widget.clothingType)
        .toList();
    setState(() {
      optionsToShow = result;
    });

  }
  
  Widget switchFunctions(String reference) {
    switch (reference) {
      case "shorts":
        return Switch(value: _currentAreShorts!, onChanged: (value) {
        setState(() {
          _currentAreShorts = value;
        });
        widget.setAreShorts(value);
      },);
      case "waterproof":
        return Switch(value: _currentWaterproof!, onChanged: (value) {
        setState(() {
          _currentWaterproof = value;
        });
        widget.setWaterProof(value);
      },);
      case "light" :
        return Switch(value: _currentLight!, onChanged: (value) {
        setState(() {
          _currentLight = value;
        });
        widget.setLight(value);
      },);
      default: return Switch(value: _currentFormal!, onChanged: (value) {
        setState(() {
          _currentFormal = value;
        });
        widget.setFormal(value);
      },);
    }
  }
  
  void initializeStateValues() {
    setState(() {
      _currentFormal = widget.initialFormal;
      _currentWaterproof = widget.initialWaterproof;
      _currentAreShorts = widget.initialAreShorts;
      _currentLight = widget.initialLight;
      _currentSubType = widget.initialSubType;
    });
  }
}
