import 'package:cosmocloset/resources/firestore_methods.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:cosmocloset/widgets/custom_animation.dart';
import 'package:cosmocloset/widgets/edit_buttons.dart';
import 'package:cosmocloset/widgets/hero_animation.dart';
import 'package:cosmocloset/widgets/more_clothing_settings.dart';
import 'package:cosmocloset/widgets/text_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditClothingPopup extends StatefulWidget {
  final Map<String, dynamic> specifications;
  const EditClothingPopup({super.key, required this.specifications});

  @override
  State<EditClothingPopup> createState() => _EditClothingPopupState();
}

class _EditClothingPopupState extends State<EditClothingPopup> {
  bool _isEditing = false;
  bool _isSaving = false;
  bool _colorHasChanged = false;
  int numberOfChanges = 0;
  final TextEditingController _textEditingController = TextEditingController();
  String? dropDownValue;
  Color? selectedColor;
  Uint8List? selectedImage;
  List<Map<String, dynamic>> optionsToShow = [];
  //additional settings
  bool? _canBeFormal;
  bool? _isWaterProof;
  bool? _isLight;
  bool? _areShorts;
  String? subTypes;

  @override
  void initState() {
    super.initState();
    initOptionsToShow();
    initStates();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: widget.specifications['clothingId'],
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: _isEditing == false
                    ? Image.network(
                        widget.specifications['photoUrl'],
                        fit: BoxFit.cover,
                      )
                    : InkWell(
                        onTap: () {
                          print("change image");
                        },
                        child: Image.network(
                          widget.specifications['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          _isEditing == false
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.specifications['name'],
                        style: titleStyle,
                      ),
                      Text(
                        widget.specifications['clothingType'],
                        style: descriptionStyle,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 100,
                          height: 20,
                          color:
                              Color(int.parse(widget.specifications['color'])),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(
                  height: 16,
                ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: _isEditing == false
                  // show the specifications of this category type
                  ? SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: optionsToShow.length,
                          itemBuilder: (context, index) {
                            // if feature is sub type then return a dropdown instead of Switch
                            String feature = optionsToShow[index]["feature"];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(feature),
                                Text(widget.specifications[feature].toString())
                              ],
                            );
                          }))
                  : SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: buttonColor, width: 1),
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
                                    numberOfChanges++;
                                  });
                                },
                                items: clothingTypes
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
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
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 12, bottom: 12),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: buttonColor, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            Row(
                              children: [
                                Text(
                                  "set more features (optional)",
                                  style: descriptionStyle,
                                ),
                                Hero(
                                    tag: editClothingSettingsHero,
                                    createRectTween: (begin, end) {
                                      return CustomRectTween(
                                          begin: begin!, end: end!);
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                          onPressed: showClothingSettings,
                                          icon: const Icon(
                                              Icons.settings_rounded)),
                                    ))
                              ],
                            ),
                          ]),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _isEditing == false
                  ? EditButtons(text: 'edit', function: switchToEditing)
                  : _isSaving == false
                      ? EditButtons(
                          text: 'save',
                          function: () => updateClothingHandler(
                              _textEditingController.text,
                              dropDownValue!,
                              selectedColor,
                              selectedImage,
                              widget.specifications['clothingId'],
                              widget.specifications['photoUrl'],
                              widget.specifications['clothingType']))
                      : EditButtons(text: 'saving...', function: () {}),
              _isEditing == false
                  ? EditButtons(text: 'cancel', function: navigateBack)
                  : EditButtons(text: 'cancel', function: getOutOfEditing)
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  void showColorPicker(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text(
            "pick your color",
          ),
          content: Column(
            children: [
              buildColorPicker(),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "close",
                    style: descriptionStyle,
                  ))
            ],
          )));

  Widget buildColorPicker() => ColorPicker(
        pickerColor: selectedColor!,
        onColorChanged: (color) => setState(() {
          selectedColor = color;
          _colorHasChanged = true;
          numberOfChanges++;
          print('numberOfChanges $numberOfChanges');
        }),
        enableAlpha: false,
        labelTypes: const [],
      );

  void revertColorToOriginal() {
    setState(() {
      selectedColor = Color(int.parse(widget.specifications['color']));
      _colorHasChanged = false;
    });
  }

  void navigateBack() {
    Navigator.of(context).pop();
  }

  void switchToEditing() {
    setState(() {
      dropDownValue = widget.specifications['clothingType'];
      selectedColor = Color(int.parse(widget.specifications['color']));
      _textEditingController.text = widget.specifications['name'];
      _isEditing = true;
      numberOfChanges = 0;
      print('numberOfChanges $numberOfChanges');
    });
  }

  void getOutOfEditing() {
    setState(() {
      dropDownValue = null;
      selectedColor = null;
      numberOfChanges = 0;
      _isEditing = false;
    });
  }

  void updateClothingHandler(
      String updatedName,
      String updatedClothingType,
      Color? updatedselectedColor,
      Uint8List? file,
      String clothingId,
      String originalImageUrl,
      String originalClothingType) async {
    Map<String, dynamic> additionalSettings = getAdditionalSettings();
    if (updatedName == widget.specifications['name'] && numberOfChanges == 0) {
      Navigator.of(context).pop();
    } else if (updatedName.isEmpty || updatedselectedColor == null) {
      showSnackBar("please give fill up the required fields", context);
    } else {
      try {
        setState(() {
          _isSaving = true;
        });
        String res = await FirestoreMethods().updateClothing(
            updatedName,
            file,
            updatedClothingType,
            updatedselectedColor.value.toString(),
            clothingId,
            originalImageUrl,
            originalClothingType,
            additionalSettings);
        setState(() {
          _isSaving = false;
        });
        if (res == "success") {
          showSnackBar("success!", context);
          // navigate back to closet
          Navigator.of(context).pop();
        } else {
          showSnackBar(res, context);
        }
      } catch (err) {
        showSnackBar(err.toString(), context);
      }
    }
  }

  void initOptionsToShow() {
    List<Map<String, dynamic>> result = [];
    result = typesToFeatures
        .where(
            (element) => element['id'] == widget.specifications['clothingType'])
        .toList();
    setState(() {
      optionsToShow = result;
    });
  }

  void showClothingSettings() {
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return MoreClothingSettings(
        heroTag: editClothingSettingsHero,
        clothingType: dropDownValue!,
        setFormal: setFormal,
        setAreShorts: setAreShorts,
        setLight: setLight,
        setWaterProof: setWaterProof,
        changeSubType: changeSubType,
        initialFormal: _canBeFormal,
        initialAreShorts: _areShorts,
        initialLight: _isLight,
        initialWaterproof: _isWaterProof,
        initialSubType: subTypes,
      );
    }));
  }

  void setFormal(bool value) {
    setState(() {
      _canBeFormal = value;
      numberOfChanges++;
      print('numberOfChanges $numberOfChanges');
    });
    print('formal :$_canBeFormal');
  }

  void setWaterProof(bool value) {
    setState(() {
      _isWaterProof = value;
      numberOfChanges++;
      print('numberOfChanges $numberOfChanges');
    });
    print('waterproof :$_isWaterProof');
  }

  void setLight(bool value) {
    setState(() {
      _isLight = value;
      numberOfChanges++;
      print('numberOfChanges $numberOfChanges');
    });
    print('is Light Jacket :$_isLight');
  }

  void setAreShorts(bool value) {
    setState(() {
      _areShorts = value;
      numberOfChanges++;
      print('numberOfChanges $numberOfChanges');
    });
    print('are shorts :$_areShorts');
  }

  void changeSubType(String subType) {
    setState(() {
      subTypes = subType;
      numberOfChanges++;
      print('numberOfChanges $numberOfChanges');
    });
    print('subtype :$subTypes');
  }

  Map<String, dynamic> getAdditionalSettings() {
    return {
      "formal": _canBeFormal,
      "waterproof": _isWaterProof,
      "light": _isLight,
      "shorts": _areShorts,
      "subtype": subTypes
    };
  }

  void initStates() {
    setState(() {
      _canBeFormal = widget.specifications['formal'];
      _isWaterProof = widget.specifications['waterproof'];
      _areShorts = widget.specifications['shorts'];
      _isLight = widget.specifications['light'];
      subTypes = widget.specifications['subtype'];
    });
  }
}
